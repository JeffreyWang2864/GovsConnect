//
//  AppIOManager.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/8/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Reachability


typealias ReceiveResponseBlock = (Bool) -> ()

class AppIOManager{
    private init(){}
    var isLogedIn: Bool{
        get{
            return AppDataManager.shared.currentPersonID != ""
        }
    }
    static public let shared = AppIOManager()
    static public let loginActionNotificationName = Notification.Name.init("loginActionNotificationName")
    var connectionStatus: Reachability.Connection = .none
    var deviceToken: String? =  nil
    var isFirstTimeConnnected = true
    func establishConnection(){
        let reachability = Reachability()!
        reachability.whenReachable = { response in
            AppIOManager.shared.connectionStatus = response.connection
            if self.isFirstTimeConnnected{
                self.isFirstTimeConnnected = false
                AppDataManager.shared.loadDiscoverDataFromServerAndUpdateLocalData()
            }
            if self.isLogedIn{
                AppDataManager.shared.loadPostDataFromServerAndUpdateLocalData()
            }
        }
        reachability.whenUnreachable = { _ in
             makeMessageViaAlert(title: "You are in offline mode", message: "Your device is not connecting to the Internet. Loading local data")
            if AppIOManager.shared.connectionStatus == .wifi || AppIOManager.shared.connectionStatus == .cellular{
                AppIOManager.shared.connectionStatus = .none
                //switch from wifi/cellular to none
                return
            }
            // app inited with no connection to internet
            AppDataManager.shared.loadLocalPostData()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func loadImage(with id: String, _ completionHandler: @escaping (Data) -> ()){
        guard AppDataManager.shared.imageData[id] == nil else{
            return
        }
        let urlStr = APP_SERVER_URL_STR + "/assets/image/" + id
        request(urlStr).responseData { (response) in
            switch response.result{
            case .success(let data):
                AppPersistenceManager.shared.saveObject(to: .imageData, with: [id, data])
                completionHandler(data)
            case .failure(let error):
                makeMessageViaAlert(title: "download image failed", message: error.localizedDescription)
            }
        }
    }
    
    func loadFullImage(with id: String, _ completionHandler: @escaping (Data) -> (), errorHandler: @escaping () -> ()){
        let urlStr = APP_SERVER_URL_STR + "/assets/image_full/" + id
        request(urlStr).responseData { (response) in
            switch response.result{
            case .success(let data):
                let filteredObj = AppPersistenceManager.shared.filterObject(of: .imageData, with: NSPredicate(format: "key == %@", "\(id)"))!
                assert(filteredObj.count == 1)
                AppPersistenceManager.shared.deleteObject(of: .imageData, with: filteredObj[0])
                AppPersistenceManager.shared.saveObject(to: .imageData, with: [id, data])
                completionHandler(data)
            case .failure(let error):
                makeMessageViaAlert(title: "download full image failed", message: error.localizedDescription)
                errorHandler()
            }
        }
    }
    
    func loadProfileImage(with id: String, _ completionHandler: @escaping (Data) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/assets/profile_image/" + id
        request(urlStr).responseData { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data)
            case .failure(let error):
                makeMessageViaAlert(title: "download image failed", message: error.localizedDescription)
            }
        }
    }
    
