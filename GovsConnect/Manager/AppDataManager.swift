//
//  AppDataManager.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import CSV

class AppDataManager{
    private init(){}
    public static let shared = AppDataManager()
    var postsData = Array<PostsDataContainer>()
    var discoverData = Array<DiscoverItemDataContainer>()
    var discoverWeekendEventData = Array<Array<EventDataContainer>>()
    var discoverModifiedScheduleData = Array<EventDataContainer>()
    var discoverModifiedScheduleTitle = String()
    var oldDiscoverMenuData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
    var discoverMenuData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
    var discoverMenuTitle = ["", "", "", "", "", "", ""]
    var discoverLinksData = Array<DiscoverLinksDataCountainer>()
    var users = Dictionary<String, UserDataContainer>()
    var sportsGameData = Array<Array<SportsGame>>()
    var newPostDraft: (String, String, Array<UIImage>)? = nil
    var currentPersonID = ""{
        didSet{
            AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "currentPersonID"), newVal: self.currentPersonID, forKey: "value")
        }
    }
    var allStudent = Array<String>()
    var allFaculty = Array<String>()
    var allCourse = Array<String>()
    var allClub = Array<String>()
    var imageData = Dictionary<String, Data>()
    var profileImageData = Dictionary<String, Data>()
    var remoteNotificationData = Array<RemoteNotificationContainer>()
    var currentUserSetting = Dictionary<String, Bool>()
    var currentUserConnections = Array<String>()
    func isFirstTimeRunningApplication() -> Bool{
        let r = AppPersistenceManager.shared.fetchObject(with: .setting)
        if r.count == 0{
            return true
        }
        return false
    }
    
    func setUpDataForFirstTimeRun(){
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["currentPersonID", ""])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["someone posts", "false"])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["someone replied my comment", "true"])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["someone replied my post", "true"])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["someone liked my post", "true"])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["organization", ""])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["did see widget", "false"])
        AppPersistenceManager.shared.saveObject(to: .setting, with: ["dining hall menu tutorial", "false"])
    }
    
    public func setupData(){
        if self.isFirstTimeRunningApplication(){
            self.setUpDataForFirstTimeRun()
        }
        let settingData = AppPersistenceManager.shared.fetchObject(with: .setting) as! Array<Setting>
        for d in settingData{
            switch d.key!{
            case "currentPersonID":
                AppDataManager.shared.currentPersonID = d.value!
            case "someone posts":
                AppDataManager.shared.currentUserSetting["someone posts"] = Bool(d.value!)!
            case "someone replied my comment":
                AppDataManager.shared.currentUserSetting["someone replied my comment"] = Bool(d.value!)!
            case "someone replied my post":
                AppDataManager.shared.currentUserSetting["someone replied my post"] = Bool(d.value!)!
            case "someone liked my post":
                AppDataManager.shared.currentUserSetting["someone liked my post"] = Bool(d.value!)!
            case "organization":
                let organizationStr = "\(d.value!)"
                AppDataManager.shared.currentUserConnections = []
                for org_str in organizationStr.split(separator: "/"){
                    AppDataManager.shared.currentUserConnections.append("\(org_str)")
                }
            case "did see widget", "dining hall menu tutorial":
                break
            default:
                fatalError()
            }
        }
        if AppDataManager.shared.currentPersonID == ""{
            AppDataManager.shared.currentUserConnections = []
        }
        let imageData = AppPersistenceManager.shared.fetchObject(with: .imageData) as! Array<ImageData>
        for d in imageData{
            AppDataManager.shared.imageData[d.key!] = Data.init(referencing: d.data!)
        }
        let profileImageData = AppPersistenceManager.shared.fetchObject(with: .profileImageData) as! Array<ProfileImageData>
        for d in profileImageData{
            AppDataManager.shared.profileImageData[d.key!] = Data.init(referencing: d.data!)
        }
        
        let allStudent = self.loadStudentData()
        //0: uid
        //1: last name
        //2: first name
        //3: grade
        //4: state
        //5: email
        let allClubs = self.loadClubData()
        //0: uid
        //1: club name
        //2: club head
        //3: club advisor
        //4: hour
        //5: location
        //6: mission
        //7: goal
        let allFaculty = self.loadFacultyData()
        //0: uid
        //1: name
        //2: description
        //3: email
        
        var uids = Array<String>()
        for student in allStudent{
            uids.append(student[0])
        }
        for club in allClubs{
            uids.append(club[0])
        }
        for faculty in allFaculty{
            uids.append(faculty[0])
        }
        uids.append("ranpe001")
        uids.append("admin001")
        for uid in uids{
            if AppDataManager.shared.profileImageData[uid] != nil{
                continue
            }
            let imgName = "red_" + "\(uid.uppercased()[1])" + ".png"
            let data = UIImagePNGRepresentation(UIImage.init(named: imgName)!)!
            AppDataManager.shared.profileImageData[uid] = data
        }
        
        for student in allStudent{
            self.users[student[0]] = UserDataContainer.init(student[0], student[2] + " " + student[1], "0", .student, UserDataContainer.Department(rawValue: student[3])!, student[4] == "" ? "unknown" : student[4], [(student[5], true)])
            self.allStudent.append(student[0])
        }
        for club in allClubs{
            self.users[club[0]] = UserDataContainer.init(club[0], club[1], "0", .club, .clubDefault, "Governor's official " + club[1], [(club[2], true), (club[3], true), (club[4], true), (club[5], true), (club[6], true), (club[7], true)])
            self.allClub.append(club[0])
        }
        for faculty in allFaculty{
            self.users[faculty[0]] = UserDataContainer.init(faculty[0], faculty[1], "0", .facalty, .juniorEnglish, faculty[2], [(faculty[3], true)])
            self.allFaculty.append(faculty[0])
        }
        self.users["ranpe001"] = UserDataContainer.init("ranpe001", "Guest", "0", .admin, .senior, "Guest of the Governor's Academy App", [])
        self.users["admin001"] = UserDataContainer.init("admin001", "Admin", "0", .admin, .senior, "Admin of the Governor's Academy App", [])
        self.loadCourseData()
        
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_9.png", "Weekend Events"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_10.png", "Modified Schedule"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_8.jpg", "Dining Hall Menu"))
        self.discoverData.append(DiscoverItemDataContainer("system_discover_links.png", "Links"))
        self.discoverData.append(DiscoverItemDataContainer("system_more_full_image.png", ""))
        
        for _ in (0..<3){
            self.discoverWeekendEventData.append(Array<EventDataContainer>())
        }
//        self.discoverLinksData.append(DiscoverLinksDataCountainer(.website, "Veracross", "Your homework, grade, and everything.", "https://portals.veracross.com/gda/student"))
//        self.discoverLinksData.append(DiscoverLinksDataCountainer(.website, "The Governor's Academy", "School's official website.", "https://www.thegovernorsacademy.org/"))
//        self.discoverLinksData.append(DiscoverLinksDataCountainer(.snapchat, "Govs Event", "Know about what's going on at Govs.", "https://www.snapchat.com/add/govsevents"))
//        self.discoverLinksData.append(DiscoverLinksDataCountainer(.instagram, "Govs Trade", "A student organized trading platform which applies to all graders.", "instagram://user?username=govstrade"))
        
//        let eventsData = AppPersistenceManager.shared.fetchObject(with: .event) as! Array<Event>
//        for d in eventsData{
//            let event = EventDataContainer(d.startTime! as Date, d.endTime! as Date, d.title!, d.detail!)
//            event.notificationState = Int(d.notificationState)
//            let whichDay = whichDayOfWeekend(event.startTime)
//            AppDataManager.shared.discoverWeekendEventData[whichDay].append(event)
//        }
        
        //fake game data
        for _ in (0..<5){
            self.sportsGameData.append(Array<SportsGame>())
        }
    }
    
    private func loadCourseData(){
        let data = self.readDataFromCSV(fileName: "courseData", fileType: "csv")
        //data = cleanRows(file: data!)
        let csvRows = try! CSV.init(string: data!)
        while let row = csvRows.next(){
            let cur_uid = row[0]
            let cur_department_rawValue = row[1]
            let cur_class_name = row[2]
            let cur_length = row[3]
            let cur_is_required = row[4].lowercased()
            let cur_availibility = row[5]
            let cur_description = cur_class_name + ": " + row[6]
            let cur_profile_image_name = "blue_" + cur_uid.prefix(1).uppercased() + ".png"
            let cur_department = UserDataContainer.Department(rawValue: cur_department_rawValue)!
            self.users[cur_uid] = UserDataContainer.init(cur_uid, cur_class_name, cur_profile_image_name, .course, cur_department, cur_description, [(cur_description, true), (cur_length, true), (cur_department_rawValue, true), (cur_is_required, true), (cur_availibility, true),])
            self.allCourse.append(cur_uid)
        }
    }
    
    private func loadStudentData() -> [[String]]{
        let data = self.readDataFromCSV(fileName: "allStudents", fileType: "csv")
        var res = Array<Array<String>>()
        let csvRows = try! CSV.init(string: data!)
         while let row = csvRows.next(){
            res.append(row)
        }
        return res
    }
    
    private func loadClubData() -> [[String]]{
        let data = self.readDataFromCSV(fileName: "allClubs", fileType: "csv")
        var res = Array<Array<String>>()
        let csvRows = try! CSV.init(string: data!)
        while let row = csvRows.next(){
            res.append(row)
        }
        return res
    }
    
    private func loadFacultyData() -> [[String]]{
        let data = self.readDataFromCSV(fileName: "allFaculty", fileType: "csv")
        var res = Array<Array<String>>()
        let csvRows = try! CSV.init(string: data!)
        while let row = csvRows.next(){
            res.append(row)
        }
        return res
    }
    
    func loadLocalPostData(){
        let allLocalCommentData = AppPersistenceManager.shared.fetchObject(with: .comment) as! Array<Comment>
        var commentFinder = Dictionary<String, ReplyDataContainer>()
        for d in allLocalCommentData{
            let c = ReplyDataContainer(AppDataManager.shared.users[d.sender_uid!]!, AppDataManager.shared.users[d.receiver_uid!], d.body!, Int(d.like_count), d.is_liked)
            c._uid = Int(d.id!)!
            commentFinder[d.id!] = c
        }
        let allLocalPostData = AppPersistenceManager.shared.fetchObject(with: .post) as! Array<Post>
        for d in allLocalPostData{
            let c = PostsDataContainer(AppDataManager.shared.users[d.author_uid!]!, d.post_time!, d.title!, d.content!, Int(d.post_view_count), Int(d.post_like_count), Int(d.post_comment_count), d.is_viewed, d.is_liked, false)
            for commentId in d.comment_by_id!.split(separator: "/"){
                let newComment = commentFinder["\(commentId)"]
                guard newComment != nil else{
                    continue
                }
                c.replies.append(newComment!)
            }
            c._uid = Int(d.id!)!
            for image_url in d.post_image_url!.split(separator: "/"){
                c.postImagesName.append("\(image_url)")
            }
            AppDataManager.shared.insertPostByUid(c)
        }
        NotificationCenter.default.post(Notification.init(name: PostsViewController.shouldRefreashCellNotificationName))
    }
    
    func loadPostDataFromServerAndUpdateLocalData(){
        assert(AppIOManager.shared.connectionStatus != .none)
        AppIOManager.shared.loadNewestPost({
            NotificationCenter.default.post(Notification.init(name: PostsViewController.shouldRefreashCellNotificationName))
        }) { (errStr) in
            makeMessageViaAlert(title: "Error when fetching newest data", message: errStr)
        }
        //AppIOManager.shared.loadPostData(from: self.postsData.last?._uid ?? 0, to: NUMBER_OF_POST_PER_LOAD)
    }
    
    func loadDiscoverDataFromServerAndUpdateLocalData(){
        assert(AppIOManager.shared.connectionStatus != .none)
        let allEvents = AppPersistenceManager.shared.fetchObject(with: .event)
        for event in allEvents{
            AppPersistenceManager.shared.deleteObject(of: .event, with: event)
        }
        if AppDataManager.shared.discoverWeekendEventData[0].count +
            AppDataManager.shared.discoverWeekendEventData[1].count +
            AppDataManager.shared.discoverWeekendEventData[2].count == 0{
            AppIOManager.shared.loadWeekendEventData({ (isSucceed) in
                //success handler
            }) { (errStr) in
                makeMessageViaAlert(title: "Error when loading weekend event", message: errStr)
            }
        }
    
//        if AppDataManager.shared.discoverMenuData[0].count + AppDataManager.shared.discoverMenuData[1].count == 0{
//            AppIOManager.shared.loadFoodData { (isSucceed) in
//                //code here
//            }
//        }
    }
    
    func loadSportsDataFromServer(){
        let startDate = Date.yesterday.startOfTheDay
        let endDate = Calendar.current.date(byAdding: .day, value: 4, to: startDate)!.endOfTheDay
        AppIOManager.shared.getGameDataByRange(startDate: startDate, endDate: endDate, {
            //
        }) { (errStr) in
            makeMessageViaAlert(title: "Failed when loading Sports Data", message: errStr)
        }
        
    }

    func posts(by uid: String) -> (datas: [PostsDataContainer], index: [Int]){
        var indexes = [Int]()
        var datas = [PostsDataContainer]()
        for i in stride(from: 0, to: self.postsData.count, by: 1){
            if self.postsData[i].author.uid == uid{
                indexes.append(i)
                datas.append(self.postsData[i])
            }
        }
        return (datas, indexes)
    }
    
    func insertPostByUid(_ element: PostsDataContainer){
        for i in stride(from: 0, to: self.postsData.count, by: 1){
            if self.postsData[i]._uid < element._uid{
                self.postsData.insert(element, at: i)
                return
            }
        }
        self.postsData.append(element)
    }
    
    func findUserBy(email: String) -> String?{
        var res = AppDataManager.shared.allStudent.filter { (uid) -> Bool in
            return AppDataManager.shared.users[uid]!.information[0].str == email
        }
        if res.count == 0{
            res.append(
                AppDataManager.shared.allFaculty.filter { (uid) -> Bool in
                return AppDataManager.shared.users[uid]!.information[0].str == email
                }[0])
        }
        assert(res.count < 2)
        if res.count == 1{
            return res[0]
        }
        return nil
    }
}

