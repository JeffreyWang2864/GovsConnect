//
//  MessageNotificationTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/9/13.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class MessageNotificationTableViewCell: UITableViewCell {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var receivedTimeLabel: UILabel!
    var data: RemoteNotificationContainer?{
        didSet{
            self.messageLabel.text = self.data!.alertMessage
            self.receivedTimeLabel.text = "received " + prettyTimeSince(self.data!.receivedTimeInterval)
            self.messageLabel.sizeToFit()
            self.receivedTimeLabel.sizeToFit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
