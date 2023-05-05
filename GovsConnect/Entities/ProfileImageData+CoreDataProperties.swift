//
//  ProfileImageData+CoreDataProperties.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/14.
//  Copyright © 2018 Eagersoft. All rights reserved.
//
//

import Foundation
import CoreData


extension ProfileImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileImageData> {
        return NSFetchRequest<ProfileImageData>(entityName: "ProfileImageData")
    }

    @NSManaged public var key: String?
    @NSManaged public var data: NSData?

}
