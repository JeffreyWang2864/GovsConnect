//
//  MatchCardCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/3.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MatchCardCollectionViewCell: UICollectionViewCell, GCAnimatedCell {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var cardView: UIView!
    var tableView = UITableView()
    @IBOutlet var sportTeamLabel: UILabel!
    @IBOutlet var homeAwayLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var resultLabel: UILabel!
    var backgroundImageView = UIImageView()
    var isFirstTime = true
    var data: SportsGame?{
        didSet{
            self.cardView.backgroundColor = SPORTS_TYPE_COLOR[self.data!.catagory]
            self.sportTeamLabel.text = "\(self.data!.team.rawValue) vs. \(self.data!.isHome ? self.data!.awayTeam : self.data!.homeTeam)"
            self.homeAwayLabel.text = self.data!.isHome ? "HOME" : "AWAY"
            self.startTimeLabel.text = timeStringFormat(self.data!.startTime, withWeek: true)
            self.resultLabel.text = self.data!.result == .yetToBeStarted ? prettyTime(to: self.data!.startTime.timeIntervalSinceNow) : self.data!.result.rawValue
            //table view
            self.setupView()
            self.tableView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //card view:
        //  height: 200
        //  width:  screenWidth
    }
    
    private func setupView(){
        self.cardView.layer.cornerRadius = 10
        self.cardView.clipsToBounds = true
        self.cardView.frame = CGRect(x: 5, y: 25 + 80, width: screenWidth - 14 - 30, height: 160)
        self.backgroundImageView.removeFromSuperview()
        self.backgroundImageView = UIImageView.init(image: UIImage.init(named: SPORTS_TYPE_BACKGROUND_IMAGE[self.data!.catagory]!)!)
        self.backgroundImageView.frame = CGRect.init(x: self.cardView.width - 100, y: self.cardView.height, width: 120, height: 70)
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.alpha = 0.4
        self.cardView.addSubview(self.backgroundImageView)
        let CARD_VIEW_HEIGHT: CGFloat = 200
        let CARD_VIEW_WIDTH: CGFloat = self.cardView.width
        self.sportTeamLabel.frame = CGRect(x: 20, y: CARD_VIEW_HEIGHT * 0.2, width: CARD_VIEW_WIDTH - 40, height: 50)
        self.sportTeamLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.sportTeamLabel.textColor = UIColor.white
        self.sportTeamLabel.textAlignment = .center
        self.sportTeamLabel.numberOfLines = 0
        self.homeAwayLabel.frame = CGRect(x: 0, y: CARD_VIEW_HEIGHT * 0.55, width: CARD_VIEW_WIDTH, height: 15)
        self.homeAwayLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.homeAwayLabel.textAlignment = .center
        self.homeAwayLabel.textColor = UIColor.white
        self.homeAwayLabel.numberOfLines = 1
        self.startTimeLabel.frame = CGRect(x: 0, y: self.homeAwayLabel.y + self.homeAwayLabel.height + 5, width: CARD_VIEW_WIDTH, height: 15)
        self.startTimeLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.startTimeLabel.textAlignment = .center
        self.startTimeLabel.textColor = UIColor.white
        self.startTimeLabel.numberOfLines = 1
        self.resultLabel.frame = CGRect(x: 0, y: self.startTimeLabel.y + self.startTimeLabel.height + 5, width: CARD_VIEW_WIDTH, height: 15)
        self.resultLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        self.resultLabel.textAlignment = .center
        self.resultLabel.textColor = UIColor.white
        self.resultLabel.numberOfLines = 1
        
        //tableView
        self.tableView.frame = CGRect(x: 2, y: 235 + 80, width: screenWidth - 30 - 4, height: 480)
        self.tableView.alpha = 0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "MatchDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MATCH_DETAIL_TABLEVIEW_CELL_ID")
        self.tableView.register(UINib.init(nibName: "MatchLocationTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MATCH_LOCATION_TABLEVIEW_CELL_ID")
        self.tableView.register(UINib.init(nibName: "MatchDirectionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "MATCH_DIRECTION_TABLEVIEW_CELL_ID")
        self.scrollView.addSubview(self.tableView)
        self.scrollView.contentSize = CGSize(width: screenWidth - 30 - 4, height: self.cardView.height + self.tableView.height + 60 + 80)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.alwaysBounceHorizontal = false
//        if AppDataManager.shared.sportsGameData[0] == self.data!{
//            if self.isFirstTime{
//                self.isFirstTime = false
//                self.becomeLive()
//            }
//        }
    }
    
    func becomeLive(){
        UIView.animate(withDuration: 0.3){
            self.cardView.frame = CGRect(x: 2, y: 5 + 80, width: screenWidth - 30 - 4, height: 200)
            self.backgroundImageView.frame = CGRect.init(x: self.cardView.width - 100, y: self.cardView.height - 60, width: 120, height: 70)
            self.tableView.alpha = 1.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let cells = self.tableView.visibleCells as! [GCAnimatedCell]
            for cell in cells{
                cell.becomeLive()
            }
        }
    }
    
    func endLive(){
        self.scrollView.setContentOffset(.zero, animated: true)
        UIView.animate(withDuration: 0.3){
            self.cardView.frame = CGRect(x: 7, y: 25 + 80, width: screenWidth - 14 - 30, height: 160)
            self.backgroundImageView.frame = CGRect.init(x: self.cardView.width - 100, y: self.cardView.height + 30, width: 120, height: 70)
            self.tableView.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let cells = self.tableView.visibleCells as! [GCAnimatedCell]
            for cell in cells{
                cell.endLive()
            }
        }
    }
}

extension MatchCardCollectionViewCell: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 170
        }else if indexPath.section == 1{
            return 200
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MATCH_DETAIL_TABLEVIEW_CELL_ID", for: indexPath) as! MatchDetailTableViewCell
            cell.data = self.data!
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MATCH_LOCATION_TABLEVIEW_CELL_ID", for: indexPath) as! MatchLocationTableViewCell
            cell.data = self.data!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MATCH_DIRECTION_TABLEVIEW_CELL_ID", for: indexPath) as! MatchDirectionTableViewCell
        cell.data = self.data!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.height = 15
        return footerView
    }
}
