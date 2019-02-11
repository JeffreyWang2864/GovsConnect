//
//  UserDetailTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/17.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class UserDetailTableViewCell: UITableViewCell {
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var fakeSeparator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fakeSeparator.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        // Initialization code
        if PHONE_TYPE == .iphone5{
            self.titleTextView.font = UIFont.systemFont(ofSize: 12)
            self.detailTextView.font = UIFont.systemFont(ofSize: 12)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
