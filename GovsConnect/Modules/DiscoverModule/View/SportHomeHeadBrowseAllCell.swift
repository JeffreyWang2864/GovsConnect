//
//  SportHomeHeadBrowseAllCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class SportHomeHeadBrowseAllCell: UICollectionViewCell {
    var browseAllLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.browseAllLabel = UILabel.init()
        self.browseAllLabel.textAlignment = .center
        self.browseAllLabel.font = UIFont.systemFont(ofSize: 17)
        self.browseAllLabel.text = "Browse all"
        self.browseAllLabel.backgroundColor = UIColor.white
        self.contentView.addSubview(self.browseAllLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.browseAllLabel.frame = CGRect.init(x: 15, y: 15, width: self.contentView.width - 30, height: self.contentView.height - 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
