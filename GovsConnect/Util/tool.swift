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

func prettyTime(to intervalSinceNow: TimeInterval) -> String{
    if intervalSinceNow <= 0{
        return "started already"
    }
    let tisn = NSInteger(intervalSinceNow)
    let days = tisn / 86400
    if days > 0{
        let months = (days / 30) % 12
        let years = days / 365
        if years > 0{
            return "start in \(years) \(years == 1 ? "year" : "years")"
        }
        if months > 0{
            return "start in \(months) \(months == 1 ? "month" : "months")"
        }
        return "start in \(days) \(days == 1 ? "day" : "days")"
    }
    let hours = tisn / 3600
    if hours > 0{
        return "start in \(hours) \(hours == 1 ? "hour" : "hours")"
    }
    return "start in less an hour"
}

func timeStringFormat(_ date: Date,  withWeek: Bool) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm, M/d/yyyy"
    var formattedString = formatter.string(from: date as Date)
    if withWeek{
        let weekString = ["Mon. ", "Tue. ", "Wed. ", "Thu. ", "Fri. ", "Sat. ", "Sun. "]
        let calender = NSCalendar.current
        let components = calender.component(.weekday, from: date as Date)
        let commaIndex = formattedString.firstIndex(of: ",")!
        formattedString.insert(contentsOf: weekString[components - 1], at: formattedString.index(commaIndex, offsetBy: 2))
    }
    return formattedString
}

func numberOfVisibleLines(_ textView: UITextView) -> Int {
    let textSize = CGSize(width: textView.frame.size.width, height: CGFloat(Float.infinity))
    let rHeight = lroundf(Float(textView.sizeThatFits(textSize).height))
    let charSize = lroundf(Float(textView.font!.lineHeight))
    let lineCount = rHeight/charSize
    return lineCount
}

func numberOfVisibleLines(_ textView: UILabel) -> Int {
    let textSize = CGSize(width: textView.frame.size.width, height: CGFloat(Float.infinity))
    let rHeight = lroundf(Float(textView.sizeThatFits(textSize).height))
    let charSize = lroundf(Float(textView.font!.lineHeight))
    let lineCount = rHeight/charSize
    return lineCount
}

func btoi(_ n: Bool) -> Int{
    return n ? 1 : 0
}

func itob(_ n: Int) -> Bool{
    return n == 0 ? false : true
}

func makeMessageViaAlert(title: String, message: String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
}

func random0to10000() -> Int{
    return Int(CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 10000)
}

//16进制转化颜色
func UIColorFromRGB(rgbValue:Int,alpha:CGFloat) -> UIColor {
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: alpha)
}

func whichDayOfWeekend(_ date: Date) -> Int{
    let calendar: Calendar = Calendar.current
     let weekDay = calendar.component(Calendar.Component.weekday, from: date)
    return weekDay == 1 ? 2 : weekDay - 6
}

func isValidEmail(_ enteredEmail: String) -> Bool {
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    return emailPredicate.evaluate(with: enteredEmail)
}

//屏幕的宽高
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

typealias CommonVoidBlockType = () -> ()
