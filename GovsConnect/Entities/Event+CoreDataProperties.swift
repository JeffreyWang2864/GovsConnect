//
//  Event+CoreDataProperties.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/16.
//  Copyright © 2018 Eagersoft. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var detail: String?
    @NSManaged public var endTime: NSDate?
    @NSManaged public var notificationState: Int16
    @NSManaged public var startTime: NSDate?
    @NSManaged public var title: String?

}
