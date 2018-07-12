//
//  FoodCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    var originFrame: CGRect? = nil
    var indexTag: IndexPath!
    var data: DiscoverFoodDataContainer!{
        didSet{
            self.imageView.image = UIImage(named: data!.imageName)
            self.textView.text = data!.title
            self.textView.sizeToFit()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 20
        self.textView.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    func changeFrame(with velocity: CGFloat){
        if velocity > 0{
            //move down
            if self.frame.origin.y < self.originFrame!.origin.y{
                //already moved up. Now move down
                let movedYPos = self.frame.origin.y + velocity * 0.02
                let movedHeight = self.frame.size.height - velocity * 0.02
                self.frame = CGRect(x: self.frame.origin.x, y: min(self.originFrame!.origin.y, movedYPos), width: self.frame.size.width, height: max(self.originFrame!.size.height, movedHeight))
                let heightConstraint = self.textView.constraints[0]
                heightConstraint.constant = max(110, heightConstraint.constant - velocity * 0.02)
            }else{
                //regular case
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height + velocity * 0.02)
                let heightConstraint = self.textView.constraints[0]
                heightConstraint.constant += velocity * 0.01
            }
        }else if velocity < 0{
            if self.frame.size.height > self.originFrame!.size.height && self.frame.origin.y + 1 >= self.originFrame!.origin.y{
                //already moved down. Now move up
                let movedHeight = self.frame.size.height + velocity * 0.02
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: max(self.originFrame!.size.height, movedHeight))
                let heightConstraint = self.textView.constraints[0]
                heightConstraint.constant = max(110, heightConstraint.constant + velocity * 0.01)
            }else{
                //move up
                self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + velocity * 0.02, width: self.frame.size.width, height: self.frame.size.height - velocity * 0.02)
                let heightConstraint = self.textView.constraints[0]
                heightConstraint.constant -= velocity * 0.01
            }
        }
    }
    
    func changeBackToOriginal(){
        let heightConstraint = self.textView.constraints[0]
        heightConstraint.constant = 110
        self.frame = self.originFrame!
    }
}
