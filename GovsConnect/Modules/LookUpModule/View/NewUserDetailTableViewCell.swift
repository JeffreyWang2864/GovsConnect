//
//  NewUserDetailTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class NewUserDetailTableViewCell: UITableViewCell {
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var labelBackgroundView: UIView!
    @IBOutlet var detailTextView: UITextView!
    @IBOutlet var textBackgroundView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelBackgroundView.backgroundColor = UIColor.white
        self.labelBackgroundView.clipsToBounds = true
        self.labelBackgroundView.layer.cornerRadius = 7
        self.textBackgroundView.backgroundColor = UIColor.white
        self.textBackgroundView.clipsToBounds = true
        self.textBackgroundView.layer.cornerRadius = 7
        self.backgroundColor = UIColor.clear
        // Initialization code
    }
    
    func setText(title: String, detail: String){
        self.titleTextView.text = title
        self.detailTextView.text = detail
        self.titleTextView.textContainerInset = .zero
        self.detailTextView.textContainerInset = .zero
        self.detailTextView.dataDetectorTypes = .all
        self.titleTextView.sizeToFit()
        self.detailTextView.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
