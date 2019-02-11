//
//  MatchDirectionTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/10.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MatchDirectionTableViewCell: UITableViewCell, GCAnimatedCell {
    @IBOutlet var directionButton: UIButton!
    
    var data: UIColor?{
        didSet{
            let firstLabel = UILabel()
            firstLabel.backgroundColor = UIColorFromRGB(rgbValue: 0x006FFF, alpha: 1.0)
            firstLabel.text = "Directions"
            firstLabel.textColor = UIColor.white
            firstLabel.textAlignment = .center
            firstLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
            firstLabel.frame = CGRect(x: 0, y: 0, width: self.width, height: self.directionButton.height * 0.55)
            self.directionButton.addSubview(firstLabel)
            let secondLabel = UILabel()
            secondLabel.backgroundColor = UIColorFromRGB(rgbValue: 0x006FFF, alpha: 1.0)
            secondLabel.textColor = UIColor.white
            secondLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            secondLabel.text = "estimate driving time: 40 minutes"
            secondLabel.textAlignment = .center
            secondLabel.frame = CGRect(x: 0, y: self.directionButton.height * 0.50, width:  self.width, height: self.directionButton.height * 0.4)
            self.directionButton.addSubview(secondLabel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.directionButton.titleLabel!.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.directionButton.titleLabel!.textColor = UIColor.white
        self.directionButton.clipsToBounds = true
        self.directionButton.layer.cornerRadius = 10
        self.directionButton.setTitleColor(UIColor.white, for: .normal)
        self.directionButton.backgroundColor = UIColorFromRGB(rgbValue: 0x006FFF, alpha: 1.0)
        self.directionButton.setTitle("", for: .normal)
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
