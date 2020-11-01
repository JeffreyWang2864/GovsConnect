//
//  MenuSpecialityCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/3/8.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MenuSpecialityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var foodLabel: UILabel!
    var data: DiscoverFoodDataContainer?{
        didSet{
            self.foodLabel.text = self.data!.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodLabel.numberOfLines = 0
        switch PHONE_TYPE{
        case .iphone5:
            self.foodLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .iphone6, .iphonex, .iphonexr:
            self.foodLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        default:
            self.foodLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 15
        // Initialization code
    }
}
