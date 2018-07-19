//
//  CourseDescriptionTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/19.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class CourseDescriptionTableViewCell: UITableViewCell {
    @IBOutlet var textView: UITextView!
    @IBOutlet var fakeFooterView: UIView!
    var uid: String!{
        didSet{
            let data = AppDataManager.shared.users[uid]!
            let mutableattstring = NSMutableAttributedString(string: "\(data.name): \(data.description)")
            mutableattstring.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .bold)], range: NSRange(location: 0, length: data.name.count + 1))
            mutableattstring.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .regular)], range: NSRange(location: data.name.count + 2, length: data.description.count))
            self.textView.attributedText = mutableattstring
            self.textView.sizeToFit()
            self.textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.fakeFooterView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
