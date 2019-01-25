//
//  TodayViewController.swift
//  ScheduleWidget
//
//  Created by Jeffrey Wang on 2019/1/23.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    static let dataLoadedNotificationName = Notification.Name.init("TodayViewController.dataLoadedNotificationName")
    var timeStrokeView = UIView()
    var timeLabel = UILabel()
    var parentView = UIView()
    var tableView = UITableView()
    var lastCurrentHour: Int = -1
    var lastCurrentMinute: Int = -1
    var startingYBound: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dataReceived(_:)), name: TodayViewController.dataLoadedNotificationName, object: nil)
        ScheduleWidgetIOManager.shared.establishConnection()
    }
    
    @objc func dataReceived(_ sender: Notification){
        
        let status = sender.userInfo!["status"] as! Bool
        let reason = sender.userInfo!["reason"] as! String
        guard status else {
            // network/data not available
            self.setupParentViewDataNotAvaliable(reason)
            return
        }
        if ScheduleWidgetIOManager.shared.data.count == 0{
            self.setupParentViewNoData()
            return
        }
        self.setupParentViewDataAvaliable()
    }
    
    func setupParentViewDataNotAvaliable(_ errStr: String){
        self.view.backgroundColor = UIColor.white
        let l = UILabel(frame: self.view.bounds)
        l.text = "Data not avaliable: \(errStr)"
        l.numberOfLines = 0
        l.textAlignment = .center
        self.view.addSubview(l)
    }
    
    func setupParentViewNoData(){
        assert(ScheduleWidgetIOManager.shared.data.count == 0)
        self.view.backgroundColor = UIColor.white
        let l = UILabel(frame: self.view.bounds)
        l.text = "The schedule for today (\(timeStringFormat(Date.init(timeIntervalSinceNow: 0), withWeek: false))) is normal :)"
        l.numberOfLines = 0
        l.textAlignment = .center
        self.view.addSubview(l)
    }
    
    func setupParentViewDataAvaliable(){
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NEW_TABLE_VIEW_CELL")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = false
        self.tableView.isUserInteractionEnabled = false
        self.view.addSubview(self.tableView)
        self.initTimeStroke()
        self.loadScheduleToView(animated: true)
    }
    
    func getCurrentTime() -> (hour: Int, minute: Int){
        let currentTime = Date(timeIntervalSinceNow: 0)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: currentTime)
        return (comp.hour!, comp.minute!)
    }
    
    func getHeightUnit(hour: Int, minute: Int) -> CGFloat{
        var hour = hour
        if hour == 0{
            hour = 24
        }
        var heightUnit: CGFloat = CGFloat(hour) - 1.0 + 0.5 + CGFloat(minute) / 60.0
        if hour == 24 && minute >= 30{
            heightUnit = (CGFloat(minute) - 30.0) / 60.0
        }
        return heightUnit
    }
    
    func initTimeStroke(){
        let currentTime = getCurrentTime()
        self.lastCurrentMinute = currentTime.minute
        self.startingYBound = self.tableView.bounds.origin.y
        let heightUnit = self.getHeightUnit(hour: currentTime.hour, minute: currentTime.minute)
        let yStart = self.startingYBound + heightUnit * 72.5
        self.timeStrokeView.frame = CGRect(x: 57, y: yStart, width: UIScreen.main.bounds.size.width - 67, height: 15)
        let redStrokeView = UIView(frame: CGRect(x: 0, y: 0, width: self.timeStrokeView.frame.size.width - 10, height: 1))
        redStrokeView.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1)
        self.timeLabel = UILabel(frame: CGRect(x: self.timeStrokeView.frame.size.width - 50, y: 3, width: 40, height: 11))
        self.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.timeLabel.textColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1)
        self.timeLabel.textAlignment = .left
        self.timeLabel.text = "\(currentTime.hour):\(currentTime.minute < 10 ? "0\(currentTime.minute)" : "\(currentTime.minute)")"
        self.timeStrokeView.addSubview(redStrokeView)
        self.timeStrokeView.addSubview(self.timeLabel)
        self.tableView.addSubview(self.timeStrokeView)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeStroke), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimeStroke(){
        let currentTime = getCurrentTime()
        if self.lastCurrentHour != currentTime.hour || (self.lastCurrentHour == 0 && self.lastCurrentMinute == 30){
            self.lastCurrentHour = currentTime.hour
            if self.lastCurrentHour == 0 && self.lastCurrentMinute < 30{
                //still bottom
                self.tableView.scrollToRow(at: IndexPath.init(item: 23, section: 0), at: .bottom, animated: true)
            }else if self.lastCurrentHour == 0 && self.lastCurrentMinute > 30{
                //top
                self.tableView.scrollToRow(at: IndexPath.init(item: 0, section: 0), at: .top, animated: true)
            }else{
                //regular
                self.tableView.scrollToRow(at: IndexPath.init(item: self.lastCurrentHour, section: 0), at: .bottom, animated: true)
            }
            
        }
        guard self.lastCurrentMinute != currentTime.minute else{
            return
        }
        self.lastCurrentMinute = currentTime.minute
        self.timeLabel.text = "\(currentTime.hour):\(currentTime.minute < 10 ? "0\(currentTime.minute)" : "\(currentTime.minute)")"
        let heightUnit = self.getHeightUnit(hour: currentTime.hour, minute: currentTime.minute)
        let yStart = self.startingYBound + heightUnit * 72.5
        UIView.animate(withDuration: 0.3){
            self.timeStrokeView.frame = CGRect(x: 57, y: yStart, width: UIScreen.main.bounds.size.width - 57, height: 15)
        }
    }
    
    func loadScheduleToView(animated: Bool){
        let currentDayData = ScheduleWidgetIOManager.shared.data
        for i in (0..<currentDayData.count){
            let calender = Calendar.current
            let startTime = calender.dateComponents([.hour, .minute], from: currentDayData[i].startTime)
            let endTime = calender.dateComponents([.hour, .minute], from: currentDayData[i].endTime)
            let startY = self.startingYBound + self.getHeightUnit(hour: startTime.hour!, minute: startTime.minute!) * 72.5
            let endY = self.startingYBound + self.getHeightUnit(hour: endTime.hour!, minute: endTime.minute!) * 72.5
            assert(endY > startY)
            let v = UIView(frame: CGRect(x: 57, y: startY, width: UIScreen.main.bounds.size.width - 107, height: endY - startY))
            v.backgroundColor = UIColor.init(red: 0.000, green: 0.624, blue: 0.949, alpha: 0.2)
            v.layer.cornerRadius = 5
            v.layer.borderWidth = 1
            v.layer.borderColor =  UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 0.5).cgColor
            let startTimeLabel = UILabel(frame: CGRect(x: 5, y: 5, width:v.frame.size.width - 10, height: 13))
            startTimeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            var timeString = "@ \(startTime.hour!):\(startTime.minute! < 10 ? "0\(startTime.minute!)" : "\(startTime.minute!)")"
            timeString += " - "
            timeString += "\(endTime.hour!):\(endTime.minute! < 10 ? "0\(endTime.minute!)" : "\(endTime.minute!)")"
            startTimeLabel.text = timeString
            startTimeLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
            let titleLabel = UILabel(frame: CGRect(x: 5, y: 17, width: v.frame.size.width - 10, height: 15))
            titleLabel.contentMode = .top
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = "\(currentDayData[i].title)"
            titleLabel.clipsToBounds = true
            titleLabel.numberOfLines = 0
            titleLabel.sizeToFit()
            titleLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
            v.addSubview(startTimeLabel)
            v.addSubview(titleLabel)
            self.tableView.addSubview(v)
        }
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NEW_TABLE_VIEW_CELL", for: indexPath) as! NewTableViewCell
        if indexPath.item >= 12{
            cell.ampmLabel.text = "PM"
            cell.hourLabel.text = "\(indexPath.item - 11)"
        }else{
            cell.ampmLabel.text = "AM"
            cell.hourLabel.text = "\(indexPath.item + 1)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.5
    }
}