class UserDataContainer{
    enum Profession: Int{
        case admin = 4
        case student = 3
        case facalty = 2
        case course = 1
        case club = 0
    }
    enum Department: String{
        case freshman = "freshman"
        case sophomore = "sophomore"
        case junior = "junior"
        case senior = "senior"
        case freshmanEnglish = "freshman english"
        case sophomoreEnglish = "sophomore english"
        case juniorEnglish = "junior english"
        case seniorEnglish = "senior english"
        case englishDepartment = "English"
        case mathmaticDepartment = "Mathematics"
        case historyAndSocialStudyDepartment = "History and Social Studies"
        case foreignLanguageDepartment = "Foreign Language"
        case scienceDepartment = "Science"
        case fineArtsDepartment = "Fine Arts"
        case clubDefault = "student orginization"
    }
    let uid: String
    let name: String
    let profession: Profession
    let department: Department
    var profilePictureName: String
    var description: String
    var posts = Array<PostsDataContainer>()
    var information: Array<(str: String, visible: Bool)>
    init(_ uid: String, _ name: String, _ profilePictureName: String, _ profession: Profession, _ department: Department, _ description: String, _ information: Array<(str: String, visible: Bool)> = Array<(str: String, visible: Bool)>()){
        self.uid = uid
        self.name = name
        self.profilePictureName = profilePictureName
        self.profession = profession
        self.department = department
        self.description = description
        self.information = information
    }
    
