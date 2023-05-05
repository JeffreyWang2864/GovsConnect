//
//  NotificationViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/13.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    public static let didReceivedNotificationName = Notification.Name(rawValue: "didReceivedNotificationName")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "MessageNotificationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MESSAGE_NOTIFICATION_TABLE_VIEW_CELL_ID")
        NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveNotification(_:)), name: NotificationViewController.didReceivedNotificationName, object: nil)
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        guard self.tabBarController!.tabBar.items![3].badgeValue != nil else{
            return
        }
        self.tabBarController!.tabBar.items![3].badgeValue = nil
    }
    
    @objc func didReceiveNotification(_ sender: Notification){
        self.tabBarController!.tabBar.items![3].badgeValue = "1"
    }
}

extension NotificationViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDataManager.shared.remoteNotificationData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let testView = UITextView(frame: CGRect(x: 0, y: 0, width: screenWidth - 100 - 10, height: 50))
        testView.text = AppDataManager.shared.remoteNotificationData[indexPath.section].alertMessage
        let lines = numberOfVisibleLines(testView)
        return CGFloat(lines * 21 + 5 + 15 + 5 + max(0, (lines - 2)) * 15)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MESSAGE_NOTIFICATION_TABLE_VIEW_CELL_ID", for: indexPath) as! MessageNotificationTableViewCell
        cell.data = AppDataManager.shared.remoteNotificationData[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
