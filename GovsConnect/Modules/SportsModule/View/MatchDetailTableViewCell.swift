//
//  MatchDetailTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/8.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MatchDetailTableViewCell: UITableViewCell, GCAnimatedCell {
    @IBOutlet var versusLabel: UILabel!
    @IBOutlet var homeTeamIcon: UIImageView!
    @IBOutlet var awayTeamIcon: UIImageView!
    @IBOutlet var homeTeamLabel: UILabel!
    @IBOutlet var awayTeamLabel: UILabel!
    @IBOutlet var homeTeamScore: UILabel!
    @IBOutlet var awayTeamScore: UILabel!
    
    var data: Int?{
        didSet{
            self.homeTeamIcon.image = UIImage.init(named: "governor_logo_test.jpg")
            self.awayTeamIcon.image = UIImage.init(named: "tabor_logo_test.jpg")
            self.homeTeamLabel.text = "The Governor's Academy"
            self.awayTeamLabel.text = "Tabor Academy"
            self.homeTeamScore.text = "88"
            self.awayTeamScore.text = "12"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.homeTeamIcon.clipsToBounds = true
        self.homeTeamIcon.layer.cornerRadius = self.homeTeamIcon.width / 2
        self.homeTeamIcon.contentMode = .scaleAspectFill
        self.awayTeamIcon.clipsToBounds = true
        self.awayTeamIcon.layer.cornerRadius = self.homeTeamIcon.width / 2
        self.awayTeamIcon.contentMode = .scaleAspectFill
        self.versusLabel.textAlignment = .center
        self.versusLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        self.versusLabel.textColor = UIColor.black
        self.versusLabel.text = ":"
        self.homeTeamScore.textAlignment = .center
        self.homeTeamScore.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        self.homeTeamScore.numberOfLines = 1
        self.homeTeamScore.textColor = UIColor.black
        self.awayTeamScore.textAlignment = .center
        self.awayTeamScore.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        self.awayTeamScore.numberOfLines = 1
        self.awayTeamScore.textColor = UIColor.black
        self.homeTeamLabel.numberOfLines = 3
        self.homeTeamLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.homeTeamLabel.textAlignment = .center
        self.homeTeamLabel.textColor = UIColor.black
        self.awayTeamLabel.numberOfLines = 3
        self.awayTeamLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.awayTeamLabel.textAlignment = .center
        self.awayTeamLabel.textColor = UIColor.black
        self.clipsToBounds = true
        self.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func becomeLive() {
        //
    }
    
    func endLive() {
        //
    }
    
}
