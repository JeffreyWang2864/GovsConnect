//
//  SportHomeHeadCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportHomeHeadCollectionViewCell: UICollectionViewCell {
    
    var backView:UIView!
    var titleLabel:UILabel!
    var homeScoreLabel:UILabel!
    var awayScoreLabel:UILabel!
    var homeIcon:UIImageView!
    var awayIcon:UIImageView!
    var colonLabel:UILabel!
    var resultLabel:UILabel!
    var startTimeLabel:UILabel!
    var statusLabel:UILabel!
    let iconHeight:CGFloat = 60
    var matchModel:DiscoverMatchDataContainer! {
        didSet {
            self.titleLabel.text = matchModel.team.rawValue
            self.homeIcon.image = UIImage.init(named: "")
            self.homeScoreLabel.text = String.init(format: "%zd", matchModel.homeScore)
            self.awayScoreLabel.text = String.init(format: "%zd", matchModel.awayScore)
            self.awayIcon.image = UIImage.init(named: "")
            
            var resultText = "draw"
            self.resultLabel.textColor = UIColor.black
            if (matchModel.homeScore > matchModel.awayScore) {
                resultText = "win"
                self.resultLabel.textColor = UIColor.yellow
            } else if (matchModel.homeScore < matchModel.awayScore){
                resultText = "lost"
                self.resultLabel.textColor = UIColor.red
            }
            self.resultLabel.text = resultText
            
            self.startTimeLabel.text = timeStringFormat(self.matchModel.startTime, withWeek: true)
            self.statusLabel.text = prettyTime(to: matchModel.startTime.timeIntervalSince1970)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backView = UIView.init()
        self.backView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.backView)
        
        self.titleLabel = UILabel.init()
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.text = "Gril JV Football"
        self.backView.addSubview(self.titleLabel)
        
        self.homeIcon = UIImageView.init()
        
        self.backView.addSubview(self.homeIcon)
        
        self.homeScoreLabel = UILabel.init()
        self.homeScoreLabel.font = UIFont.systemFont(ofSize: 15)
        self.homeScoreLabel.text = "6"
        self.backView.addSubview(self.homeScoreLabel)
        
        self.colonLabel = UILabel.init()
        self.colonLabel.text = ":"
        self.backView.addSubview(self.colonLabel)
        
        self.awayScoreLabel = UILabel.init()
        self.awayScoreLabel.font = UIFont.systemFont(ofSize: 15)
        self.awayScoreLabel.text = "2"
        self.backView.addSubview(self.awayScoreLabel)
        
        self.awayIcon = UIImageView.init()
        self.backView.addSubview(self.awayIcon)
        
        self.resultLabel = UILabel.init()
        self.resultLabel.text = "win"
        self.backView.addSubview(self.resultLabel)
        
        self.startTimeLabel = UILabel.init()
        self.startTimeLabel.textColor = UIColor.lightGray
        self.startTimeLabel.font = UIFont.systemFont(ofSize: 13)
        self.startTimeLabel.text = "6:30,2/3/2018"
        self.backView.addSubview(self.startTimeLabel)
        
        self.statusLabel = UILabel.init()
        self.statusLabel.font = UIFont.systemFont(ofSize: 13)
        self.statusLabel.textColor = UIColor.lightGray
        self.statusLabel.text = "live"
        self.backView.addSubview(self.statusLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.frame = CGRect.init(x: 15, y: 15, width: self.contentView.width - 30, height: self.contentView.height - 30)
        
        self.titleLabel.sizeToFit()
        self.titleLabel.frame = CGRect.init(x: (self.backView.width - self.titleLabel.width) * 0.5, y: 15, width: self.titleLabel.width, height: self.titleLabel.height)
        
        self.colonLabel.sizeToFit()
        self.colonLabel.frame = CGRect.init(x: (self.backView.width - self.colonLabel.width) * 0.5, y: self.titleLabel.bottom + 30, width: self.colonLabel.width, height: self.colonLabel.height)
        
        self.homeScoreLabel.sizeToFit()
        self.homeScoreLabel.frame = CGRect.init(x: self.colonLabel.left - 30 - self.homeScoreLabel.width, y: self.colonLabel.center.y - self.homeScoreLabel.height * 0.5, width: self.homeScoreLabel.width, height: self.homeScoreLabel.height)
        
        self.homeIcon.frame = CGRect.init(x: self.homeScoreLabel.left - iconHeight - 10, y: self.colonLabel.center.y - iconHeight * 0.5, width: iconHeight, height: iconHeight)
        self.homeIcon.circleView()
        
        self.awayScoreLabel.sizeToFit()
        self.awayScoreLabel.frame = CGRect.init(x: self.colonLabel.right + 30, y: self.homeScoreLabel.top, width: self.awayScoreLabel.width, height: self.awayScoreLabel.height)
        
        self.awayIcon.frame = CGRect.init(x: self.awayScoreLabel.right + 10, y: self.homeIcon.top, width: iconHeight, height: iconHeight)
        self.awayIcon.circleView()
        
        self.resultLabel.sizeToFit()
        self.resultLabel.frame = CGRect.init(x: (self.backView.width - self.resultLabel.width) * 0.5, y: self.colonLabel.bottom + 20, width: self.resultLabel.width, height: self.resultLabel.height)
        
        self.startTimeLabel.sizeToFit()
        self.startTimeLabel.frame = CGRect.init(x: (self.backView.width - self.startTimeLabel.width) * 0.5, y: self.colonLabel.bottom + 45, width: self.startTimeLabel.right, height: self.startTimeLabel.height)
        
        self.statusLabel.sizeToFit()
        self.statusLabel.frame = CGRect.init(x: (self.backView.width - self.statusLabel.width) * 0.5, y: self.startTimeLabel.bottom + 5, width: self.statusLabel.width, height: self.statusLabel.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
