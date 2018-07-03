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
        self.discoverData.append(DiscoverItemDataContainer("testing_picture_6.jpg", "Party @ the Governor's"))
            self.discoverData.append(DiscoverItemDataContainer("system_more_full_image.png", ""))
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
