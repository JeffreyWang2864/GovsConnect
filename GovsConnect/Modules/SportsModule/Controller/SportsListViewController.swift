//
//  SportsListViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/20.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsListViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.allowsSelection = false
        self.tableView.register(UINib.init(nibName: "SportsListViewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SPORTS_LISTVIEW_TABLEVIEW_CELL_ID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func becomeActive(){
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
}

extension SportsListViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDataManager.shared.sportsBrowseByCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SPORTS_LISTVIEW_TABLEVIEW_CELL_ID", for: indexPath) as! SportsListViewTableViewCell
        let data = AppDataManager.shared.sportsBrowseByCategoryData[indexPath.section]
        cell.data = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 20))
    }
}
