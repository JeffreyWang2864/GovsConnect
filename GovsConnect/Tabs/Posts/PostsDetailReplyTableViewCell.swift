//
//  PostsDetailReplyTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/10.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsDetailReplyTableViewCell: UITableViewCell {
    @IBOutlet var likeIcon: UIButton!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var replierImage: UIImageView!
    @IBOutlet var replyHeading: UILabel!
    @IBOutlet var replyBody: UILabel!
    var correspondTag: (Int, Int) = (-1, -1)
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        if self.likeIcon.isSelected{      //aleady liked
            self.likeIcon.isSelected = false
            NSLog("unliked")
            AppDataManager.shared.postReplies[self.correspondTag.0][self.correspondTag.1].isLikedByCurrentUser = false
            AppDataManager.shared.postReplies[self.correspondTag.0][self.correspondTag.1].likeCount -= 1
            self.likeCount.text = "\(Int(self.likeCount.text!)! - 1)"
            self.reloadInputViews()
            return
        }
        self.likeIcon.isSelected = true
        NSLog("click on like")
        AppDataManager.shared.postReplies[self.correspondTag.0][self.correspondTag.1].isLikedByCurrentUser = true
        AppDataManager.shared.postReplies[self.correspondTag.0][self.correspondTag.1].likeCount += 1
        self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
    }
}
