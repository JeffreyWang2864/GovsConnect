//
//  tool.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import EventKit
import MapKit

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
        let weekString = ["Sun. ", "Mon. ", "Tue. ", "Wed. ", "Thu. ", "Fri. ", "Sat. "]
        let calender = NSCalendar.current
        let components = calender.component(.weekday, from: date as Date)
        let commaIndex = formattedString.index(of: ",")!
        formattedString.insert(contentsOf: weekString[components - 1], at: formattedString.index(commaIndex, offsetBy: 2))
    }
    return formattedString
}

func dayStringFormat(_ date: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateFormat = "M/d/yyyy"
    let formattedString = formatter.string(from: date as Date)
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

func suitableHeight(for textView: UITextView, fixedWidth: CGFloat) -> CGFloat{
    let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
    let constraint = textView.sizeThatFits(size)
    return constraint.height
}

func suitableHeight(for label: UILabel, fixedWidth: CGFloat) -> CGFloat{
    let size = CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude)
    let constraint = label.sizeThatFits(size)
    return constraint.height
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

func random0to1000() -> Int{
    return Int(CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * 1000)
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

func saveEventToCalender(_ title: String, _ startDate: Date, _ endDate: Date, _ note: String){
    let eventStore = EKEventStore()
    let event: EKEvent = EKEvent(eventStore: eventStore)
    event.title = title
    event.startDate = startDate
    event.endDate = endDate
    event.notes = note
    event.calendar = eventStore.defaultCalendarForNewEvents
    do {
        try eventStore.save(event, span: EKSpan.thisEvent)
    } catch let error as NSError {
        makeMessageViaAlert(title: "Failed to save event", message: error.localizedDescription)
    }
}

func getScheduleBlockColor(with title: String, alpha: CGFloat) -> UIColor{
    if title.contains("PA"){
        return UIColorFromRGB(rgbValue: 0xFF9510, alpha: alpha)
    }
    if title.contains("A") || title.contains("B"){
        return UIColorFromRGB(rgbValue: 0xF54C34, alpha: alpha)
    }
    if title.contains("C"){
        return UIColorFromRGB(rgbValue: 0xBFFD0D, alpha: alpha)
    }
    if title.contains("D"){
        return UIColorFromRGB(rgbValue: 0x17FC13, alpha: alpha)
    }
    if title.contains("E"){
        return UIColorFromRGB(rgbValue: 0xFFF20D, alpha: alpha)
    }
    if title.contains("F"){
        return UIColorFromRGB(rgbValue: 0x37B1F6, alpha: alpha)
    }
    return UIColorFromRGB(rgbValue: 0x6F49E4, alpha: alpha)
}

func openCoordinateInMapApp(_ coord: CLLocationCoordinate2D, with name: String){
    let regionSpan = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000)
    let options = [
        MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
        MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
    ]
    let placemark = MKPlacemark(coordinate: coord, addressDictionary: nil)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = name
    mapItem.openInMaps(launchOptions: options)
}

//屏幕的宽高
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

typealias CommonVoidBlockType = () -> ()
