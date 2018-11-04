//
//  NewFoodViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/22.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import TBDropdownMenu

class NewFoodViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var titleLabel = UILabel()
    var arrowImageView = UIImageView(image: UIImage(named: "system_drop_down_arrow.png")!)
    var menuView: DropdownMenu!
    var menuIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTitleView()
        AppIOManager.shared.loadFoodData({ (isSucceed) in
            //success handler
            self.tableView.register(UINib.init(nibName: "NewFoodTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NEW_FOOD_TABLEVIEW_CELL_ID")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }) { (errStr) in
            //err handler
            makeMessageViaAlert(title: "Error when loading food data", message: errStr)
        }
        // Do any additional setup after loading the view.
    }
    
    private func setupTitleView(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "system_reload"), style: .plain, target: self, action: #selector(self.didClickOnReload))
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "lunch/brunch"
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel.textColor = UIColor.white
        let idealWidth = self.titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        self.titleLabel.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: idealWidth, height: 40))
        let fatherTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.titleLabel.frame.size.width + 35, height: self.titleLabel.frame.size.height))
        self.arrowImageView.frame = CGRect(x: self.titleLabel.frame.size.width + 5, y: 0, width: 30, height: self.titleLabel.frame.size.height)
        self.arrowImageView.contentMode = .scaleAspectFit
        fatherTitleView.addSubview(self.titleLabel)
        fatherTitleView.addSubview(self.arrowImageView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnTitle(_:)))
        fatherTitleView.isUserInteractionEnabled = true
        fatherTitleView.addGestureRecognizer(recognizer)
        self.navigationItem.titleView = fatherTitleView
        let menuItem1 = DropdownItem(title: "lunch/brunch")
        let menuItem2 = DropdownItem(title: "dinner")
        self.menuView = DropdownMenu(navigationController: self.navigationController!, items: [menuItem1, menuItem2], selectedRow: 0)
        self.menuView.highlightColor = APP_THEME_COLOR
        self.menuView.delegate = self
    }
    
    @objc private func didClickOnTitle(_ sender: UITapGestureRecognizer) {
        self.menuView.showMenu()
        self.arrowImageViewRotatePi()
    }
    
    @objc func didClickOnReload(){
        guard AppIOManager.shared.connectionStatus != .none else{
            makeMessageViaAlert(title: "Cannot reload on offline mode", message: "Your device is not connecting to the Internet.")
            return
        }
        AppIOManager.shared.loadFoodData({ (isSucceed) in
            self.tableView.reloadData()
        }) { (errStr) in
            makeMessageViaAlert(title: "Error when loading food data", message: errStr)
        }
    }
    
    func arrowImageViewRotatePi(in interval: TimeInterval = 0.25){
        UIView.animate(withDuration: interval){
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
        }
    }
}

extension NewFoodViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDataManager.shared.discoverMenuData[self.menuIndex].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NEW_FOOD_TABLEVIEW_CELL_ID", for: indexPath) as! NewFoodTableViewCell
        let data = AppDataManager.shared.discoverMenuData[self.menuIndex][indexPath.item]
        cell.data = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewFoodViewController: DropdownMenuDelegate{
    func dropdownMenu(_ dropdownMenu: DropdownMenu, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0{
            self.titleLabel.text = "lunch/brunch"
            self.menuIndex = 0
        }else{
            self.titleLabel.text = "dinner"
            self.menuIndex = 1
        }
        self.tableView.reloadData()
        self.arrowImageViewRotatePi()
    }
    
    func dropdownMenuCancel(_ dropdownMenu: DropdownMenu) {
        self.arrowImageViewRotatePi()
    }
}
