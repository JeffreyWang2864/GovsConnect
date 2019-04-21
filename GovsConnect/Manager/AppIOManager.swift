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
//        NotificationCenter.default.addObserver(self, selector: #selector(self.nnnnn(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        reachability.whenReachable = { response in
            AppIOManager.shared.connectionStatus = response.connection
            if self.isFirstTimeConnnected{
                self.isFirstTimeConnnected = false
                AppDataManager.shared.loadDiscoverDataFromServerAndUpdateLocalData()
                AppDataManager.shared.loadSportsDataFromServer()
                
            }
            if self.isLogedIn{
                AppIOManager.shared.loginSuccessful(target_uid: AppDataManager.shared.currentPersonID, {(isAgreeToTerms: Bool) in
                    AppDataManager.shared.loadPostDataFromServerAndUpdateLocalData()
                }, { (errStr) in
                    makeMessageViaAlert(title: "Unable to log you in", message: errStr)
                })
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
            AppIOManager.shared.connectionStatus = .none
            AppDataManager.shared.loadLocalPostData()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
//    @objc func nnnnn(_ notification: Notification){
//        let reachbility = notification.object as! Reachability
//        if reachbility.connection == .wifi{
//            makeMessageViaAlert(title: "wifi", message: "")
//        }else if reachbility.connection == .none{
//            makeMessageViaAlert(title: "none", message: "")
//        }
//    }
    
    func createSession(with deviceToken: String){
        var uploadData = Dictionary<String, Any>()
        let urlStr = APP_SERVER_URL_STR + "/assets/session/"
        uploadData["access_token"] = deviceToken as Any
        uploadData["from_version"] = APP_CURRENT_VERSION as Any
        request(urlStr, method: .post, parameters: uploadData, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                //success
                break
            case .failure(let error):
                //upload session id failed
                break
            }
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
    
    func addPost(parameters: [String: String], images: [UIImage], _ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
        
        let urlStr = APP_SERVER_URL_STR + "/assets/image/add"
        upload(multipartFormData: { (multipartFormData) in
            for image in images{
                let ir = UIImageJPEGRepresentation(image, 0.5)!
                let fileName = "\(Int(NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970))" + ".\(random0to1000()).\(random0to1000())"
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
                errorHandler(error.localizedDescription)
            }
        }
    }
    
//    func loadPostData(from: Int, to: Int){
//        NSLog(APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)from\(from)to\(to)")
//        request(APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)from\(from)to\(to)").responseJSON { (response) in
//            switch response.result{
//            case .success(let json):
//                let jsonDict = JSON(json)
//                var index = 0
//                AppDataManager.shared.postsData = []
//                while jsonDict["\(index)"] != JSON.null{
//                    let data = jsonDict["\(index)"]
//                    let author = AppDataManager.shared.users[data["author_uid"].stringValue]
//                    let title = data["title"].stringValue
//                    let content = data["content"].stringValue
//                    let post_time = NSDate(timeIntervalSince1970: TimeInterval(data["post_time"].int!))
//                    let postImageUrls = data["post_image_url"].stringValue.split(separator: "/")
//                    let like_count = data["like_count"].int!
//                    let view_count = data["view_count"].int!
//                    let reply_count = data["reply_count"].int!
//                    let isLiked = data["is_liked"].bool!
//                    let isViewed = data["is_viewed"].bool!
//                    let id = data["id"].int!
//                    let container = PostsDataContainer.init(author!, post_time, title, content, view_count, like_count, reply_count, isViewed, isLiked, false)
//                    for image_url in postImageUrls{
//                        container.postImagesName.append("\(image_url)")
//                    }
//                    container._uid = id
//                    index += 1
////                    let ifheif = AppPersistenceManager.shared.fetchObject(with: .post) as! Array<Post>
////                    for iefhje in ifheif{
////                        NSLog("\(iefhje.id!)")
////                    }
//                    let apsres = AppPersistenceManager.shared.filterObject(of: .post, with: NSPredicate(format: "id == %@", "\(id)")) as! Array<Post>
//                    assert(apsres.count <= 2)
//                    if apsres.count == 1{
//                        let obj = apsres[0]
//                        obj.is_liked = isLiked
//                        obj.is_viewed = isViewed
//                        obj.post_comment_count = Int16(reply_count)
//                        obj.post_like_count = Int16(like_count)
//                        obj.post_view_count = Int16(view_count)
//                        try!AppPersistenceManager.shared.context.save()
//                    }else{
//                        AppPersistenceManager.shared.saveObject(to: .post, with: [data["author_uid"].stringValue, true, title, content, post_time, data["post_image_url"].stringValue, isLiked, Int16(like_count), isViewed, Int16(view_count), Int16(reply_count), id, ""])
//                    }
//                    NSLog("saved one to post, \(id)")
//                    AppDataManager.shared.insertPostByUid(container)
//                }
//                NotificationCenter.default.post(Notification.init(name: PostsViewController.shouldRefreashCellNotificationName))
//            case .failure(let error):
//                makeMessageViaAlert(title: "Error when loading Post data from server", message: "\(error)")
//            }
//        }
//    }
    
    func loadNewestPost(_ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)"
        request(urlStr).responseJSON { (response) in
            switch(response.result){
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                AppDataManager.shared.postsData = []
                let objs = AppPersistenceManager.shared.fetchObject(with: .post)
                for obj in objs{
                    AppPersistenceManager.shared.deleteObject(of: .post, with: obj)
                }
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
                    //NSLog("saved one to post, \(id)")
                    AppDataManager.shared.insertPostByUid(container)
                }
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func loadNextPostData(from right: Int, _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)_from\(right)"
        request(urlStr).responseJSON { (response) in
            switch(response.result){
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
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
                    //NSLog("saved one to post, \(id)")
                    AppDataManager.shared.insertPostByUid(container)
                    
                }
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func loadPostData(by uid: String, _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/post/uid=\(AppDataManager.shared.currentPersonID)_by=\(uid)"
        request(urlStr).responseJSON { (response) in
            switch(response.result){
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
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
                    if !AppDataManager.shared.postsData.contains(where: { (data) -> Bool in
                        return data._uid == container._uid
                    }){
                        AppDataManager.shared.insertPostByUid(container)
                    }
                }
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func del_post(post_id: Int, _ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> Void){
        let urlStr = APP_SERVER_URL_STR + "/post/del_\(post_id)_uid=" + AppDataManager.shared.currentPersonID
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler(true)
            case .failure(let error):
                errorHandler(error.localizedDescription)
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
                guard AppIOManager.shared.connectionStatus != .none else{
                    return
                }
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
        if ppores.count == 1{
            let postPersistanceObject = ppores[0]
            postPersistanceObject.comment_by_id = comments_by_id
            try! AppPersistenceManager.shared.context.save()
        }
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
    
    func loadWeekendEventData(_ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
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
                    let real_end_time_interval = data["real_end_time"].intValue - secondsFromGMT
                    let event = EventDataContainer(Date(timeIntervalSince1970: TimeInterval(start_time_interval)), Date(timeIntervalSince1970: TimeInterval(end_time_interval)), title, detail)
                    event.realEndTime = Date.init(timeIntervalSince1970: TimeInterval(real_end_time_interval))
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
    
    func loadModifiedScheduleData(_ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/discover/modified_schedule_from_app"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                AppDataManager.shared.discoverModifiedScheduleData = []
                if jsonDict["modified_schedule"] != JSON.null{
                    AppDataManager.shared.discoverModifiedScheduleTitle = jsonDict["modified_schedule"].stringValue
                }
                while(jsonDict["\(index)"] != JSON.null){
                    let data = jsonDict["\(index)"]
                    let start_time_interval = data["start_time"].intValue - secondsFromGMT
                    let end_time_interval = data["end_time"].intValue - secondsFromGMT
                    let title = data["title"].stringValue
                    let event = EventDataContainer(Date(timeIntervalSince1970: TimeInterval(start_time_interval)), Date(timeIntervalSince1970: TimeInterval(end_time_interval)), title, "")
                    AppDataManager.shared.discoverModifiedScheduleData.append(event)
                    index += 1
                }
                completionHandler(true)
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func loadFoodData(_ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/discover/food"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                var index = 0
                let jsonDict = JSON(json)
                AppDataManager.shared.oldDiscoverMenuData[0] = []
                AppDataManager.shared.oldDiscoverMenuData[1] = []
                while jsonDict["\(index)"] != JSON.null{
                    let data = jsonDict["\(index)"]
                    let foodName = data["name"].stringValue
                    let is_lunch = data["is_lunch"].boolValue
                    let id = data["id"].intValue
                    let foodData = DiscoverFoodDataContainer(foodName, "")
                    foodData._id = id
//                    self.loadImage(with: imgStr, { (data) in
//                        AppDataManager.shared.imageData[imgStr] = data
//                    })
                    AppDataManager.shared.oldDiscoverMenuData[btoi(!is_lunch)].append(foodData)
                    index += 1
                }
                completionHandler(true)
            case .failure(let error):
                errorHandler(error.localizedDescription)
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
    
    func loadFoodDataThisWeek(_ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/discover/food_this_week"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
                AppDataManager.shared.discoverMenuData = []
                AppDataManager.shared.discoverMenuTitle = []
                for day in days{
                    let dayJsonDict = jsonDict[day]
                    var dayArr = Array<DiscoverFoodDataContainer>()
                    var index = 0
                    while dayJsonDict["\(index)"] != JSON.null{
                        let data = dayJsonDict["\(index)"]
                        let foodName = data["name"].stringValue
                        let is_lunch = data["is_lunch"].boolValue
                        let id = data["id"].intValue
                        let is_everyday = data["is_everyday"].boolValue
                        let is_special = !is_everyday
                        let like_count = data["like_count"].intValue
                        let foodData = DiscoverFoodDataContainer.init(id, foodName, is_lunch, is_special, like_count)
                        dayArr.append(foodData)
                        index += 1
                    }
                    AppDataManager.shared.discoverMenuData.append(dayArr)
                    let dayTitle = jsonDict["discover_food_title_" + day].stringValue
                    AppDataManager.shared.discoverMenuTitle.append(dayTitle)
                }
                completionHandler(true)
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func loadLinkData(_ completionHandler: @escaping ReceiveResponseBlock, _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/discover/link"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                var index = 0
                let jsonDict = JSON(json)
                AppDataManager.shared.discoverLinksData = []
                while jsonDict["\(index)"] != JSON.null{
                    let data = jsonDict["\(index)"]
                    let title = data["title"].stringValue
                    let description = data["description"].stringValue
                    let url = data["url"].stringValue
                    let url_type = data["url_type"].stringValue
                    let linkData = DiscoverLinksDataCountainer(GCLinkType(rawValue: url_type)!, title, description, url)
                    AppDataManager.shared.discoverLinksData.append(linkData)
                    index += 1
                }
                completionHandler(true)
            case .failure(let error):
                errorHandler(error.localizedDescription)
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
            let imageCompressed = newImage.resized(toWidth: 100)!
            let imgData = UIImageJPEGRepresentation(imageCompressed, 0.75)!
            let fileName = "\(Int(NSDate.init(timeIntervalSinceNow: 0).timeIntervalSince1970))" + ".\(random0to1000()).\(random0to1000())"
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
    func getAccessCodeStatus(accessCode: String, _ completionHandler: @escaping (Bool, String?) -> Void, _ failureHandler: @escaping () -> Void){
        let urlStr = APP_SERVER_URL_STR + "/assets/login/"
        request(urlStr, method: .post, parameters: ["access_code": accessCode] as Dictionary<String, AnyObject>, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                let isPassed = jsonDict["pass"].boolValue
                if isPassed{
                    completionHandler(isPassed, jsonDict["uid"].stringValue)
                }else{
                    completionHandler(isPassed, nil)
                }
            case .failure(let error):
                makeMessageViaAlert(title: "get access code status failed", message: error.localizedDescription)
            }
        }
    }
    
    func loginSuccessful(target_uid: String, _ completionHandler: @escaping (Bool) -> Void, _ errorHandler: @escaping (String) ->Void){
        let urlStr = APP_SERVER_URL_STR + "/assets/login_successful/"
//        guard AppIOManager.shared.deviceToken != nil else{
//            //running on an simulator
//            return
//        }
        let postData = ["access_token": AppIOManager.shared.deviceToken ?? "", "uid": target_uid]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                AppDataManager.shared.currentPersonID = target_uid
                let jsonDict = JSON(json)
                AppDataManager.shared.currentUserSetting["someone posts"] = jsonDict["someone posts"].boolValue
                AppDataManager.shared.currentUserSetting["someone replied my comment"] = jsonDict["someone replied my comment"].boolValue
                AppDataManager.shared.currentUserSetting["someone replied my post"] = jsonDict["someone replied my post"].boolValue
                AppDataManager.shared.currentUserSetting["someone liked my post"] = jsonDict["someone liked my post"].boolValue
                let organizationStr = jsonDict["organization"].stringValue
                let isAgreeToTerms = jsonDict["is agree to terms"].boolValue
                AppDataManager.shared.currentUserConnections = []
                for item in organizationStr.split(separator: "/"){
                    AppDataManager.shared.currentUserConnections.append("\(item)")
                }
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone posts"), newVal: jsonDict["someone posts"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my comment"), newVal: jsonDict["someone replied my comment"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my post"), newVal: jsonDict["someone replied my post"].stringValue, forKey: "value"))
                assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone liked my post"), newVal: jsonDict["someone liked my post"].stringValue, forKey: "value"))
                if !AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "organization"), newVal: jsonDict["organization"].stringValue, forKey: "value"){
                    AppPersistenceManager.shared.saveObject(to: .setting, with: ["organization", jsonDict["organization"].stringValue])
                }
                completionHandler(isAgreeToTerms)
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
    
    func report(postData: [String: AnyObject], _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/post/report"
        request(urlStr, method: .post, parameters: postData, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func userAgree(uid: String, _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/assets/user_agree/"
        request(urlStr, method: .post, parameters: ["uid": uid] as Dictionary<String, AnyObject>, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func getGameDataByRange(startDate: Date, endDate: Date, _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        //let urlStr = APP_SERVER_URL_STR + "/sport/game-by-range"
        let urlStr = APP_SERVER_URL_STR + "/sport/game-by-range"
        let postData = [
            "START_TIMESTAMP": startDate.timeIntervalSince1970,
            "END_TIMESTAMP": endDate.timeIntervalSince1970,
        ]
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
//            if let data = response.data {
//                let json = String(data: data, encoding: String.Encoding.utf8)
//                print("Failure Response: \(json)")
//            }
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                let dayCatagory: Array<Date> = [
                    startDate.noon,
                    startDate.dayAfter.noon,
                    startDate.dayAfter.dayAfter.noon,
                    startDate.dayAfter.dayAfter.dayAfter.noon,
                    startDate.dayAfter.dayAfter.dayAfter.dayAfter.noon,
                ]
                //clear all previous records
                for i in stride(from: 0, to: AppDataManager.shared.sportsGameData.count, by: 1){
                    AppDataManager.shared.sportsGameData[i] = []
                }
                while(jsonDict["\(index)"] != JSON.null){
                    let curData = jsonDict["\(index)"]
                    let uid = curData["uid"].stringValue
                    let team = GCSportTeamType.init(rawValue: curData["team"].stringValue) ?? GCSportTeamType.default
                    let team_catagory = GCSportType.init(rawValue: curData["team_category"].stringValue) ?? GCSportType.default
                    let start_time = Date.init(timeIntervalSince1970: curData["start_time"].doubleValue - Double(secondsFromGMT))
                    let home_team = curData["home_team"].stringValue
                    let away_team = curData["away_team"].stringValue
                    let latitude = curData["latitude"].doubleValue
                    let longitude = curData["longitude"].doubleValue
                    let home_score = curData["home_score"].intValue
                    let away_score = curData["away_score"].intValue
                    let nw = curData["nw"].intValue
                    let nd = curData["nd"].intValue
                    let nl = curData["nl"].intValue
                    let gs = curData["gs"].intValue
                    let ga = curData["ga"].intValue
                    //decide which day is it, and base on the i value, insert the game in the correct place
                    for i in stride(from: 0, to: dayCatagory.count, by: 1){
                        if Calendar.current.isDate(start_time, inSameDayAs: dayCatagory[i]){
                            //in same day
                            let game_obj = SportsGame.init(uid, team_catagory, team, start_time, home_team, away_team, home_score, away_score, latitude, longitude)
                            game_obj.stat = SportsTeamStat(nw, nd, nl, gs, ga)
                            AppDataManager.shared.sportsGameData[i].append(game_obj)
                            break
                        }
                    }
                    index += 1
                }
                completionHandler()
            case .failure(let error):
                print(error)
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func getGameDataByTeam(team: GCSportTeamType, _ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/sport/game-by-team"
        let postData = ["TEAM_NAME": team.rawValue]
        AppDataManager.shared.sportsBrowseByCategoryData = []
        request(urlStr, method: .post, parameters: postData as [String: AnyObject], encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            //            if let data = response.data {
            //                let json = String(data: data, encoding: String.Encoding.utf8)
            //                print("Failure Response: \(json)")
            //            }
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                while(jsonDict["\(index)"] != JSON.null){
                    let curData = jsonDict["\(index)"]
                    let uid = curData["uid"].stringValue
                    let team = GCSportTeamType.init(rawValue: curData["team"].stringValue) ?? GCSportTeamType.default
                    let team_catagory = GCSportType.init(rawValue: curData["team_category"].stringValue) ?? GCSportType.default
                    let start_time = Date.init(timeIntervalSince1970: curData["start_time"].doubleValue - Double(secondsFromGMT))
                    let home_team = curData["home_team"].stringValue
                    let away_team = curData["away_team"].stringValue
                    let latitude = curData["latitude"].doubleValue
                    let longitude = curData["longitude"].doubleValue
                    let home_score = curData["home_score"].intValue
                    let away_score = curData["away_score"].intValue
                    let game_obj = SportsGame.init(uid, team_catagory, team, start_time, home_team, away_team, home_score, away_score, latitude, longitude)
                    AppDataManager.shared.sportsBrowseByCategoryData.append(game_obj)
                    index += 1
                }
                completionHandler()
            case .failure(let error):
                print(error)
                errorHandler(error.localizedDescription)
            }
        }
    }
    
    func getGameDataByResult(_ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/sport/game-by-result"
        AppDataManager.shared.sportsBrowseByCategoryData = []
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                while(jsonDict["\(index)"] != JSON.null){
                    let curData = jsonDict["\(index)"]
                    let uid = curData["uid"].stringValue
                    let team = GCSportTeamType.init(rawValue: curData["team"].stringValue) ?? GCSportTeamType.default
                    let team_catagory = GCSportType.init(rawValue: curData["team_category"].stringValue) ?? GCSportType.default
                    let start_time = Date.init(timeIntervalSince1970: curData["start_time"].doubleValue - Double(secondsFromGMT))
                    let home_team = curData["home_team"].stringValue
                    let away_team = curData["away_team"].stringValue
                    let latitude = curData["latitude"].doubleValue
                    let longitude = curData["longitude"].doubleValue
                    let home_score = curData["home_score"].intValue
                    let away_score = curData["away_score"].intValue
                    let game_obj = SportsGame.init(uid, team_catagory, team, start_time, home_team, away_team, home_score, away_score, latitude, longitude)
                    AppDataManager.shared.sportsBrowseByCategoryData.append(game_obj)
                    index += 1
                }
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
}
