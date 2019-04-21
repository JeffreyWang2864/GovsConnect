//
//  MatchStatTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/20.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MatchStatTableViewCell: UITableViewCell, GCAnimatedCell {
    @IBOutlet var stackBar: GCStackBar!
    @IBOutlet var statTitle: UILabel!
    @IBOutlet var winLabel: UILabel!
    @IBOutlet var drawLabel: UILabel!
    @IBOutlet var loseLabel: UILabel!
    @IBOutlet var winLoseRatioLabel: UILabel!
    @IBOutlet var gfLabel: UILabel!
    @IBOutlet var gaLabel: UILabel!
    @IBOutlet var gfgaRatioLabel: UILabel!
    var data: SportsGame?{
        didSet{
            self.stackBar.stackData = [
                self.data!.stat.numberOfWin,
                self.data!.stat.numberOfDraw,
                self.data!.stat.numberOfLose
            ]
            self.statTitle.text = self.data!.team.rawValue + "'s stats:"
            self.winLabel.text = "win: \(self.data!.stat.numberOfWin)"
            if self.data!.stat.numberOfDraw == 0{
                self.drawLabel.text = ""
            }else{
                self.drawLabel.text = "draw: \(self.data!.stat.numberOfDraw)"
            }
            self.loseLabel.text = "loss: \(self.data!.stat.numberOfLose)"
            if self.data!.stat.winLossRatio == -1{
                self.winLoseRatioLabel.text = "win/loss ratio: undefeated"
            }else{
                self.winLoseRatioLabel.text = "win/loss ratio: " + String.init(format: "%.1f", self.data!.stat.winLossRatio)
            }
            self.gfLabel.text = "goal for(score) this season: \(self.data!.stat.goalScore)"
            self.gaLabel.text = "goal against this season: \(self.data!.stat.goalAgainst)"
            if self.data!.stat.scoreAgainstRatio == -1{
                self.gfgaRatioLabel.text = "GF GA ratio: infinity"
            }else{
                self.gfgaRatioLabel.text = "GF GA ratio: " + String.init(format: "%.1f", self.data!.stat.scoreAgainstRatio)
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stackBar.clipsToBounds = true
        self.stackBar.layer.cornerRadius = 10
        self.stackBar.alpha = 0.0
        self.clipsToBounds = true
        self.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func becomeLive() {
        if self.data != nil{
            self.stackBar.stackData = [
                self.data!.stat.numberOfWin,
                self.data!.stat.numberOfDraw,
                self.data!.stat.numberOfLose
            ]
        }
        UIView.animate(withDuration: 0.3){
            self.stackBar.alpha = 1
        }
    }
    
    func endLive() {
        UIView.animate(withDuration: 0.3){
            self.stackBar.alpha = 0
        }
    }
    
}
