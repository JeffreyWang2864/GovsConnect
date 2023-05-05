//
//  LinksViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class LinksViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "LinksTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "LINKS_TABLEVIEW_CELL_ID")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.title = "Links"
    }
}

extension LinksViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDataManager.shared.discoverLinksData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LINKS_TABLEVIEW_CELL_ID", for: indexPath) as! LinksTableViewCell
        let data = AppDataManager.shared.discoverLinksData[indexPath.section]
        cell.data = data
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! LinksTableViewCell
        cell.didClickOnCell()
        return self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