    func saveData(){
        
    }
}

class PostsDataContainer{
    var _uid: Int = -1
    var isHide: Bool = false
    let author: UserDataContainer
    let postDate: NSDate
    let postTitle: String
    let postContent: String
    var postImagesName = Array<String>()
    var viewCount: Int
    var likeCount: Int
    var commentCount: Int
    var isLikedByCurrentUser: Bool
    var isCommentedByCurrentUser: Bool
    var isViewedByCurrentUser: Bool
    var replies = Array<ReplyDataContainer>()
    init(_ author: UserDataContainer, _ postDate: NSDate, _ postTitle: String, _ postContent: String, _ viewCount: Int, _ likeCount: Int, _ commentCount: Int, _ isViewed: Bool, _ isLiked: Bool, _ isCommented: Bool){
        self.author = author
        self.postDate = postDate
        self.postTitle = postTitle
        self.postContent = postContent
        self.viewCount = viewCount
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLikedByCurrentUser = isLiked
        self.isViewedByCurrentUser = isViewed
        self.isCommentedByCurrentUser = isCommented
        self.author.posts.append(self)
    }
    deinit {
        self.author.posts = self.author.posts.filter{$0 !== self}
    }
}

class ReplyDataContainer{
    var _uid: Int = -1
    let sender: UserDataContainer
    let receiver: UserDataContainer?
    let body: String
    var likeCount: Int
    var isLikedByCurrentUser: Bool
    var is_hide = false
    init(_ sender: UserDataContainer, _ receiver: UserDataContainer?, _ body: String, _ likeCount: Int, _ isLiked: Bool){
        self.sender = sender
        self.receiver = receiver
        self.body = body
        self.likeCount = likeCount
        self.isLikedByCurrentUser = isLiked
    }
}

