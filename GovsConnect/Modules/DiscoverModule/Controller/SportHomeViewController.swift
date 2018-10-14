//
//  SportHomeViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView!
    var headDataArray:[DiscoverMatchDataContainer]!
    var matchTypeDataArray:[GCSportType]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sport Events"
        self.tableView = UITableView.init(frame: self.view.bounds, style: .plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.register(SportHomeHeadTableViewCell.self, forCellReuseIdentifier: "HomeHeadTableViewCell")
        self.tableView.register(SportHomeGridTableViewCell.self, forCellReuseIdentifier: "HomeGridTableViewCell")
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        
        self.headDataArray = [DiscoverMatchDataContainer]()
        self.matchTypeDataArray = [GCSportType]()
        self.loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeadTableViewCell", for: indexPath) as! SportHomeHeadTableViewCell
            cell.dataArray = self.headDataArray
            cell.homeHeadClickBlock = {(matchModel, browseAll) in
                if (browseAll) {
                    //点击的是查看全部,跳转到分类列表页面(复用)
                    let vc = SportClassifyViewController()
                    //todo:这里要标记是浏览全部的跳转,传一个标志过去
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    //点击的时候前面的四个赛事cell,跳转到详情页面
                    let vc = SportDetailViewController()
                    vc.matchModel = matchModel
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeGridTableViewCell", for: indexPath) as! SportHomeGridTableViewCell
            cell.dataArray = self.matchTypeDataArray
            cell.clickBlock = {(matchTypeModel) in
                let vc = SportClassifyViewController()
                vc.matchTypeModel = matchTypeModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 210
        } else {
            return screenWidth
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1){
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let header = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 30))
            let label = UILabel.init()
            label.text = "Browse by category"
            label.sizeToFit()
            label.frame = CGRect.init(x: 15, y: 0, width: label.width, height: header.height)
            header.addSubview(label)
            return header
        }
        return nil
    }
    
    //加载假数据
    func loadData() -> Void {
        let matchModel1 = DiscoverMatchDataContainer.init(1, GCSportType.basketball, GCSportTeamType.alphineSkiingBV, Date.init(), "The Governor's Academy", "AwayTeam1", 6, 3, true)
        let matchModel2 = DiscoverMatchDataContainer.init(2, GCSportType.lacrosse, GCSportTeamType.basketballBJV, Date.init(), "The Governor's Academy", "AwayTeam2", 3, 3, true)
        let matchModel3 = DiscoverMatchDataContainer.init(3, GCSportType.baseballSoftball, GCSportTeamType.basketballGV, Date.init(), "AwayTeam1", "The Governor's Academy", 4, 6, true)
        let matchModel4 = DiscoverMatchDataContainer.init(4, GCSportType.volleyball, GCSportTeamType.trackNfieldOutdoorBV, Date.init(), "AwayTeam1", "The Governor's Academy", 2, 3, true)
        self.headDataArray = [matchModel1,matchModel2,matchModel3,matchModel4]
        self.matchTypeDataArray = [.soccer, .football, .volleyball, .hockey, .basketball, .lacrosse, .baseballSoftball, .tennis, .other]
        self.tableView.reloadData()
    }
}
