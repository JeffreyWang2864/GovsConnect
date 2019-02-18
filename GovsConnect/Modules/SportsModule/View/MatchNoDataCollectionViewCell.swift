//
//  MatchNoDataCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/15.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MatchNoDataCollectionViewCell: UICollectionViewCell, GCAnimatedCell {
    @IBOutlet var textLabel: UILabel!
    var data: String?{
        didSet{
            self.textLabel.text = "No sports event for \(self.data!)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        
        // Initialization code
    }
    
    func becomeLive() {
        //
    }
    
    func endLive() {
        //
    }

}
