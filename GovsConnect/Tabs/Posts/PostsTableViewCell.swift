//
//  PostsTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var authorNameDate: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postDescription: UILabel!
    @IBOutlet var viewLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var viewIcon: UIButton!
    @IBOutlet var likeIcon: UIButton!
    @IBOutlet var commentIcon: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_view.png"), for: .normal)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_viewed.png"), for: .selected)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_comment.png"), for: .normal)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_commented.png"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        NotificationCenter.default.post(name: BaseViewController.presentPostsDetailNotificationName, object: nil, userInfo: ["indexPath": self.tag])
    }
    
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        if self.likeIcon.isSelected{      //aleady liked
            self.likeIcon.isSelected = false
            NSLog("unliked")
            AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = false
            AppDataManager.shared.postsData[self.tag].likeCount -= 1
            self.likeLabel.text = "\(Int(self.likeLabel.text!)! - 1)"
            self.reloadInputViews()
            return
        }
        self.likeIcon.isSelected = true
        NSLog("click on like")
        AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = true
        AppDataManager.shared.postsData[self.tag].likeCount += 1
        self.likeLabel.text = "\(Int(self.likeLabel.text!)! + 1)"
    }
    
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        NotificationCenter.default.post(name: BaseViewController.presentPostsDetailNotificationName, object: nil, userInfo: ["indexPath": self.tag])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
            NotificationCenter.default.post(Notification(name: PostsDetailViewController.startCommentingNotificationName))
        }
    }
}
