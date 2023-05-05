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
    
    var data: SportsGame?{
        didSet{
            self.directionButton.setTitle("Open Location on Map", for: .normal)
            self.directionButton.setTitleColor(.white, for: .normal)
            self.directionButton.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            self.directionButton.backgroundColor = UIColor.init(red: 0.0, green: 0.4784, blue: 1.0, alpha: 1.0)
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
        self.directionButton.addTarget(self, action: #selector(self.didClickOnOpenInMap(_:)), for: .touchDown)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func didClickOnOpenInMap(_ button: UIButton){
        if self.data == nil{
            return
        }
        openCoordinateInMapApp(self.data!.location.coordinate, with: self.data!.homeTeam)
    }
    
    func becomeLive() {
        //
    }
    
    func endLive() {
        //
    }
    
}
