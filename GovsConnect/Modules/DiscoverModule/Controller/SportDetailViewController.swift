//
//  SportDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tableView:UITableView!
    var matchModel:DiscoverMatchDataContainer! {
        didSet {
            //            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Match Detail"
        //        self.view.backgroundColor = UIColor.white
        self.tableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        self.tableView.backgroundColor = UIColor.white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        self.tableView.separatorStyle = .none
        self.tableView.register(SportDetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! SportDetailTableViewCell
        cell.matchModel = self.matchModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 60))
        let backView:UIView = UIView.init(frame: CGRect.init(x: 15, y: 15, width: header.width - 30, height: header.height - 15))
        backView.backgroundColor = UIColorFromRGB(rgbValue: 0xf3f3f3, alpha: 0.9)
        header.addSubview(backView)
        
        let titleLabel:UILabel = UILabel.init()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.text = self.matchModel.catagory.rawValue
        titleLabel.sizeToFit()
        titleLabel.frame = CGRect.init(x: (backView.width - titleLabel.width) * 0.5, y: 2, width: titleLabel.width, height: titleLabel.height)
        backView.addSubview(titleLabel)
        
        let timeLabel:UILabel = UILabel.init()
        timeLabel.text = timeStringFormat(self.matchModel.startTime, withWeek: true)
        timeLabel.font = UIFont.systemFont(ofSize: 14)
        timeLabel.textColor = UIColor.lightGray
        timeLabel.sizeToFit()
        timeLabel.frame = CGRect.init(x: (backView.width - timeLabel.width) * 0.5, y: titleLabel.bottom + 4, width: timeLabel.width, height: timeLabel.height)
        backView.addSubview(timeLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
