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
            
            switch self.sectionTitle.text {
            case _ where self.sectionTitle.text!.contains("Bakery"):
                self.sectionImage.image = UIImage.init(named: "menu_bakery_section")!
            case _ where self.sectionTitle.text!.contains("Grill"):
                self.sectionImage.image = UIImage.init(named: "menu_grill_section")!
            case _ where self.sectionTitle.text!.contains("Home"):
                self.sectionImage.image = UIImage.init(named: "menu_homecooking_section")!
            case _ where self.sectionTitle.text!.contains("Pasta"):
                self.sectionImage.image = UIImage.init(named: "menu_pasta_section")!
            case _ where self.sectionTitle.text!.contains("Pizza"):
                self.sectionImage.image = UIImage.init(named: "menu_pizza_section")!
            case _ where self.sectionTitle.text!.contains("Salad"):
                self.sectionImage.image = UIImage.init(named: "menu_salad_section")!
            case _ where self.sectionTitle.text!.contains("International"):
                self.sectionImage.image = UIImage.init(named: "menu_international_section")!
            default:
                self.sectionImage.image = UIImage.init(named: "test_menu_section_icon")!
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 20
    }

}
