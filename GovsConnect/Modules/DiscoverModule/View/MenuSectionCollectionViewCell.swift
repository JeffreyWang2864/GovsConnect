//
//  MenuSectionCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffery Wang on 11/1/20.
//  Copyright © 2020 Eagersoft. All rights reserved.
//

import UIKit

class MenuSectionCollectionViewCell: UICollectionViewCell {
    public static let ID = "MENU_SECTION_COLLECTIONVIEW_CELL"
    @IBOutlet var sectionImage: UIImageView!
    @IBOutlet var sectionTitle: UILabel!
    @IBOutlet var detailLabel: UILabel!
    
    var data: (String, String)?{
        didSet{
            self.sectionTitle.text = self.data!.0
            self.detailLabel.text = self.data!.1
            self.sectionImage.image = UIImage.init(named: "test_menu_section_icon")!
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 20
    }

}
