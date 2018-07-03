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
    var startingYBound: CGFloat = 0
    var events = Array<UIView>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "6/30/2018 - 7/1/2018"
        self.segmentControl.setSegmentItems(["Friday", "Saturday", "Sunday"])
        self.segmentControl.sliderBackgroundColor = APP_THEME_COLOR
        self.segmentControl.delegate = self
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
        for data in AppDataManager.shared.discoverWeekendEventData[dayIndex]{
            let startY = self.startingYBound + self.getHeightUnit(hour: data.startTime.hour, minute: data.startTime.minute) * 72.5
            let endY = self.startingYBound + self.getHeightUnit(hour: data.endTime.hour, minute: data.endTime.minute) * 72.5
            assert(endY > startY)
            let v = UIView(frame: CGRect(x: 57, y: startY, width: UIScreen.main.bounds.size.width - 107, height: endY - startY))
            v.backgroundColor = UIColor.init(red: 0.000, green: 0.624, blue: 0.949, alpha: 0.2)
            v.layer.cornerRadius = 5
            v.layer.borderWidth = 1
            v.layer.borderColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 0.5).cgColor
            let startTimeLabel = UILabel(frame: CGRect(x: 5, y: 5, width:v.frame.size.width - 10, height: 18))
            startTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            startTimeLabel.text = "@ \(data.startTime.hour):\(data.startTime.minute < 10 ? "0\(data.startTime.minute)" : "\(data.startTime.minute)")"
            startTimeLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
            let titleLabel = UILabel(frame: CGRect(x: 5, y: 23, width: v.frame.size.width - 10, height: 18))
            titleLabel.contentMode = .top
            titleLabel.font = UIFont.systemFont(ofSize: 18)
            titleLabel.text = "\(data.title)"
            titleLabel.numberOfLines = 2
            titleLabel.sizeToFit()
            titleLabel.textColor = UIColor.init(red: 0.216, green: 0.282, blue: 0.675, alpha: 1.0)
            v.addSubview(startTimeLabel)
            v.addSubview(titleLabel)
            v.alpha = animated ? 0 : 1
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
