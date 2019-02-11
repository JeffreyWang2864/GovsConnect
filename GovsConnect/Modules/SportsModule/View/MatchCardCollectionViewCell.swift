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
    var data: Int?{
        didSet{
            switch self.data! {
            case 0:
                self.cardView.backgroundColor = UIColorFromRGB(rgbValue: 0x5CC7AE, alpha: 0.7)
                if self.isFirstTime{
                    self.isFirstTime = false
                    self.becomeLive()
                }
            case 1:
                self.cardView.backgroundColor = UIColorFromRGB(rgbValue: 0x98C5B5, alpha: 0.7)
            case 2:
                self.cardView.backgroundColor = UIColorFromRGB(rgbValue: 0xB0ECE1, alpha: 0.7)
            default:
                self.cardView.backgroundColor = UIColorFromRGB(rgbValue: 0xC5E6E8, alpha: 0.7)
            }
            self.sportTeamLabel.text = "Boys Varsity Lacrosse vs. Tabor Academy"
            self.homeAwayLabel.text = "HOME"
            self.startTimeLabel.text = timeStringFormat(Date.init(timeIntervalSinceNow: 0), withWeek: true)
            self.resultLabel.text = "started just now"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //card view:
        //  height: 200
        //  width:  screenWidth
        self.cardView.layer.cornerRadius = 10
        self.cardView.clipsToBounds = true
        self.cardView.frame = CGRect(x: 5, y: 25, width: screenWidth - 14 - 30, height: 160)
        self.backgroundImageView = UIImageView.init(image: UIImage.init(named: "tennis_test.png")!)
        self.backgroundImageView.frame = CGRect.init(x: self.cardView.width - 100, y: self.cardView.height, width: 120, height: 70)
        self.backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.alpha = 0.4
        self.cardView.addSubview( self.backgroundImageView)
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
        
        //table view
        self.tableView.frame = CGRect(x: 2, y: 235, width: screenWidth - 30 - 4, height: 580)
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
        self.scrollView.contentSize = CGSize(width: screenWidth - 30 - 4, height: self.cardView.height + self.tableView.height + 60)
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.alwaysBounceHorizontal = false
    }
    
    func becomeLive(){
        UIView.animate(withDuration: 0.3){
            self.cardView.frame = CGRect(x: 2, y: 5, width: screenWidth - 30 - 4, height: 200)
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
        UIView.animate(withDuration: 0.3){
            self.cardView.frame = CGRect(x: 7, y: 25, width: screenWidth - 14 - 30, height: 160)
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
            cell.data = indexPath.section
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MATCH_LOCATION_TABLEVIEW_CELL_ID", for: indexPath) as! MatchLocationTableViewCell
            cell.data = self.cardView.backgroundColor!
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "MATCH_DIRECTION_TABLEVIEW_CELL_ID", for: indexPath) as! MatchDirectionTableViewCell
        cell.data = self.cardView.backgroundColor!
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
