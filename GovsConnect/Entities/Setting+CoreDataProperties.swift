//
//  Setting+CoreDataProperties.swift
//  
//
//  Created by Jeffrey Wang on 2018/9/14.
//
//

import Foundation
import CoreData


extension Setting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Setting> {
        return NSFetchRequest<Setting>(entityName: "Setting")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?

}
