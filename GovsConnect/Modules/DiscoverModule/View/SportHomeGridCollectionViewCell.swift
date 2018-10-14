//
//  SportHomeGridCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportHomeGridCollectionViewCell: UICollectionViewCell {
    var icon:UIImageView!
    var nameLabel:UILabel!
    
    var matchTypeModel:GCSportType! {
        didSet {
            self.nameLabel.text = matchTypeModel.rawValue
            //todo:图标需要设置
            self.setNeedsLayout()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.icon = UIImageView.init()
        //self.icon.backgroundColor = UIColor.randomColor
        self.contentView.addSubview(self.icon)
        
        self.nameLabel = UILabel.init()
        self.nameLabel.textAlignment = .center
        self.nameLabel.text = "volleyball"
        self.nameLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(self.nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.icon.frame = CGRect.init(x: 0, y: 0, width: self.contentView.width, height: self.contentView.height * 3.0 / 4.0)
        
        self.nameLabel.sizeToFit()
        self.nameLabel.frame = CGRect.init(x: 0, y: self.contentView.height - self.nameLabel.height - 3, width: self.contentView.width, height: self.nameLabel.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
