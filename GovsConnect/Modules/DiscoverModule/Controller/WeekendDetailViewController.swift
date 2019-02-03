//
//  WeekendDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/2.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import TwicketSegmentedControl

class WeekendDetailViewController: UIViewController {
    @IBOutlet var segmentControl: TwicketSegmentedControl!
    @IBOutlet var tableView: UITableView!
    var timeStrokeView = UIView()
    var timeLabel = UILabel()
    var lastCurrentMinute: Int = -1
    var lastCurrentHour: Int = -1
    var startingYBound: CGFloat = 0
    var events = Array<UIView>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(dayStringFormat(AppDataManager.shared.discoverWeekendEventData[0][0].startTime)) - \(dayStringFormat(AppDataManager.shared.discoverWeekendEventData[2][0].startTime))"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "system_reload"), style: .plain, target: self, action: #selector(self.didClickOnReload))
        self.segmentControl.setSegmentItems(["Friday", "Saturday", "Sunday"])
        self.segmentControl.sliderBackgroundColor = APP_THEME_COLOR
        self.segmentControl.delegate = self
        let todayCalender = NSCalendar.current
        let todatComponents = todayCalender.component(.weekday, from: Date.init(timeIntervalSinceNow: 0))
        //1 sunday, 7 saturday
        if todatComponents == 7{
            self.segmentControl.move(to: 1)
        }else if todatComponents == 1{
            self.segmentControl.move(to: 2)
        }
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NEW_TABLE_VIEW_CELL")
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimeStroke), userInfo: nil, repeats: true)
        self.initTimeStroke()
        self.loadEventsToView(animated: true)
        let lsgr = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeLeft(_:)))
        lsgr.direction = .left
        let rsgr = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipeRight(_:)))
        rsgr.direction = .right
        self.view.addGestureRecognizer(lsgr)
        self.view.addGestureRecognizer(rsgr)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeEventFromView(animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.events.count == 0{
            self.loadEventsToView(animated: animated)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
                self.tableView.scrollToRow(at: IndexPath.init(item: self.lastCurrentHour, section: 0), at: .middle, animated: true)
            }
        }
    }
    
    @objc func didSwipeLeft(_ sender: UISwipeGestureRecognizer){
        if self.segmentControl.selectedSegmentIndex + 1 <= 2{
            self.segmentControl.move(to: self.segmentControl.selectedSegmentIndex + 1)
        }
        self.refreashEvents(animated: true)
    }
    
    @objc func didSwipeRight(_ sender: UISwipeGestureRecognizer){
        if self.segmentControl.selectedSegmentIndex - 1 >= 0{
            self.segmentControl.move(to: self.segmentControl.selectedSegmentIndex - 1)
        }
        self.refreashEvents(animated: true)
    }
    
    @objc func didClickOnReload(){
        guard AppIOManager.shared.connectionStatus != .none else{
            makeMessageViaAlert(title: "Cannot reload on offline mode", message: "Your device is not connecting to the Internet.")
            return
        }
        let allEvents = AppPersistenceManager.shared.fetchObject(with: .event)
        for event in allEvents{
            AppPersistenceManager.shared.deleteObject(of: .event, with: event)
        }
        AppIOManager.shared.loadWeekendEventData({ (isSucceed) in
            self.refreashEvents(animated: true)
        }) { (errStr) in
            makeMessageViaAlert(title: "Error when loading weekend event", message: errStr)
        }
        
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
        self.timeStrokeView.frame = CGRect(x: 57, y: yStart, width: UIScreen.main.bounds.size.width - 57, height: 15)
        let redStrokeView = UIView(frame: CGRect(x: 0, y: 0, width: self.timeStrokeView.frame.size.width, height: 1))
        redStrokeView.backgroundColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1)
        self.timeLabel = UILabel(frame: CGRect(x: self.timeStrokeView.frame.size.width - 40, y: 3, width: 40, height: 11))
        self.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        self.timeLabel.textColor = UIColor(red: 1.000, green: 0.000, blue: 0.000, alpha: 1)
        self.timeLabel.textAlignment = .left
        self.timeLabel.text = "\(currentTime.hour):\(currentTime.minute < 10 ? "0\(currentTime.minute)" : "\(currentTime.minute)")"
        self.timeStrokeView.addSubview(redStrokeView)
        self.timeStrokeView.addSubview(self.timeLabel)
        self.tableView.addSubview(self.timeStrokeView)
    }
    
    @objc func updateTimeStroke(){
        let currentTime = getCurrentTime()
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
    
    func loadEventsToView(animated: Bool){
        let dayIndex = self.segmentControl.selectedSegmentIndex
        let currentDayData = AppDataManager.shared.discoverWeekendEventData[dayIndex]
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
            v.layer.borderColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 0.5).cgColor
            let startTimeLabel = UILabel(frame: CGRect(x: 5, y: 5, width:v.frame.size.width - 10, height: 13))
            startTimeLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
            startTimeLabel.text = "@ \(startTime.hour!):\(startTime.minute! < 10 ? "0\(startTime.minute!)" : "\(startTime.minute!)")"
            startTimeLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
            if currentDayData[i].endTime.timeIntervalSinceNow - currentDayData[i].startTime.timeIntervalSinceNow < 1740{
                //event is less than 29 minutes
                let titleLabel = UILabel(frame: CGRect(x: 60, y: 2, width: v.frame.size.width - 70, height: 15))
                titleLabel.clipsToBounds = true
                titleLabel.numberOfLines = 1
                titleLabel.contentMode = .top
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.text = "\(currentDayData[i].title)"
                titleLabel.lineBreakMode = .byTruncatingMiddle
                titleLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
                v.addSubview(startTimeLabel)
                v.addSubview(titleLabel)
            }else{
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
            }
            v.alpha = animated ? 0 : 1
            v.tag = self.segmentControl.selectedSegmentIndex * 100 + i
            let tgr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnEvent(_:)))
            v.addGestureRecognizer(tgr)
            self.events.append(v)
            self.tableView.addSubview(v)
        }
        if animated{
            UIView.animate(withDuration: 0.25){
                for event in self.events{
                    event.alpha = 1
                }
            }
        }
    }
    
    @objc func didClickOnEvent(_ sender: UITapGestureRecognizer){
        let vc = EventDetailViewController.init(nibName: "EventDetailViewController", bundle: Bundle.main)
        vc.data = AppDataManager.shared.discoverWeekendEventData[sender.view!.tag / 100][sender.view!.tag % 100]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func removeEventFromView(animated: Bool){
        if animated{
            UIView.animate(withDuration: 0.25, animations: {
                for event in self.events{
                    event.alpha = 0
                }
            }) { (response) in
                for event in self.events{
                    event.removeFromSuperview()
                }
            }
        }else{
            for event in self.events{
                event.alpha = 0
                event.removeFromSuperview()
            }
        }
        self.events = []
    }
    
    func refreashEvents(animated: Bool){
        self.removeEventFromView(animated: animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            self.loadEventsToView(animated: animated)
        }
    }
}

extension WeekendDetailViewController: UITableViewDelegate, UITableViewDataSource{
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

extension WeekendDetailViewController: TwicketSegmentedControlDelegate{
    func didSelect(_ segmentIndex: Int) {
        self.refreashEvents(animated: true)
    }
}
