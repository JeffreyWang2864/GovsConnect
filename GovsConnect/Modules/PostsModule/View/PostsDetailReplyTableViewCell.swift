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
        if PHONE_TYPE == .ipodtouch{
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
            self.likeIcon.isSelected = true
            AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].isLikedByCurrentUser = true
            AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].likeCount += 1
            self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
            self.reloadInputViews()
            self.likeAnimation()
        }
    }
    
    func likeAnimation(){
        let bigLikeImageV = UIImageView(frame: CGRect(x: self.left + self.width / 2 - 10, y: self.height / 2 - 10, width: 20, height: 20))
        bigLikeImageV.contentMode = .scaleAspectFill
        bigLikeImageV.image = UIImage.init(named: "system_like.png")!
        self.addSubview(bigLikeImageV)
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            bigLikeImageV.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            bigLikeImageV.alpha = 1.0
        }) { finished in
            bigLikeImageV.alpha = 0.0
            bigLikeImageV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            bigLikeImageV.removeFromSuperview()
        }
    }
    
    @IBAction func replyButtonDidClick(_ sender: UIButton){
        NotificationCenter.default.post(name: PostsDetailViewController.startCommentingNotificationName, object: nil, userInfo: ["replyTo": "\(AppDataManager.shared.postsData[self.correspondTag.0].replies[self.correspondTag.1].sender.uid)"])
    }
    
    @IBAction func authorImageDidClick(_ sender: UIImageView){
        self.authorBlock?()
    }
}