    func addPost(parameters: [String: String], images: [UIImage], _ completionHandler: @escaping ReceiveResponseBlock){
        
        let urlStr = APP_SERVER_URL_STR + "/assets/image/add"
        upload(multipartFormData: { (multipartFormData) in
            for image in images{
                let ir = UIImageJPEGRepresentation(image, 0.5)!
                let fileName = "\(Int(NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970))" + ".\(random0to10000())"
                multipartFormData.append(ir, withName: fileName, fileName: fileName + ".jpg", mimeType: "image/jpg")
            }
            for(key, value) in parameters{
                 multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: urlStr) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                   completionHandler(true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadPostData(from: Int, to: Int){
        NSLog(APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)from\(from)to\(to)")
        request(APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)from\(from)to\(to)").responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                AppDataManager.shared.postsData = []
                while jsonDict["\(index)"] != JSON.null{
                    let data = jsonDict["\(index)"]
                    let author = AppDataManager.shared.users[data["author_uid"].stringValue]
                    let title = data["title"].stringValue
                    let content = data["content"].stringValue
                    let post_time = NSDate(timeIntervalSince1970: TimeInterval(data["post_time"].int!))
                    let postImageUrls = data["post_image_url"].stringValue.split(separator: "/")
                    let like_count = data["like_count"].int!
                    let view_count = data["view_count"].int!
                    let reply_count = data["reply_count"].int!
                    let isLiked = data["is_liked"].bool!
                    let isViewed = data["is_viewed"].bool!
                    let id = data["id"].int!
                    let container = PostsDataContainer.init(author!, post_time, title, content, view_count, like_count, reply_count, isViewed, isLiked, false)
                    for image_url in postImageUrls{
                        container.postImagesName.append("\(image_url)")
                    }
                    container._uid = id
                    index += 1
//                    let ifheif = AppPersistenceManager.shared.fetchObject(with: .post) as! Array<Post>
//                    for iefhje in ifheif{
//                        NSLog("\(iefhje.id!)")
//                    }
                    let apsres = AppPersistenceManager.shared.filterObject(of: .post, with: NSPredicate(format: "id == %@", "\(id)")) as! Array<Post>
                    assert(apsres.count <= 2)
                    if apsres.count == 1{
                        let obj = apsres[0]
                        obj.is_liked = isLiked
                        obj.is_viewed = isViewed
                        obj.post_comment_count = Int16(reply_count)
                        obj.post_like_count = Int16(like_count)
                        obj.post_view_count = Int16(view_count)
                        try!AppPersistenceManager.shared.context.save()
                    }else{
                        AppPersistenceManager.shared.saveObject(to: .post, with: [data["author_uid"].stringValue, true, title, content, post_time, data["post_image_url"].stringValue, isLiked, Int16(like_count), isViewed, Int16(view_count), Int16(reply_count), id, ""])
                    }
                    NSLog("saved one to post, \(id)")
                    AppDataManager.shared.insertPostByUid(container)
                }
                NotificationCenter.default.post(Notification.init(name: PostsViewController.shouldRefreashCellNotificationName))
            case .failure(let error):
                makeMessageViaAlert(title: "Error when loading Post data from server", message: "\(error)")
            }
        }
    }
    
    func del_post(post_id: Int, _ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/post/del_\(post_id)_uid=" + AppDataManager.shared.currentPersonID
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "error when deleting data", message: error.localizedDescription)
            }
        }
    }
    
    func loadReplyData(local_post_id: Int, _ completionHandler: @escaping ReceiveResponseBlock){
        let post_id = AppDataManager.shared.postsData[local_post_id]._uid
        let urlStr = APP_SERVER_URL_STR + "/post/\(post_id)/uid=\(AppDataManager.shared.currentPersonID)_replies"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                self.__loadReplyData(JSON(json), local_post_id)
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "Error when loading Reply at post \(post_id) data from server", message: "\(error.localizedDescription)")
            }
        }
    }
    
    func addReply(at local_post_id: Int, postData: Dictionary<String, String>, _ completionHandler: @escaping ReceiveResponseBlock){
        let post_id = AppDataManager.shared.postsData[local_post_id]._uid
        let urlStr = APP_SERVER_URL_STR + "/post/add_reply/"
        var postData = postData
        postData["post_id"] = "\(post_id)"
        request(urlStr, method: .post, parameters: postData as Dictionary<String, AnyObject>, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                self.__loadReplyData(JSON(json), local_post_id)
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "Error when loading Reply at post \(post_id) data from server", message: "\(error.localizedDescription)")
            }
        }
    }
    
    func delReply(at local_post_id: Int, reply_id: Int, _ completionHandler: @escaping ReceiveResponseBlock){
        let post_id = AppDataManager.shared.postsData[local_post_id]._uid
        let urlStr = APP_SERVER_URL_STR + "/post/\(post_id)/del_reply\(reply_id)_uid=\(AppDataManager.shared.currentPersonID)"
        NSLog(urlStr)
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                self.__loadReplyData(JSON(json), local_post_id)
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "Error when loading Reply at post \(post_id) data from server", message: "\(error.localizedDescription)")
            }
        }
    }
    
    func likeReply(local_post_id: Int, reply_id: Int, _ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/post/like_reply\(reply_id)_uid=\(AppDataManager.shared.currentPersonID)"
        NSLog(urlStr)
        request(urlStr).responseString { (response) in
            switch response.result{
            case .success(let str):
                if str == "success"{
                    completionHandler(true)
                }else{
                    makeMessageViaAlert(title: "failed", message: str)
                }
            case .failure(let error):
                makeMessageViaAlert(title: "like reply failed", message: error.localizedDescription)
            }
        }
    }
    
    func dislikeReply(local_post_id: Int, reply_id: Int, _ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/post/dislike_reply\(reply_id)_uid=\(AppDataManager.shared.currentPersonID)"
        request(urlStr).responseString { (response) in
            switch response.result{
            case .success(let str):
                if str == "success"{
                    completionHandler(true)
                }else{
                    makeMessageViaAlert(title: "failed", message: str)
                }
            case .failure(let error):
                makeMessageViaAlert(title: "like reply failed", message: error.localizedDescription)
            }
        }
    }
    
    private func __loadReplyData(_ jsonDict: JSON, _ local_post_id: Int){
        var index = 0
        var comments_by_id = ""
        AppDataManager.shared.postsData[local_post_id].replies = []
        while jsonDict["\(index)"] != JSON.null{
            let data = jsonDict["\(index)"]
            let sender_uid = data["sender_uid"].string!
            let receiver_uid = data["receiver_uid"].string!
            let body = data["body"].string!
            let like_count = data["like_count"].int!
            let is_liked = data["is_liked"].bool!
            let id = data["id"].int!
            let container = ReplyDataContainer(AppDataManager.shared.users[sender_uid]!, AppDataManager.shared.users[receiver_uid], body, like_count, is_liked)
            container._uid = id
            let commentPreses = AppPersistenceManager.shared.filterObject(of: .comment, with: NSPredicate(format: "id == %@", "\(id)"))!
            assert(commentPreses.count <= 1)
            if commentPreses.count == 1{
                AppPersistenceManager.shared.deleteObject(of: .comment, with: commentPreses[0])
            }
            AppPersistenceManager.shared.saveObject(to: .comment, with: [String(id), sender_uid, receiver_uid, body, like_count, is_liked])
            comments_by_id += "\(id)/"
            AppDataManager.shared.postsData[local_post_id].replies.append(container)
            index += 1
        }
        let ppores = AppPersistenceManager.shared.filterObject(of: .post, with: NSPredicate(format: "id == %@", "\(AppDataManager.shared.postsData[local_post_id]._uid)")) as! Array<Post>
        assert(ppores.count == 1)
        let postPersistanceObject = ppores[0]
        postPersistanceObject.comment_by_id = comments_by_id
        try! AppPersistenceManager.shared.context.save()
    }
    
    func view(at post_id: Int){
        request(APP_SERVER_URL_STR + "/post/\(post_id)/viewed_by_uid=\(AppDataManager.shared.currentPersonID)")
    }
    
    func like(at post_id: Int, method: String, _ completionHandler: @escaping ReceiveResponseBlock){
        assert(method == "plus" || method == "minus")
        let urlStr = APP_SERVER_URL_STR + "/post/\(post_id)/liked_by_uid=\(AppDataManager.shared.currentPersonID)" + "method=\(method)"
        NSLog(urlStr)
        request(urlStr).responseString { (response) in
            switch response.result{
            case .success(let str):
                if str == "success"{
                    completionHandler(true)
                }else{
                    makeMessageViaAlert(title: "failed", message: str)
                }
            case .failure(let error):
                makeMessageViaAlert(title: "like/dislike failed", message: error.localizedDescription)
            }
        }
    }
    
    func loadWeekendEventData(_ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/discover/weekend_event"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                AppDataManager.shared.discoverWeekendEventData[0] = []
                AppDataManager.shared.discoverWeekendEventData[1] = []
                AppDataManager.shared.discoverWeekendEventData[2] = []
                while(jsonDict["\(index)"] != JSON.null){
                    let data = jsonDict["\(index)"]
                    let start_time_interval = data["start_time"].intValue - secondsFromGMT
                    let end_time_interval = data["end_time"].intValue - secondsFromGMT
                    let title = data["title"].stringValue
                    let detail = data["detail"].stringValue
                    let event = EventDataContainer(Date(timeIntervalSince1970: TimeInterval(start_time_interval)), Date(timeIntervalSince1970: TimeInterval(end_time_interval)), title, detail)
                    let whichDay = whichDayOfWeekend(event.startTime)
                    AppDataManager.shared.discoverWeekendEventData[whichDay].append(event)
                    AppPersistenceManager.shared.saveObject(to: .event, with: [event.startTime, event.endTime, event.title, event.detail, event.notificationState])
                    index += 1
                }
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "get weekend_event failed", message: error.localizedDescription)
            }
        }
    }
    
    func loadFoodData(_ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/discover/food"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                var index = 0
                let jsonDict = JSON(json)
                AppDataManager.shared.discoverMenuData[0] = []
                AppDataManager.shared.discoverMenuData[1] = []
                while jsonDict["\(index)"] != JSON.null{
                    let data = jsonDict["\(index)"]
                    let foodName = data["name"].stringValue
                    let is_lunch = data["is_lunch"].boolValue
                    let imgStr = data["image_id"].stringValue
                    let id = data["id"].intValue
                    let foodData = DiscoverFoodDataContainer(foodName, imgStr)
                    foodData._id = id
                    self.loadImage(with: imgStr, { (data) in
                        AppDataManager.shared.imageData[imgStr] = data
                    })
                    AppDataManager.shared.discoverMenuData[btoi(!is_lunch)].append(foodData)
                    index += 1
                }
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "error when load food", message: error.localizedDescription)
            }
        }
    }
    
    func foodDataAction(food_id: Int, method: String, _ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/discover/food/id=\(food_id)_method=" + method
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "error when like/dislike food", message: error.localizedDescription)
            }
        }
    }
    
    func updateProfileImage(){
        var uploadData = Dictionary<String, AnyObject>()
        var epoch = 0
        for(uid, userData) in AppDataManager.shared.users{
            if userData.profession == .club || userData.profession == .course{
                continue
            }
            uploadData["\(epoch)"] = "\(uid)_\(userData.profilePictureName)" as AnyObject
            epoch += 1
        }
        let urlStr = APP_SERVER_URL_STR + "/assets/user_image_get/"
        request(urlStr, method: .post, parameters: uploadData, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonData = JSON(json)
                epoch = 0
                while jsonData["\(epoch)"] != JSON.null{
                    let curData = jsonData["\(epoch)"]
                    let uid = curData["uid"].stringValue
                    let index = curData["index"].stringValue
                    let id = curData["id"].stringValue
                    AppIOManager.shared.loadProfileImage(with: id, { (data) in
                        AppDataManager.shared.profileImageData[uid] = data
                        if !AppPersistenceManager.shared.updateObject(of: .profileImageData, with: NSPredicate(format: "key == %@", uid), newVal: data, forKey: "data"){
                            AppPersistenceManager.shared.saveObject(to: .profileImageData, with: [uid, data])
                        }
                    })
                    AppDataManager.shared.users[uid]!.profilePictureName = index
                    epoch += 1
                }
            case .failure(let error):
                makeMessageViaAlert(title: "error when updating profile images", message: error.localizedDescription)
            }
        }
    }
    
    func changeProfileImage(newImage: UIImage, _ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/assets/user_image_change/"
        upload(multipartFormData: { (multipartFormData) in
            let imgData = UIImageJPEGRepresentation(newImage, 0.2)!
            let fileName = "\(Int(NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970))" + ".\(random0to10000())"
            multipartFormData.append(imgData, withName: fileName, fileName: fileName + ".jpg", mimeType: "image/jpg")
            multipartFormData.append( AppDataManager.shared.currentPersonID.data(using: String.Encoding.utf8)!, withName: "uid")
        }, to: urlStr) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    completionHandler(true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getLogin(email: String, _ completionHandler: @escaping (String?, String?) -> Void){
        let urlStr = APP_SERVER_URL_STR + "/assets/login/"
        request(urlStr, method: .post, parameters: ["email": email] as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let isPassed = jsonDict["pass"].boolValue
                var password: String? = nil
                var uid: String? = nil
                if isPassed{
                    password = jsonDict["password"].stringValue
                    uid = jsonDict["uid"].stringValue
                }
                completionHandler(password, uid)
            case .failure(let error):
                makeMessageViaAlert(title: "get passwd failed", message: error.localizedDescription)
            }
        }
    }
    
    func getAccessCodeStatus(accessCode: String, _ completionHandler: @escaping (Bool) -> Void, _ failureHandler: @escaping () -> Void){
        let urlStr = APP_SERVER_URL_STR + "/assets/login/"
        request(urlStr, method: .post, parameters: ["access_code": accessCode] as Dictionary<String, AnyObject>, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let isPassed = jsonDict["pass"].boolValue
                completionHandler(isPassed)
            case .failure(let error):
                makeMessageViaAlert(title: "get access code status failed", message: error.localizedDescription)
            }
        }
    }
    
    func loginSuccessful( _ completionHandler: @escaping () -> Void, _ errorHandler: @escaping (String) ->Void){
        let urlStr = APP_SERVER_URL_STR + "/assets/login_successful/"
//        guard AppIOManager.shared.deviceToken != nil else{
//            //running on an simulator
//            return
//        }
        let postData = ["access_token": AppIOManager.shared.deviceToken ?? "", "uid": AppDataManager.shared.currentPersonID]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                AppDataManager.shared.currentUserSetting["someone posts"] = jsonDict["someone posts"].boolValue
                AppDataManager.shared.currentUserSetting["someone replied my comment"] = jsonDict["someone replied my comment"].boolValue
                AppDataManager.shared.currentUserSetting["someone replied my post"] = jsonDict["someone replied my post"].boolValue
                AppDataManager.shared.currentUserSetting["someone liked my post"] = jsonDict["someone liked my post"].boolValue
                let organizationStr = jsonDict["organization"].stringValue
                AppDataManager.shared.currentUserConnections = []
                for item in organizationStr.split(separator: "/"){
                    AppDataManager.shared.currentUserConnections.append("\(item)")
                }
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone posts"), newVal: jsonDict["someone posts"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my comment"), newVal: jsonDict["someone replied my comment"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my post"), newVal: jsonDict["someone replied my post"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone liked my post"), newVal: jsonDict["someone liked my post"].stringValue, forKey: "value"))
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func userChangeSetting(_ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/assets/user_change_setting/"
        let postData: Dictionary<String, AnyObject> = [
            "uid": AppDataManager.shared.currentPersonID as AnyObject,
            "someone posts": AppDataManager.shared.currentUserSetting["someone posts"] as AnyObject,
            "someone liked my post": AppDataManager.shared.currentUserSetting["someone liked my post"] as AnyObject,
            "someone replied my post": AppDataManager.shared.currentUserSetting["someone replied my post"] as AnyObject,
            "someone replied my comment": AppDataManager.shared.currentUserSetting["someone replied my comment"] as AnyObject
        ]
        request(urlStr, method: .post, parameters: postData, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "make change on user setting failed", message: error.localizedDescription)
            }
        }
    }
    
    func logOut(_ completionHandler: @escaping ReceiveResponseBlock){
        let urlStr = APP_SERVER_URL_STR + "/assets/logout/"
        let postData = ["uid": AppDataManager.shared.currentPersonID]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler(true)
            case .failure(let error):
                makeMessageViaAlert(title: "failed to log out", message: error.localizedDescription)
            }
        }
    }
    
    func connectToOrganization(passphrase: String, _ completionHandler: @escaping (Bool, String?) -> Void, _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/post/connect_to_organization"
        let postData = ["passphrase": passphrase, "uid": AppDataManager.shared.currentPersonID]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let pass = jsonDict["pass"].boolValue
                if pass{
                    completionHandler(pass, jsonDict["uid"].stringValue)
                }else{
                    completionHandler(pass, nil)
                }
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func disconnectToOrganization(org: String, _ completionHandler: @escaping (Bool) -> Void, _ errorHandler: @escaping (String) ->Void){
        let urlStr = APP_SERVER_URL_STR + "/post/disconnect_to_organization"
        let postData = ["org_uid": org, "query_uid": AppDataManager.shared.currentPersonID]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let pass = jsonDict["pass"].boolValue
                completionHandler(pass)
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
}
