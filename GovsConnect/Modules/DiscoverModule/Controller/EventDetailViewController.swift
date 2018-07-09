//
//  EventDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import EventKit

class EventDetailViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var fromLabel: UILabel!
    @IBOutlet var toLabel: UILabel!
    @IBOutlet var untilLabel: UILabel!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var optionTableView: UITableView!
    var data: EventDataContainer? = nil
    let notificationTitles = [["none"], ["before 1 minute", "before 5 minutes", "before 15 minutes", "before 1 hour", "before 2 hours", "before 5 hours", "before a day"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.data != nil{
            self.titleLabel.text = self.data!.title
            self.detailTextView.text = self.data!.detail
            self.fromLabel.text = timeStringFormat(self.data!.startTime, withWeek: true)
            self.toLabel.text = timeStringFormat(self.data!.endTime, withWeek: true)
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
                if section == 0{
                    self.data!.notificationState = 0
                }else{
                    self.data!.notificationState = item + 1
                    
                }
                return true
            }
            self.navigationController!.pushViewController(vc, animated: true)
        }else{
            let eventStore = EKEventStore()
            eventStore.requestAccess(to: .event) { (granted, error) in
                if (granted) && (error == nil) {
                    let event: EKEvent = EKEvent(eventStore: eventStore)
                    event.title = self.data!.title
                    event.startDate = self.data!.startTime
                    event.endDate = self.data!.endTime
                    event.notes = self.data!.detail
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                    } catch let error as NSError {
                        let alert = UIAlertController(title: "Failed to save event", message: "\(error)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                let alert = UIAlertController(title: "The device doesn't have access to save event", message: "\(error)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
