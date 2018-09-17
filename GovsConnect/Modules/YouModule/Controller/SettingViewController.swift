//
//  SettingViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/16.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Setting"
        self.tableView.register(UINib(nibName: "GCButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "GC_BUTTON_TABLEVIEW_CELL")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SETTINGVIEW_TABLEVIEW_CELL")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppIOManager.shared.userChangeSetting { (isSucceed) in
            assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone posts"), newVal: "\(AppDataManager.shared.currentUserSetting["someone posts"]!)", forKey: "value"))
            assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my comment"), newVal: "\(AppDataManager.shared.currentUserSetting["someone replied my comment"]!)", forKey: "value"))
            assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone replied my post"), newVal: "\(AppDataManager.shared.currentUserSetting["someone replied my post"]!)", forKey: "value"))
            assert(AppPersistenceManager.shared.updateObject(of: .setting, with: NSPredicate(format: "key == %@", "someone liked my post"), newVal: "\(AppDataManager.shared.currentUserSetting["someone liked my post"]!)", forKey: "value"))
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GC_BUTTON_TABLEVIEW_CELL", for: indexPath) as! GCButtonTableViewCell
            switch indexPath.item{
            case 0:
                cell.label.text = "someone posts"
                if AppDataManager.shared.currentUserSetting["someone posts"]!{
                    cell.switchButton.setOn(true, animated: false)
                }else{
                    cell.switchButton.setOn(false, animated: false)
                }
            case 1:
                cell.label.text = "someone liked my post"
                if AppDataManager.shared.currentUserSetting["someone liked my post"]!{
                    cell.switchButton.setOn(true, animated: false)
                }else{
                    cell.switchButton.setOn(false, animated: false)
                }
            case 2:
                cell.label.text = "someone replied my post"
                if AppDataManager.shared.currentUserSetting["someone replied my post"]!{
                    cell.switchButton.setOn(true, animated: false)
                }else{
                    cell.switchButton.setOn(false, animated: false)
                }
            case 3:
                cell.label.text = "someone replied my comment"
                if AppDataManager.shared.currentUserSetting["someone replied my comment"]!{
                    cell.switchButton.setOn(true, animated: false)
                }else{
                    cell.switchButton.setOn(false, animated: false)
                }
            default:
                fatalError()
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "SETTINGVIEW_TABLEVIEW_CELL", for: indexPath)
        cell.textLabel!.text = "Clear local data"
        cell.textLabel!.textColor = APP_THEME_COLOR
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "notify me when:"
        }
        return "actions"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1{
            let alert = UIAlertController(title: "clear local data confirmation", message: "By clicking \"Clear local data\" below, all image and string caches will be erased. This may free some disk space on your device, but those caches may be redownloaded from the server again at the next time you launch this app.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Clear local data", style: .destructive, handler: { (action) in
                let allPostData = AppPersistenceManager.shared.fetchObject(with: .post)
                allPostData.map{
                    AppPersistenceManager.shared.deleteObject(of: .post, with: $0)
                }
                let allImageData = AppPersistenceManager.shared.fetchObject(with: .imageData)
                allImageData.map{
                    AppPersistenceManager.shared.deleteObject(of: .imageData, with: $0)
                }
                let allProfileImageData = AppPersistenceManager.shared.fetchObject(with: .profileImageData)
                allProfileImageData.map{
                    AppPersistenceManager.shared.deleteObject(of: .profileImageData, with: $0)
                }
                let allCommentData = AppPersistenceManager.shared.fetchObject(with: .comment)
                allCommentData.map{
                    AppPersistenceManager.shared.deleteObject(of: .comment, with: $0)
                }
                let allEventData = AppPersistenceManager.shared.fetchObject(with: .event)
                allEventData.map{
                    AppPersistenceManager.shared.deleteObject(of: .event, with: $0)
                }
                makeMessageViaAlert(title: "Clear local data successful", message: "")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.navigationController!.present(alert, animated: true, completion: nil)
        }
    }
}
