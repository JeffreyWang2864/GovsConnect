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
    public func setupData(){
        self.postsData.append(PostsDataContainer("Jeffrey Wang", "testing_profile_picture_1.png", NSDate.init(timeIntervalSinceNow: -100000), "Govs Connect App is released today!", <#T##postContent: String##String#>, <#T##viewCount: Int##Int#>, <#T##likeCount: Int##Int#>, <#T##commentCount: Int##Int#>, <#T##isViewed: Bool##Bool#>, <#T##isLiked: Bool##Bool#>, <#T##isCommented: Bool##Bool#>))
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
