//
//  MultiMediaCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/13.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class MultiMediaCollectionViewCell: UICollectionViewCell {
    @IBOutlet var centerImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
        // Initialization code
    }
}
