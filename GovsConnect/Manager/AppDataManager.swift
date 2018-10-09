//
//  AppDataManager.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class AppDataManager{
    private init(){}
    public static let shared = AppDataManager()
    var postsData = Array<PostsDataContainer>()
    var discoverData = Array<DiscoverItemDataContainer>()
    var discoverWeekendEventData = Array<Array<EventDataContainer>>()
    var discoverMenuData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
    var discoverLinksData = Array<DiscoverLinksDataCountainer>()
    var users = Dictionary<String, UserDataContainer>()
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
        
        let ss = ["testing_profile_picture_1.png", "testing_profile_picture_2.png", "testing_profile_picture_3.png", "testing_profile_picture_jzm.png", "testing_profile_picture_dt.png", "testing_profile_picture_4.png", "testing_profile_picture_4.png"]
        let uids = ["jefwa001",
            "kevji001",
            "haosh001",
            "zemji001",
            "dontr001",
            "ranpe001",
            "unice001",
        ]
        for i in stride(from: 0, to: ss.count, by: 1){
            if AppDataManager.shared.profileImageData[uids[i]] != nil{
                continue
            }
            let data = UIImagePNGRepresentation(UIImage.init(named: ss[i])!)!
            AppDataManager.shared.profileImageData[uids[i]] = data
        }
        
        self.users["jefwa001"] = UserDataContainer.init("jefwa001", "Jeffrey Wang", "0", .student, .junior, "Beijing, China", [("jeffrey.wang@govsacademy.org", true)])
        self.users["kevji001"] = UserDataContainer.init("kevji001", "Kevin Jiang", "0", .student, .junior, "Beijing, China", [("kevin.jiang@govsacademy.org", true)])
        self.users["haosh001"] = UserDataContainer.init("haosh001", "Haodi Shi", "0", .student, .junior, "Yunnan, China", [("haodi.shi@govsacademy.org", true)])
        self.users["zemji001"] = UserDataContainer.init("zemji001", "Zemin Jiang", "0", .facalty, .sophomoreEnglish, "Shanghai, China", [("zemin.jaing@china.gov", true)])
        self.users["dontr001"] = UserDataContainer.init("dontr001", "Donald Trump", "0", .facalty, .juniorEnglish, "USA", [("donald.trump@trump.com", true)])
        self.users["ranpe001"] = UserDataContainer.init("ranpe001", "Random Person", "0", .student, .senior, "middle of nowhere", [("random.person@govsacademy.org", true)])
        self.users["advan001"] = UserDataContainer.init("advan001", "Advanced Precalculus with an Introduction to Calculus", "testing_profile_picture_4.png", .course, .mathmaticDepartment, "This is a year-long course with two major segments. The first portion of the course is an in-depth examination of ideas such as vectors, matrices, systems of linear and non-linear equations, sequences and series. The second portion of the course introduces students to the major themes of calculus, specifically the limit, the derivative, and the definite integral. This segment is designed to prepare students for a traditional college calculus course.", [("two semesters", true), ("mathmetics", true), ("false", true), ("9, 10, 11, 12", true), ("1", true), ("Science Building 301", true), ("Mr. Wang, Mr. Zhang and Mr. Lee", true)])
        self.users["unice001"] = UserDataContainer.init("unice001", "Unicef Club", "testing_profile_picture_4.png", .club, .clubDefault, "Governor's official Unicef club", [("Haodi Shi", true), ("Murphy Seminor Room, Frost Library", true), ("Thursday 6:00 PM", true)])
        self.allStudent.append("jefwa001")
        self.allStudent.append("kevji001")
        self.allStudent.append("haosh001")
        self.allStudent.append("ranpe001")
        self.allFaculty.append("zemji001")
        self.allFaculty.append("dontr001")
        self.allCourse.append("advan001")
        self.allClub.append("unice001")
        
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_4.jpg", "Weekend Events"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_5.jpg", "Daily Bulletin"))
        self.discoverData.append(DiscoverItemDataContainer("system_discover_links.png", "Links"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_8.jpg", "Rate Your Food"))
        self.discoverData.append(DiscoverItemDataContainer("system_more_full_image.png", ""))
        
        for _ in (0..<3){
            self.discoverWeekendEventData.append(Array<EventDataContainer>())
        }
        self.discoverLinksData.append(DiscoverLinksDataCountainer(.website, "Veracross", "Your homework, grade, and everything.", "https://portals.veracross.com/gda/student"))
        self.discoverLinksData.append(DiscoverLinksDataCountainer(.website, "The Governor's Academy", "School's official website.", "https://www.thegovernorsacademy.org/"))
        self.discoverLinksData.append(DiscoverLinksDataCountainer(.snapchat, "Govs Event", "Know about what's going on at Govs.", "https://www.snapchat.com/add/govsevents"))
        self.discoverLinksData.append(DiscoverLinksDataCountainer(.instagram, "Govs Trade", "A student organized trading platform which applies to all graders.", "itms-apps://itunes.apple.com/us/app/instagram/id389801252?mt=8"))
        
        let eventsData = AppPersistenceManager.shared.fetchObject(with: .event) as! Array<Event>
        for d in eventsData{
            let event = EventDataContainer(d.startTime! as Date, d.endTime! as Date, d.title!, d.detail!)
            event.notificationState = Int(d.notificationState)
            let whichDay = whichDayOfWeekend(event.startTime)
            AppDataManager.shared.discoverWeekendEventData[whichDay].append(event)
        }
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
        if AppDataManager.shared.discoverWeekendEventData[0].count +
            AppDataManager.shared.discoverWeekendEventData[1].count +
            AppDataManager.shared.discoverWeekendEventData[2].count == 0{
            AppIOManager.shared.loadWeekendEventData { (isSucceed) in
                
            }
        }
        if AppDataManager.shared.discoverMenuData[0].count + AppDataManager.shared.discoverMenuData[1].count == 0{
            AppIOManager.shared.loadFoodData { (isSucceed) in
                //code here
            }
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
        case student = 3
        case facalty = 2
        case course = 1
        case club = 0
    }
    enum Department: String{
        case freashmen = "freashmen"
        case sophomore = "sophomore"
        case junior = "junior"
        case senior = "senior"
        case freashmenEnglish = "freashmen english"
        case sophomoreEnglish = "sophomore english"
        case juniorEnglish = "junior english"
        case seniorEnglish = "senior english"
        case englishDepartment = "English"
        case mathmaticDepartment = "Mathmatics"
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
    init(_ title: String, _ imageName: String, _ likeCount: Int = 0, _ dislikeCount: Int = 0){
        self.title = title
        self.imageName = imageName
        self.likeCount = likeCount
        self.dislikeCount = dislikeCount
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

class DiscoverMatchDataContainer{
    let _uid: Int
    let catagory: GCSportType
    let team: GCSportTeamType
    let startTime: Date
    var isHome: Bool{
        get{
            return self.homeTeam == "The Governor's Academy"
        }
    }
    let homeTeam: String
    let awayTeam: String
    let homeScore: Int
    let awayScore: Int
    var isUpdateComplete: Bool
    
    init(_ _uid: Int, _ catagory: GCSportType, _ team: GCSportTeamType, _ startTime: Date, _ homeTeam: String, _ awayTeam: String, _ homeScore: Int, _ awayScore: Int, _ isUpdateComplete: Bool){
        self._uid = _uid
        self.catagory = catagory
        self.team = team
        self.startTime = startTime
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.isUpdateComplete = isUpdateComplete
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
