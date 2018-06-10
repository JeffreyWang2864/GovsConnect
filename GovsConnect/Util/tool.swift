//
//  tool.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

func prettyTimeSince(_ timeInterval: TimeInterval) -> String{
    let tisn = abs(NSInteger(timeInterval))
    let days = tisn / 86400
    if days > 0{
        let months = (days / 30) % 12
        let years = days / 365
        if years > 0{
            return "\(years) \(years == 1 ? "year" : "years") ago"
        }
        if months > 0{
            return "\(months) \(months == 1 ? "month" : "months") ago"
        }
        return "\(days) \(days == 1 ? "day" : "days") ago"
    }
    let minutes = (tisn / 60) % 60
    let hours = tisn / 3600
    if hours > 0{
        return "\(hours) \(hours == 1 ? "hour" : "hours") ago"
    }
    if minutes > 0{
        return "\(minutes) \(minutes == 1 ? "minute" : "minutes") ago"
    }
    return "just now"
}

func numberOfVisibleLines(_ label: UILabel) -> Int {
    let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
    let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
    let charSize = lroundf(Float(label.font.lineHeight))
    let lineCount = rHeight/charSize
    return lineCount
}
