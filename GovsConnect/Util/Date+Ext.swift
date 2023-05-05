//
//  Date+Ext.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/5.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import Foundation

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var startOfTheDay: Date{
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: self)!
    }
    var endOfTheDay: Date{
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
