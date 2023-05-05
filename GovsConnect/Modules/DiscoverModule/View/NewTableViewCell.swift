//
//  NewTableViewCell.swift
//  GovsConnectTest
//
//  Created by Jeffrey Wang on 2018/7/2.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class NewTableViewCell: UITableViewCell {
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var ampmLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
