//
//  NewFoodTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/22.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class NewFoodTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dislikeButton: UIButton!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    var isLikedOrDisliked = false
    var data: DiscoverFoodDataContainer?{
        didSet{
            self.label.text = self.data!.title
            self.isLikedOrDisliked = false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeButton.setImage(UIImage(named: "system_discover_food_like.png")!, for: .normal)
        self.dislikeButton.setImage(UIImage(named: "system_discover_food_dislike.png")!, for: .normal)
        self.label.layer.cornerRadius = 15
        self.label.clipsToBounds = true
        self.likeButton.layer.cornerRadius = self.likeButton.width / 2
        self.likeButton.clipsToBounds = true
        self.dislikeButton.layer.cornerRadius = self.dislikeButton.width / 2
        self.dislikeButton.clipsToBounds = true
        self.visualEffectView.layer.cornerRadius = 15
        self.visualEffectView.clipsToBounds = true
        self.visualEffectView.backgroundColor = APP_BACKGROUND_GREY
        self.likeButton.addTarget(self, action: #selector(self.isLiked(_:)), for: .touchDown)
        self.dislikeButton.addTarget(self, action: #selector(self.isDisliked(_:)), for: .touchDown)
        switch PHONE_TYPE {
        case .iphone5:
            self.label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        case .iphone6:
            self.label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        default:
            self.label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
    }
    
    @objc func isLiked(_ button: UIButton){
        if !self.isLikedOrDisliked{
            AppIOManager.shared.foodDataAction(food_id: self.data!._id, method: "plus"){isPassed in
                let textLabel = UILabel(frame: CGRect(x: -40, y: 10, width: 40, height: 40))
                textLabel.text = "+1"
                textLabel.textColor = UIColor(red: 0.314, green: 0.710, blue: 0.482, alpha: 1.0)
                self.addSubview(textLabel)
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                UIView.animate(withDuration: 0.3){
                    textLabel.x = 10
                    self.visualEffectView.x += 20
                    self.visualEffectView.width -= 20
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                    UIView.animate(withDuration: 0.3, animations: {
                        textLabel.x = -40
                        self.visualEffectView.x -= 20
                        self.visualEffectView.width += 20
                    }, completion: { (isCompleted) in
                        textLabel.removeFromSuperview()
                    })
                }
                self.isLikedOrDisliked = true
            }
            return
        }
        UIView.animate(withDuration: 0.05){
            self.visualEffectView.x += 4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            UIView.animate(withDuration: 0.05){
                self.visualEffectView.x -= 7
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            UIView.animate(withDuration: 0.05){
                self.visualEffectView.x += 3
            }
        }
    }
    
    @objc func isDisliked(_ button: UIButton){
        if !self.isLikedOrDisliked{
            AppIOManager.shared.foodDataAction(food_id: self.data!._id, method: "minus"){isPassed in
                let textLabel = UILabel(frame: CGRect(x: -40, y: 10, width: 40, height: 40))
                textLabel.text = "-1"
                textLabel.textColor = UIColor(red: 0.933, green: 0.400, blue: 0.380, alpha: 1.0)
                self.addSubview(textLabel)
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                UIView.animate(withDuration: 0.3){
                    textLabel.x = 10
                    self.visualEffectView.x += 20
                    self.visualEffectView.width -= 20
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8){
                    UIView.animate(withDuration: 0.3, animations: {
                        textLabel.x = -40
                        self.visualEffectView.x -= 20
                        self.visualEffectView.width += 20
                    }, completion: { (isCompleted) in
                        textLabel.removeFromSuperview()
                    })
                }
                self.isLikedOrDisliked = true
            }
            return
        }
        UIView.animate(withDuration: 0.05){
            self.visualEffectView.x += 4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
            UIView.animate(withDuration: 0.05){
                self.visualEffectView.x -= 7
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            UIView.animate(withDuration: 0.05){
                self.visualEffectView.x += 3
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
