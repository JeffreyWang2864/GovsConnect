//
//  AppDataManager.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import Foundation

class AppDataManager{
    private init(){}
    public static let shared = AppDataManager()
    var postsData = Array<PostsDataContainer>()
    var postReplies = Array<Array<ReplyDataContainer>>()
    public func setupData(){
        self.postsData.append(PostsDataContainer("Jeffrey Wang", "testing_profile_picture_1.png", NSDate.init(timeIntervalSinceNow: -10), "Govs Connect App is released today!", LOREM_IPSUM_1, 12, 2, 1, false, false, false))
        self.postsData.append(PostsDataContainer("Kevin Jiang", "testing_profile_picture_2.png", NSDate.init(timeIntervalSinceNow: -100), "Happy New Year Guys!!!", "Here is a video about people's new year resolution. Go Govs!", 15, 10, 3, false, false, false))
        self.postsData.append(PostsDataContainer("Haodi Shi", "testing_profile_picture_3.jpg", NSDate.init(timeIntervalSinceNow: -10000), "New Ideas on the app...We need you!", LOREM_IPSUM_2, 33, 2, 15, false, false, false))
        self.postsData.append(PostsDataContainer("Jiang Zemin", "testing_profile_picture_4.png", NSDate.init(timeIntervalSinceNow: -100000), "Gou Li Guo Jia Sheng Si Yi, Qi Yin Huo Fu Bi Qu Zhi", LOREM_IPSUM_3, 44, 21, 2, false, false, false))
        self.postsData.append(PostsDataContainer("Donald Trump", "testing_profile_picture_2.png", NSDate.init(timeIntervalSinceNow: -10000000), "Let's all make america great again!", LOREM_IPSUM_1, 45, 0, 14, false, false, false))
        self.postsData.append(PostsDataContainer("Random Person", "testing_profile_picture_2.png", NSDate.init(timeIntervalSinceNow: -100000000), "Section 1.10.33 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC", LOREM_IPSUM_2, 66, 23, 22, false, false, false))
        var aReplies = Array<ReplyDataContainer>()
        aReplies.append(ReplyDataContainer.init("Kevin Jiang", nil, "nice. Android is also avaliable!", "testing_profile_picture_2.png", 2, false))
        aReplies.append(ReplyDataContainer.init("Donald Trump", nil, "make goveror great again!!!", "testing_profile_picture_4.png", 0, false))
        aReplies.append(ReplyDataContainer.init("Random Person", "Kevin Jiang", "can I join the developer crew?", "testing_profile_picture_3.jpg", 4, false))
        self.postReplies.append(aReplies)
        self.postReplies.append(Array<ReplyDataContainer>())
        self.postReplies.append(Array<ReplyDataContainer>())
        self.postReplies.append(Array<ReplyDataContainer>())
        self.postReplies.append(Array<ReplyDataContainer>())
        self.postReplies.append(Array<ReplyDataContainer>())
    }
}

class PostsDataContainer{
    let author: String
    let authorImageName: String
    let postDate: NSDate
    let postTitle: String
    let postContent: String
    var viewCount: Int
    var likeCount: Int
    var commentCount: Int
    var isLikedByCurrentUser: Bool
    var isCommentedByCurrentUser: Bool
    var isViewedByCurrentUser: Bool
    init(_ author: String, _ authorImageName: String, _ postDate: NSDate, _ postTitle: String, _ postContent: String, _ viewCount: Int, _ likeCount: Int, _ commentCount: Int, _ isViewed: Bool, _ isLiked: Bool, _ isCommented: Bool){
        self.author = author
        self.authorImageName = authorImageName
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
    let sender: String
    let receiver: String?
    let body: String
    let authorImageName: String
    var likeCount: Int
    var isLikedByCurrentUser: Bool
    init(_ sender: String, _ receiver: String?, _ body: String, _ authorImageName: String, _ likeCount: Int, _ isLiked: Bool){
        self.sender = sender
        self.receiver = receiver
        self.body = body
        self.authorImageName = authorImageName
        self.likeCount = likeCount
        self.isLikedByCurrentUser = isLiked
    }
}
