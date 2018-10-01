//
//  PostsDetailReplyTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/10.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

typealias PostsDetailTableViewCellAuthorBlock = () -> ()

class PostsDetailReplyTableViewCell: UITableViewCell {
    @IBOutlet var likeIcon: UIButton!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var replierImageButton: UIButton!
    @IBOutlet var replyHeading: UILabel!
    @IBOutlet var replyBody: UITextView!
    var correspondTag: (Int, Int) = (-1, -1)
    var authorBlock: PostsDetailTableViewCellAuthorBlock?
    override func awakeFromNib() {
        super.awakeFromNib()
        if PHONE_TYPE == .iphone5{
            self.replyHeading.font = UIFont.systemFont(ofSize: 12)
        }
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
            let reply_id = AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1]._uid
            AppIOManager.shared.dislikeReply(local_post_id: self.correspondTag.0, reply_id: reply_id) { (isSucceed) in
                makeMessageViaAlert(title: "minus one like on reply", message: "successfully minus one like on reply")
                self.likeIcon.isSelected = false
                AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].isLikedByCurrentUser = false
                AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].likeCount -= 1
                self.likeCount.text = "\(Int(self.likeCount.text!)! - 1)"
                self.reloadInputViews()
            }
            return
        }
        let reply_id = AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1]._uid
        AppIOManager.shared.likeReply(local_post_id: self.correspondTag.0, reply_id: reply_id) { (isSucceed) in
            makeMessageViaAlert(title: "plus one like on reply", message: "successfully plus one like on reply")
            self.likeIcon.isSelected = true
            AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].isLikedByCurrentUser = true
            AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].likeCount += 1
            self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
            self.reloadInputViews()
        }
    }
    
    @IBAction func replyButtonDidClick(_ sender: UIButton){
        NotificationCenter.default.post(name: PostsDetailViewController.startCommentingNotificationName, object: nil, userInfo: ["replyTo": "\(AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].sender.uid)"])
    }
    
    @IBAction func authorImageDidClick(_ sender: UIImageView){
        self.authorBlock?()
    }
}
