//
//  Post+CoreDataProperties.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/16.
//  Copyright © 2018 Eagersoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var author_uid: String?
    @NSManaged public var is_hide: Bool
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var post_time: NSDate?
    @NSManaged public var post_image_url: String?
    @NSManaged public var is_liked: Bool
    @NSManaged public var post_like_count: Int16
    @NSManaged public var is_viewed: Bool
    @NSManaged public var post_view_count: Int16
    @NSManaged public var post_comment_count: Int16
    @NSManaged public var id: String?
    @NSManaged public var comment_by_id: String?

}
