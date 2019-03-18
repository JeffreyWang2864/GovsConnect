//
//  MenuEverydayCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/3/8.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MenuEverydayCollectionViewCell: UICollectionViewCell {
    @IBOutlet var foodLabel: UILabel!
    var data: DiscoverFoodDataContainer?{
        didSet{
            self.foodLabel.text = self.data!.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
