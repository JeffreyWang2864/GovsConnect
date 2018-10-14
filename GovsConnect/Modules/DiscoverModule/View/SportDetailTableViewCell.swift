//
//  SportDetailTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportDetailTableViewCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var homeScoreLabel:UILabel!
    var awayScoreLabel:UILabel!
    var homeIcon:UIImageView!
    var awayIcon:UIImageView!
    var colonLabel:UILabel!
    var resultLabel:UILabel!
    
    var homeNameLabel:UILabel!
    var awayNameLabel:UILabel!
    
    let iconHeight:CGFloat = 60
    var matchModel:DiscoverMatchDataContainer! {
        didSet {
            self.titleLabel.text = matchModel.isHome ? "HOME" : "AWAY"
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
            
            self.homeNameLabel.text = matchModel.homeTeam
            self.awayNameLabel.text = matchModel.awayTeam
            
            self.setNeedsLayout()
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.titleLabel = UILabel.init()
        self.titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.titleLabel.text = "Home"
        self.titleLabel.textColor = UIColor.lightGray
        self.contentView.addSubview(self.titleLabel)
        
        self.homeIcon = UIImageView.init()
        //self.homeIcon.backgroundColor = UIColor.randomColor
        self.contentView.addSubview(self.homeIcon)
        
        self.homeScoreLabel = UILabel.init()
        self.homeScoreLabel.font = UIFont.systemFont(ofSize: 15)
        self.homeScoreLabel.text = "6"
        self.contentView.addSubview(self.homeScoreLabel)
        
        self.colonLabel = UILabel.init()
        self.colonLabel.text = ":"
        self.contentView.addSubview(self.colonLabel)
        
        self.awayScoreLabel = UILabel.init()
        self.awayScoreLabel.font = UIFont.systemFont(ofSize: 15)
        self.awayScoreLabel.text = "2"
        self.contentView.addSubview(self.awayScoreLabel)
        
        self.awayIcon = UIImageView.init()
        //self.awayIcon.backgroundColor = UIColor.randomColor
        self.contentView.addSubview(self.awayIcon)
        
        self.resultLabel = UILabel.init()
        self.resultLabel.text = "win"
        self.contentView.addSubview(self.resultLabel)
        
        self.homeNameLabel = UILabel.init()
        self.homeNameLabel.textAlignment = .center
        self.homeNameLabel.numberOfLines = 0
        self.homeNameLabel.font = UIFont.systemFont(ofSize: 13)
        self.homeNameLabel.text = "the Govemor's Academy"
        self.contentView.addSubview(self.homeNameLabel)
        
        self.awayNameLabel = UILabel.init()
        self.awayNameLabel.textAlignment = .center
        self.awayNameLabel.numberOfLines = 0
        self.awayNameLabel.font = UIFont.systemFont(ofSize: 13)
        self.awayNameLabel.text = "Tabor Academy"
        self.contentView.addSubview(self.awayNameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.sizeToFit()
        self.titleLabel.frame = CGRect.init(x: (self.contentView.width - self.titleLabel.width) * 0.5, y: 15, width: self.titleLabel.width, height: self.titleLabel.height)
        
        self.colonLabel.sizeToFit()
        self.colonLabel.frame = CGRect.init(x: (self.contentView.width - self.colonLabel.width) * 0.5, y: self.titleLabel.bottom + 10, width: self.colonLabel.width, height: self.colonLabel.height)
        
        self.homeScoreLabel.sizeToFit()
        self.homeScoreLabel.frame = CGRect.init(x: self.colonLabel.left - 30 - self.homeScoreLabel.width, y: self.colonLabel.center.y - self.homeScoreLabel.height * 0.5, width: self.homeScoreLabel.width, height: self.homeScoreLabel.height)
        
        self.homeIcon.frame = CGRect.init(x: self.homeScoreLabel.left - iconHeight - 20, y: self.colonLabel.center.y - iconHeight * 0.5, width: iconHeight, height: iconHeight)
        self.homeIcon.circleView()
        
        self.awayScoreLabel.sizeToFit()
        self.awayScoreLabel.frame = CGRect.init(x: self.colonLabel.right + 30, y: self.homeScoreLabel.top, width: self.awayScoreLabel.width, height: self.awayScoreLabel.height)
        
        self.awayIcon.frame = CGRect.init(x: self.awayScoreLabel.right + 20, y: self.homeIcon.top, width: iconHeight, height: iconHeight)
        self.awayIcon.circleView()
        
        self.resultLabel.sizeToFit()
        self.resultLabel.frame = CGRect.init(x: (self.contentView.width - self.resultLabel.width) * 0.5, y: self.colonLabel.bottom + 20, width: self.resultLabel.width, height: self.resultLabel.height)
        
        let homeNameLableHeight = self.matchModel.homeTeam.boundingRectWithSize(size: CGSize.init(width: 100, height: 100), font: UIFont.systemFont(ofSize: 13), lineSpacing: 5, maxLines: 2)
        self.homeNameLabel.frame = CGRect.init(x: self.homeIcon.center.x - 50, y: self.homeIcon.bottom + 10, width: 100, height: homeNameLableHeight)
        
        let ayayNameLableHeight = self.matchModel.awayTeam.boundingRectWithSize(size: CGSize.init(width: 100, height: 100), font: UIFont.systemFont(ofSize: 13), lineSpacing: 5, maxLines: 2)
        self.awayNameLabel.frame = CGRect.init(x: self.awayIcon.center.x - 50, y: self.awayIcon.bottom + 10, width: 100, height: ayayNameLableHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
