//
//  MenuSpecialityCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/3/8.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class MenuSpecialityCollectionViewCell: UICollectionViewCell {
    @IBOutlet var likeButton: LoveButton!
    @IBOutlet var foodLabel: UILabel!
    @IBOutlet var likeCount: UILabel!
    var data: DiscoverFoodDataContainer?{
        didSet{
            self.likeButton.isLoved = false
            self.foodLabel.text = self.data!.title
            self.likeCount.text = "\(self.data!.likeCount)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.foodLabel.numberOfLines = 0
        self.likeButton.isLoved = false
        switch PHONE_TYPE{
        case .iphone5:
            self.foodLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        case .iphone6, .iphonex, .iphonexr:
            self.foodLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        default:
            self.foodLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        self.likeButton.addTarget(self, action: #selector(self.liked(_:)), for: .touchDown)
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 15
        // Initialization code
    }
    
    @objc func liked(_ sender: LoveButton){
        guard self.likeButton.isLoved == false else{
            return
        }
        AppIOManager.shared.foodDataAction(food_id: self.data!._id, method: "plus"){isPassed in
            AppIOManager.shared.loadFoodDataThisWeek({ (isSucceed) in
                self.likeButton.isLoved = true
                self.data!.likeCount += 1
                self.likeCount.text = "\(self.data!.likeCount)"
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                //NotificationCenter.default.post(Notification.init(name: DiningHallMenuViewController.shouldReloadNotificationName))
            }) { (errStr) in
                makeMessageViaAlert(title: "failed to like", message: errStr)
            }
        }
    }
}
