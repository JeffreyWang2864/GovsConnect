//
//  SportClassifyTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportClassifyTableViewCell: UITableViewCell {
    
    var backView:UIView!
    var matchNameLabel:UILabel!
    var queueLabel:UILabel!
    var startTimeLabel:UILabel!
    var scoreLabel:UILabel!
    var statusLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        self.backView = UIView.init()
        self.backView.backgroundColor = UIColorFromRGB(rgbValue: 0xf3f3f3, alpha: 0.9)
        self.contentView.addSubview(self.backView)
        
        self.matchNameLabel = UILabel.init()
        self.matchNameLabel.text = "Boy Varsity Volleyball"
        self.matchNameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.backView.addSubview(self.matchNameLabel)
        
        self.queueLabel = UILabel.init()
        self.queueLabel.text = "Home vs. Tabor Academy"
        self.queueLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.backView.addSubview(self.queueLabel)
        
        self.startTimeLabel = UILabel.init()
        self.startTimeLabel.text = "12:30. Fri 3/2/2018"
        self.startTimeLabel.font = UIFont.systemFont(ofSize: 13)
        self.backView.addSubview(self.startTimeLabel)
        
        self.scoreLabel = UILabel.init()
        self.scoreLabel.text = "22 - 12"
        self.scoreLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.backView.addSubview(self.scoreLabel)
        
        self.statusLabel = UILabel.init()
        self.statusLabel.text = "win"
        self.statusLabel.font = UIFont.boldSystemFont(ofSize: 15)
        self.statusLabel.textColor = UIColor.yellow
        self.backView.addSubview(self.statusLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backView.frame = CGRect.init(x: 15, y: 7.5, width: self.contentView.width - 30, height: self.contentView.height - 15)
        
        self.matchNameLabel.sizeToFit()
        self.matchNameLabel.frame = CGRect.init(x: 5, y: 10, width: self.matchNameLabel.width, height: self.matchNameLabel.height)
        
        self.queueLabel.sizeToFit()
        self.queueLabel.frame = CGRect.init(x: self.matchNameLabel.left, y: self.matchNameLabel.bottom + 7, width: self.queueLabel.width, height: self.queueLabel.height)
        
        self.startTimeLabel.sizeToFit()
        self.startTimeLabel.frame = CGRect.init(x: self.matchNameLabel.left, y: self.queueLabel.bottom + 15, width: self.startTimeLabel.width, height: self.startTimeLabel.height)
        
        self.scoreLabel.sizeToFit()
        self.statusLabel.sizeToFit()
        
        let margin = (self.contentView.height - self.scoreLabel.height - self.statusLabel.height - 10) * 0.5
        self.scoreLabel.frame = CGRect.init(x: self.backView.width - self.scoreLabel.width - 8, y: margin, width: self.scoreLabel.width, height: self.scoreLabel.height)
        
        self.scoreLabel.frame = CGRect.init(x: self.backView.width - self.scoreLabel.width - 8, y: margin, width: self.scoreLabel.width, height: self.scoreLabel.height)
        
        self.statusLabel.frame = CGRect.init(x: self.scoreLabel.left + (self.scoreLabel.width - self.statusLabel.width) * 0.5, y: self.scoreLabel.bottom + 10, width: self.statusLabel.width, height: self.statusLabel.height)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
