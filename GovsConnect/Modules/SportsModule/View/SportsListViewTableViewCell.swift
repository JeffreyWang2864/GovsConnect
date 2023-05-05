//
//  SportsListViewTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/20.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsListViewTableViewCell: UITableViewCell {
    @IBOutlet var gameTitle: UILabel!
    @IBOutlet var gameTime: UILabel!
    @IBOutlet var homeTeamIcon: UIImageView!
    @IBOutlet var homeTeamScore: UILabel!
    @IBOutlet var awayTeamIcon: UIImageView!
    @IBOutlet var awayTeamScore: UILabel!
    @IBOutlet var resultLabel: UILabel!
    var data: SportsGame?{
        didSet{
            self.gameTime.text = timeStringFormat(self.data!.startTime, withWeek: true)
            self.gameTitle.text = self.data!.team.rawValue + " vs. \(self.data!.isHome ? self.data!.awayTeam : self.data!.homeTeam)" + " @ \(self.data!.isHome ? "HOME" : "AWAY")"
            self.gameTitle.sizeToFit()
            self.homeTeamIcon.image = UIImage.init(named: SPORTS_TEAM_ICON[self.data!.homeTeam] ?? "default-opponent.png") ?? UIImage.init(named: "default-opponent.png")!
            self.awayTeamIcon.image = UIImage.init(named: SPORTS_TEAM_ICON[self.data!.awayTeam] ?? "default-opponent.png") ?? UIImage.init(named: "default-opponent.png")!
            self.homeTeamScore.text = self.data!.homeScore == -1 ? "-" : "\(self.data!.homeScore)"
            self.awayTeamScore.text = self.data!.awayScore == -1 ? "-" : "\(self.data!.awayScore)"
            switch self.data!.result{
            case .yetToBeStarted, .inProgress:
                self.resultLabel.text = "-"
                self.resultLabel.textColor = .gray
            case .defeat:
                self.resultLabel.text = "DEFEAT"
                self.resultLabel.textColor = UIColorFromRGB(rgbValue: 0xE46A70, alpha: 1)
            case .draw:
                self.resultLabel.text = "DRAW"
                self.resultLabel.textColor = UIColorFromRGB(rgbValue: 0xEEC558, alpha: 1)
            case .victory:
                self.resultLabel.text = "VICTORY"
                self.resultLabel.textColor = UIColorFromRGB(rgbValue: 0x6FB4FF, alpha: 1)
            default:
                self.resultLabel.text = "?"
                self.resultLabel.textColor = .black
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.gameTitle.numberOfLines = 0
        self.homeTeamIcon.layer.cornerRadius = self.homeTeamIcon.width / 2
        self.homeTeamIcon.clipsToBounds = true
        self.awayTeamIcon.layer.cornerRadius = self.awayTeamIcon.width / 2
        self.awayTeamIcon.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