class DiscoverItemDataContainer{
    var coverImageName: String
    var coverTitle: String
    init(_ coverImageName: String, _ coverTitle: String) {
        self.coverImageName = coverImageName
        self.coverTitle = coverTitle
    }
}

class EventDataContainer{
    var startTime: Date
    var endTime: Date
    var realEndTime: Date
    var title: String
    var detail: String
    //notificationState:
    //  0: no notification
    //  1: 1 min
    //  2: 5 min
    //  3: 15 min
    //  4: 1 hour
    //  5: 2 hour
    //  6: 5 hour
    //  7: 1 day
    var notificationState: Int = 0
    init(_ startTime: Date, _ endTime: Date, _ title: String, _ detail: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.realEndTime = endTime
        self.title = title
        self.detail = detail
    }
}

class DiscoverFoodDataContainer{
    var title: String
    var imageName: String
    var likeCount: Int
    var dislikeCount: Int
    var _id = -1
    var isLunch: Bool
    var isSpecial: Bool
    init(_ title: String, _ imageName: String, _ likeCount: Int = 0, _ dislikeCount: Int = 0){
        self.title = title
        self.imageName = imageName
        self.likeCount = likeCount
        self.dislikeCount = dislikeCount
        self.isLunch = true
        self.isSpecial = true
    }
    init(_ id: Int, _ title: String, _ isLunch: Bool, _ isSpecial: Bool, _ likeCount: Int = 0){
        self._id = id
        self.title = title
        self.imageName = ""
        self.likeCount = likeCount
        self.dislikeCount = -1
        self.isLunch = isLunch
        self.isSpecial = isSpecial
    }
}

class RemoteNotificationContainer{
    var alertMessage: String
    var receivedTimeInterval: TimeInterval
    init(_ message: String, _ receivedTimeInterval: TimeInterval){
        self.alertMessage = message
        self.receivedTimeInterval = receivedTimeInterval
    }
}

class DiscoverLinksDataCountainer{
    let linkType: GCLinkType
    let title: String
    let description: String
    let link: String
    
    init(_ linkType: GCLinkType, _ title: String, _ description: String, _ link: String){
        self.linkType = linkType
        self.title = title
        self.description = description
        self.link = link
    }
}

extension AppDataManager{
    private func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    private func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
}
