//
//  ImageData+CoreDataProperties.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/14.
//  Copyright © 2018 Eagersoft. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var data: NSData?
    @NSManaged public var key: String?

}
