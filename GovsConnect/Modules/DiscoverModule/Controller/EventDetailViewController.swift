//
//  EventDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import EventKit
import UserNotifications

class EventDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var untilLabel: UILabel!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var optionTableView: UITableView!
    var data: EventDataContainer? = nil
    var alertRequest: UNNotificationRequest? = nil
    let notificationTitles = [["none"], ["before 1 minute", "before 5 minutes", "before 15 minutes", "before 1 hour", "before 2 hours", "before 5 hours", "before a day"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.data != nil{
            self.titleLabel.text = self.data!.title
            self.detailTextView.text = self.data!.detail
            self.fromLabel.text = "from \(timeStringFormat(self.data!.startTime, withWeek: true))"
            self.toLabel.text = "to \(timeStringFormat(self.data!.endTime, withWeek: true))"
            self.untilLabel.text = prettyTime(to: self.data!.startTime.timeIntervalSinceNow)
        }
        self.detailTextView.backgroundColor = APP_BACKGROUND_GREY
        self.detailTextView.layer.cornerRadius = 10
        let numberOfLine = self.titleLabel.text!.count / 30 + 1
        self.titleLabel.numberOfLines = min(4, numberOfLine)
        let heightConstraint = self.titleLabel.constraints[0]
        heightConstraint.constant = self.titleLabel.font.lineHeight * CGFloat(numberOfLine) + 5
        self.titleLabel.sizeToFit()
        self.optionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "OPTION_TABLEVIEW_CELL")
        self.optionTableView.isScrollEnabled = false
        self.optionTableView.separatorStyle = .none
        self.optionTableView.delegate = self
        self.optionTableView.dataSource = self
    }
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "OPTION_TABLEVIEW_CELL")
        if indexPath.section == 0{
            cell.accessoryType = .disclosureIndicator
            cell.textLabel!.text = "Alert"
            if self.data!.notificationState == 0{
                cell.detailTextLabel!.text = self.notificationTitles[0][0]
            }else{
                cell.detailTextLabel!.text = self.notificationTitles[1][self.data!.notificationState - 1]
            }
        }else{
            cell.accessoryType = .none
            cell.textLabel!.text = "Add event to calendar"
            cell.textLabel!.textColor = APP_THEME_COLOR
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let vc = GCOptionsTableView()
            vc.titleForRow = self.notificationTitles
            if self.data!.notificationState == 0{
                // no notification
                vc.currentSelection = IndexPath(item: 0, section: 0)
            }else{
                // yes notification
                vc.currentSelection = IndexPath(item: self.data!.notificationState - 1, section: 1)
            }
            vc.didClickAction = {(section: Int, item: Int, newVal: String) -> Bool in
                let cell = self.optionTableView.cellForRow(at: IndexPath(item: 0, section: 0))
                cell!.detailTextLabel!.text = newVal
                if self.alertRequest != nil{
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["EVENT_\(self.data!.title)_ALERT_ID"])
                    self.alertRequest = nil
                }
                let eventInCoreData = AppPersistenceManager.shared.filterObject(of: .event, with: NSPredicate(format: "title == %@", self.data!.title))![0] as! Event
                if section == 0{
                    self.data!.notificationState = 0
                    eventInCoreData.notificationState = 0
                }else{
                    self.data!.notificationState = item + 1
                    eventInCoreData.notificationState = Int16(item + 1)
                    let content = UNMutableNotificationContent()
                    content.body = "event: \(self.data!.title)"
                    content.badge = 1
                    var fireDate = Date()
                    //notificationState:
                    //  0: no notification
                    //  1: 1 min
                    //  2: 5 min
                    //  3: 15 min
                    //  4: 1 hour
                    //  5: 2 hour
                    //  6: 5 hour
                    //  7: 1 day
                    switch item{
                    case 0:
                        fireDate = Date(timeInterval: -60, since: self.data!.startTime)
                        content.title = "Event is about to begin in 1 minute"
                    case 1:
                        fireDate = Date(timeInterval: -60 * 5, since: self.data!.startTime)
                        content.title = "Event is about to begin in 5 minutes"
                    case 2:
                        fireDate = Date(timeInterval: -60 * 15, since: self.data!.startTime)
                        content.title = "Event is about to begin in 15 minutes"
                    case 3:
                        fireDate = Date(timeInterval: -60 * 60, since: self.data!.startTime)
                        content.title = "Event is about to begin in 1 hour"
                    case 4:
                        fireDate = Date(timeInterval: -60 * 120, since: self.data!.startTime)
                        content.title = "Event is about to begin in 2 hours"
                    case 5:
                        fireDate = Date(timeInterval: -60 * 600, since: self.data!.startTime)
                        content.title = "Event is about to begin in 5 hours"
                    default:
                        fireDate = Date(timeInterval: -60 * 60 * 24, since: self.data!.startTime)
                        content.title = "Event is about to begin in 24 hours"
                    }
                    let dateCompenents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireDate)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateCompenents, repeats: false)
                    self.alertRequest = UNNotificationRequest(identifier: "EVENT_\(self.data!.title)_ALERT_ID", content: content, trigger: trigger)
                    UNUserNotificationCenter.current().add(self.alertRequest!, withCompletionHandler: nil)
                }
                try! AppPersistenceManager.shared.context.save()
                return true
            }
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let eventStore = EKEventStore()
            
            switch EKEventStore.authorizationStatus(for: EKEntityType.event){
            case .authorized:
                saveEventToCalender(self.data!.title, self.data!.startTime, self.data!.endTime, self.data!.detail)
            case .denied:
                makeMessageViaAlert(title: "Failed to save event", message: "access to calender denied by user")
            case .notDetermined:
                eventStore.requestAccess(to: .event) { (granted, error) in
                    if (granted) && (error == nil) {
                        
                    }
                    let alert = UIAlertController(title: "The device doesn't have access to save event", message: "\(error?.localizedDescription)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case .restricted:
                makeMessageViaAlert(title: "Failed to save event", message: "access restricted to the device")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
