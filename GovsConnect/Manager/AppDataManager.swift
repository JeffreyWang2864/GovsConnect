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
    var users = Dictionary<String, UserDataContainer>()
    var newPostDraft: (String, String, Array<UIImage>)? = nil
    var currentPersonID = "jefwa001"
    public func setupData(){
        self.users["jefwa001"] = UserDataContainer.init("jefwa001", "Jeffrey Wang", "testing_profile_picture_1.png")
        self.users["kevji001"] = UserDataContainer.init("kevji001", "Kevin Jiang", "testing_profile_picture_2.png")
        self.users["haosh001"] = UserDataContainer.init("haosh001", "Haodi Shi", "testing_profile_picture_3.jpg")
        self.users["zemji001"] = UserDataContainer.init("zemji001", "Zemin Jiang", "testing_profile_picture_jzm.png")
        self.users["dontr001"] = UserDataContainer.init("dontr001", "Donald Trump", "testing_profile_picture_dt.png")
        self.users["ranpe001"] = UserDataContainer.init("ranpe001", "Random Person", "testing_profile_picture_4.png")
        self.postsData.append(PostsDataContainer(self.users["jefwa001"]!, NSDate.init(timeIntervalSinceNow: -10), "Govs Connect App is released today!", LOREM_IPSUM_1, 12, 2, 3, false, false, false))
        self.postsData.append(PostsDataContainer(self.users["kevji001"]!, NSDate.init(timeIntervalSinceNow: -100), "Happy New Year Guys!!!", "Here is a video about people's new year resolution. Go Govs!", 15, 10, 0, false, false, false))
        self.postsData.append(PostsDataContainer(self.users["haosh001"]!, NSDate.init(timeIntervalSinceNow: -10000), "New Ideas on the app...We need you!", LOREM_IPSUM_2, 33, 2, 0, false, false, false))
        self.postsData.append(PostsDataContainer(self.users["zemji001"]!, NSDate.init(timeIntervalSinceNow: -100000), "Gou Li Guo Jia Sheng Si Yi, Qi Yin Huo Fu Bi Qu Zhi", LOREM_IPSUM_3, 44, 21, 0, false, false, false))
        self.postsData.append(PostsDataContainer(self.users["dontr001"]!, NSDate.init(timeIntervalSinceNow: -10000000), "Let's all make america great again!", LOREM_IPSUM_1, 45, 0, 0, false, false, false))
        self.postsData.append(PostsDataContainer(self.users["ranpe001"]!, NSDate.init(timeIntervalSinceNow: -100000000), "Section 1.10.33 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC", LOREM_IPSUM_2, 66, 23, 0, false, false, false))
        self.postsData[0].replies.append(ReplyDataContainer.init(self.users["kevji001"]!, nil, "nice. Android is also avaliable!", 2, false))
        self.postsData[0].replies.append(ReplyDataContainer.init(self.users["dontr001"]!, nil, "make goveror great again!!!", 0, false))
        self.postsData[0].replies.append(ReplyDataContainer.init(self.users["ranpe001"]!, self.users["kevji001"]!, "can I join the developer crew?", 4, false))
        self.postsData[0].postImagesName.append("testing_picture_2.jpg")
        self.postsData[0].postImagesName.append("testing_picture_3.jpg")
        self.postsData[2].postImagesName.append("testing_picture_1.jpg")
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_4.jpg", "Weekend Events"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_5.jpg", "Daily Bulletin"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_7.jpg", "Govs Trade"))
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_8.jpg", "Rate Your Food"))
            self.discoverData.append(DiscoverItemDataContainer("system_more_full_image.png", ""))
        for _ in (0..<3){
            self.discoverWeekendEventData.append(Array<EventDataContainer>())
        }
        self.discoverWeekendEventData[0].append(EventDataContainer(Date(timeIntervalSince1970: 1526629501 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526644801 - 3600 * 8 + 86400 * 54), "AP Microeconomics exam", "Please make sure to bring at least two pencils to the test room"))
        self.discoverWeekendEventData[0].append(EventDataContainer(Date(timeIntervalSince1970: 1526645701 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526661001 - 3600 * 8 + 86400 * 54), "AP MEH exam; AP Latin exam", "Please make sure to bring at least two pencils to the test room"))
        self.discoverWeekendEventData[0].append(EventDataContainer(Date(timeIntervalSince1970: 1526673601 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526679001 - 3600 * 8 + 86400 * 54), "Spring Drama Production in PAC", LOREM_IPSUM_1))
        self.discoverWeekendEventData[1].append(EventDataContainer(Date(timeIntervalSince1970: 1526716801 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526720401 - 3600 * 8 + 86400 * 54), "New England Track Championships @ Tabor Academy", LOREM_IPSUM_2))
        self.discoverWeekendEventData[1].append(EventDataContainer(Date(timeIntervalSince1970: 1526760001 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526765401 - 3600 * 8 + 86400 * 54), "Spring Drama Production in PAC", LOREM_IPSUM_3))
        self.discoverWeekendEventData[2].append(EventDataContainer(Date(timeIntervalSince1970: 1526801401 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526806621 - 3600 * 8 + 86400 * 54), "Continental breakfast", "No detail to display"))
        self.discoverWeekendEventData[2].append(EventDataContainer(Date(timeIntervalSince1970: 1526806801 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526817601 - 3600 * 8 + 86400 * 54), "Brunch", "No detail to display"))
        self.discoverWeekendEventData[2].append(EventDataContainer(Date(timeIntervalSince1970: 1526832001 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526835601 - 3600 * 8 + 86400 * 54), "Formal -Phillips Gathering - Pictures", LOREM_IPSUM_3))
        self.discoverWeekendEventData[2].append(EventDataContainer(Date(timeIntervalSince1970: 1526836501 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526858101 - 3600 * 8 + 86400 * 54), "Depart for Boston Harbor Hotel; Arrive back to Govs at 11:15 pm", LOREM_IPSUM_2))
        self.discoverWeekendEventData[2].append(EventDataContainer(Date(timeIntervalSince1970: 1526859001 - 3600 * 8 + 86400 * 54), Date(timeIntervalSince1970: 1526776141 - 3600 * 8 + 86400 * 54), "Check out procedures; Boarders check in to dorms", LOREM_IPSUM_1))
        
        for day in self.discoverWeekendEventData{
            for data in day{
                let calender = Calendar.current
                let startTime = calender.dateComponents([.hour, .minute], from: data.startTime)
                let endTime = calender.dateComponents([.hour, .minute], from: data.endTime)
                NSLog("\(data.title), \(startTime.hour!), \(startTime.minute!), \(endTime.hour!), \(endTime.minute!)")
            }
        }
    }
}

class UserDataContainer{
    let uid: String
    let name: String
    var profilePictureName: String
    init(_ uid: String, _ name: String, _ profilePictureName: String){
        self.uid = uid
        self.name = name
        self.profilePictureName = profilePictureName
    }
}

class PostsDataContainer{
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
    }
}

class ReplyDataContainer{
    let sender: UserDataContainer
    let receiver: UserDataContainer?
    let body: String
    var likeCount: Int
    var isLikedByCurrentUser: Bool
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
