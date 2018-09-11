//
//  PersonTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/13.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PersonTableViewCell: UITableViewCell {
    @IBOutlet var personImage: UIImageView!
    @IBOutlet var personName: UILabel!
    @IBOutlet var personDetail: UILabel!
    var uid: String!{
        didSet{
            let userData = AppDataManager.shared.users[self.uid]!
            if userData.profession == .club || userData.profession == .course{
                self.personImage.image = UIImage.init(named: userData.profilePictureName)!
            }else{
                let imgData = AppDataManager.shared.profileImageData[userData.uid]!
                self.personImage.image = UIImage.init(data: imgData)!
            }
            self.personImage.clipsToBounds = true
            self.personImage.layer.cornerRadius = self.personImage.width / 2
            self.personName.text = userData.name
            self.personDetail.text = UserDetailViewController.getDescriptionText(data: userData)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
