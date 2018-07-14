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
            self.personImage.image = UIImage(named: userData.profilePictureName)
            self.personName.text = userData.name
            self.personDetail.text = "\(userData.department.rawValue) from \(userData.fromPlace)"
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
