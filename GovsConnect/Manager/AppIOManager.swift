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
    static public let shared = AppIOManager()
    var connectionStatus: Reachability.Connection!
    var isFirstTimeConnnected = true
    func establishConnection(){
        let reachability = Reachability()!
        reachability.whenReachable = { response in
            NSLog("\(response.connection)")
            AppIOManager.shared.connectionStatus = response.connection
            if self.isFirstTimeConnnected{
                self.isFirstTimeConnnected = false
                AppDataManager.shared.loadPostDataFromServerAndUpdateLocalData()
            }
        }
        reachability.whenUnreachable = { _ in
            AppIOManager.shared.connectionStatus = .none
            NSLog("unreachable")
            if AppIOManager.shared.connectionStatus == .none{
                makeMessageViaAlert(title: "You are in offline mode", message: "Your device is not connecting to the Internet. Loading local data")
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func loadImage(with id: String, _ completionHandler: @escaping (Data) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/assets/image/" + id
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
        let urlStr = APP_SERVER_URL_STR + "/post/\(post_id)/add_reply"
        let json = "?sender_uid=\(postData["sender_uid"]!)&receiver_uid=\(postData["receiver_uid"]!)&body=\(postData["body"]!.serializable())"
        NSLog(urlStr + json)
        request(urlStr + json).responseJSON { (response) in
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
            AppDataManager.shared.postsData[local_post_id].replies.append(container)
            index += 1
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
}
