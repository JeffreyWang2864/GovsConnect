//
//  Comment+CoreDataProperties.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/15.
//  Copyright © 2018 Eagersoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var id: String?
    @NSManaged public var sender_uid: String?
    @NSManaged public var receiver_uid: String?
    @NSManaged public var body: String?
    @NSManaged public var like_count: Int16
    @NSManaged public var is_liked: Bool

}
