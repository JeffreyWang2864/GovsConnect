//
//  defines.swift
//  ScheduleWidget
//
//  Created by Jeffrey Wang on 2019/1/23.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

let APP_THEME_COLOR = UIColor(red: 0.757, green: 0.243, blue: 0.314, alpha: 1.0)
let APP_BACKGROUND_GREY = UIColor(red: 0.937, green: 0.937, blue: 0.957, alpha: 1.0)

let APP_BACKGROUND_ULTRA_GREY = UIColor(red: 0.976, green: 0.976, blue: 0.976, alpha: 1.0)

let APP_SERVER_URL_STR = "https://govs.app"

let PREDICATE_NAME_CONTAIN = "name contains[c] %@"

let PHONE_TYPE: GCPhoneType = {
    assert(UIDevice().userInterfaceIdiom == .phone)
    NSLog("\(UIScreen.main.nativeBounds.height)")
    switch UIScreen.main.nativeBounds.height {
    case 1136:
        return .iphone5
    case 1334:
        return .iphone6
    case 1920, 2208:
        return .iphone6plus
    case 1792:
        return .iphonexr
    case 2436:
        return .iphonex
    case 2688:
        return .iphonexsmax
    default:
        fatalError()
    }
}()

var secondsFromGMT: Int {
    return TimeZone.current.secondsFromGMT()
}

let APP_ID = "1436465026"

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
