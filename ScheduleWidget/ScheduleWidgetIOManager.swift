//
//  ScheduleWidgetIOManager.swift
//  ScheduleWidget
//
//  Created by Jeffrey Wang on 2019/1/23.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Reachability

class ScheduleWidgetIOManager{
    private init(){}
    static public let shared = ScheduleWidgetIOManager()
    var connectionStatus: Reachability.Connection = .none
    var data = Array<EventDataContainer>()
    func establishConnection(){
        let reachability = Reachability()!
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.nnnnn(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
        reachability.whenReachable = { response in
            ScheduleWidgetIOManager.shared.connectionStatus = response.connection
            self.loadModifiedScheduleData({
                NotificationCenter.default.post(name: TodayViewController.dataLoadedNotificationName, object: nil, userInfo: ["status": true, "reason": ""])
            }, { (errStr) in
                NotificationCenter.default.post(name: TodayViewController.dataLoadedNotificationName, object: nil, userInfo: ["status": false, "reason": errStr])
            })
        }
        reachability.whenUnreachable = { _ in
            ScheduleWidgetIOManager.shared.connectionStatus = .none
            NotificationCenter.default.post(name: TodayViewController.dataLoadedNotificationName, object: nil, userInfo: ["status": false, "reason": "network unavailable"])
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func loadModifiedScheduleData(_ completionHandler: @escaping () -> (), _ errorHandler: @escaping (String) -> ()){
        let urlStr = APP_SERVER_URL_STR + "/discover/modified_schedule"
        request(urlStr).responseJSON { (response) in
            switch response.result{
            case .success(let json):
                let jsonDict = JSON(json)
                var index = 0
                ScheduleWidgetIOManager.shared.data = []
                while(jsonDict["\(index)"] != JSON.null){
                    let data = jsonDict["\(index)"]
                    let start_time_interval = data["start_time"].intValue - secondsFromGMT
                    let end_time_interval = data["end_time"].intValue - secondsFromGMT
                    let title = data["title"].stringValue
                    let event = EventDataContainer(Date(timeIntervalSince1970: TimeInterval(start_time_interval)), Date(timeIntervalSince1970: TimeInterval(end_time_interval)), title, "")
                    ScheduleWidgetIOManager.shared.data.append(event)
                    index += 1
                }
                completionHandler()
            case .failure(let error):
                errorHandler(error.localizedDescription)
            }
        }
    }
}
