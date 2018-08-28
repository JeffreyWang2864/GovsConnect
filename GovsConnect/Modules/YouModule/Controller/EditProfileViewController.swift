//
//  EditProfileViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/23.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

typealias EditProfileCompleteBlock = () -> ()

import UIKit

class EditProfileViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var editProfileCompleteBlock: EditProfileCompleteBlock? = nil
    private var endEditingGestureRecongnizer: UITapGestureRecognizer!
    let labels = ["Email", "Website", "Phone", "Address"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endEditingGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.endEditing(_:)))
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "EDIT_PROFILE_INFORMATIONAL_TABLEVIEW_CELL")
        self.tableView.register(UINib(nibName: "GCEditableTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "EDITABLE_TABLEVIEW_CELL")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @objc func endEditing(_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
        self.tableView.resignFirstResponder()
        self.view.removeGestureRecognizer(self.endEditingGestureRecongnizer)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.isMovingToParentViewController{
            self.editProfileCompleteBlock!()
        }
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.labels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.item == 1 && (indexPath.section == 0 || indexPath.section == 1){
//            //instagram/snapchat connect button
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EDIT_PROFILE_INFORMATIONAL_TABLEVIEW_CELL", for: indexPath)
//            cell.textLabel!.textColor = APP_THEME_COLOR
//            if indexPath.section == 0{
//                //instagram
//                cell.textLabel!.text = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.instagramStr == nil ? "connect to Instagram" : "disconnect"
//            }else{
//                //snapchat
//                cell.textLabel!.text = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.snapchatStr == nil ? "connect to Snapchat" : "disconnect"
//            }
//            return cell
//        }
        if indexPath.item == 1{
            //visibility button
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "EDIT_PROFILE_VISIBILITY_TABLEVIEW_CELL")
            cell.textLabel!.text = "visible to"
            let visibility = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.information[indexPath.section].visible
            cell.detailTextLabel!.text = visibility ? "everyone" : "just me"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
//        if indexPath.section == 0 || indexPath.section == 1{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EDIT_PROFILE_INFORMATIONAL_TABLEVIEW_CELL", for: indexPath)
//            cell.textLabel!.textColor = UIColor.black
//            if indexPath.section == 0{
//                //instagram information
//                let info = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.instagramStr
//                cell.textLabel!.text = info == nil ? "not connected": "connected to: \(info!)"
//            }
//            // snapchat information
//            let info = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.snapchatStr
//            cell.textLabel!.text = info == nil ? "not connected": "connected to: \(info!)"
//            return cell
//        }
        // common information block
        
        
        // these information need a specific cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "EDITABLE_TABLEVIEW_CELL", for: indexPath) as! GCEditableTableViewCell
        cell.textField.text = "\(AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.information[indexPath.section].str)"
        cell.textField.tag = indexPath.section
        cell.textField.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.labels[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 1{
            //click on visibility setting
            let vc = GCOptionsTableView()
            vc.view.frame = self.view.bounds
            vc.titleForRow = [["just me", "everyone"]]
            let row = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.information[indexPath.section].visible
            vc.currentSelection = IndexPath(item: btoi(row), section: 0)
            vc.didClickAction = {(section: Int, item: Int, newVal: String) -> Bool in
                AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.information[indexPath.section].visible = itob(item)
                let currentCell = self.tableView.cellForRow(at: indexPath)
                currentCell!.detailTextLabel!.text = newVal
                return true
            }
            self.navigationController!.pushViewController(vc, animated: true)
        }else if indexPath.section <= 1 && indexPath.item == 1{
            NSLog("triggered instagram")
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension EditProfileViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.addGestureRecognizer(self.endEditingGestureRecongnizer)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.information[textField.tag].str = textField.text!
    }
}
