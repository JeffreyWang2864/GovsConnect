//
//  SportClassifyViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportClassifyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var matchTypeModel:GCSportType! {
        didSet {
            self.navigationItem.title = matchTypeModel.rawValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 115
        self.tableView.separatorStyle = .none
        self.tableView.register(SportClassifyTableViewCell.self, forCellReuseIdentifier: "ClassifyTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClassifyTableViewCell", for: indexPath) as! SportClassifyTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SportDetailViewController()
        let matchModel = DiscoverMatchDataContainer.init(1, GCSportType.baseballSoftball, GCSportTeamType.baseballBJV, Date.init(), "The Governor's Academy", "Tabor Academy", 3, 7, true)
        vc.matchModel = matchModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
