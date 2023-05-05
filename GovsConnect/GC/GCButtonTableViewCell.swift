//
//  GCButtonTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/16.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class GCButtonTableViewCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var switchButton: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didChangeSetting(_ sender: UISwitch){
        AppDataManager.shared.currentUserSetting[self.label.text!] = sender.isOn
    }
}
