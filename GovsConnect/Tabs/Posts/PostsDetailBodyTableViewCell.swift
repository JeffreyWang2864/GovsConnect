//
//  PostsDetailBodyTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsDetailBodyTableViewCell: UITableViewCell {
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postBody: UILabel!
    @IBOutlet var viewIcon: UIButton!
    @IBOutlet var viewCount: UILabel!
    @IBOutlet var likeIcon: UIButton!
    @IBOutlet var likeCount: UILabel!
    @IBOutlet var commentIcon: UIButton!
    @IBOutlet var commentCount: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var imageStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageStackView.distribution = .fillEqually
        self.imageStackView.spacing = 5
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_view.png"), for: .normal)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_viewed.png"), for: .selected)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_comment.png"), for: .normal)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_commented.png"), for: .selected)
        // Initialization code
    }
    
    func addImagesAtEnd(_ names: Array<String>){
        let c = self.imageStackView.constraints[0]
        c.constant = CGFloat(200 * names.count + 1)
        for name in names{
            let v = UIImageView()
            v.image = UIImage(named: name)!
            v.contentMode = .scaleAspectFit
            self.imageStackView.addArrangedSubview(v)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        
    }
    
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        if self.likeIcon.isSelected{      //aleady liked
            self.likeIcon.isSelected = false
            NSLog("unliked")
            AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = false
            AppDataManager.shared.postsData[self.tag].likeCount -= 1
            self.likeCount.text = "\(Int(self.likeCount.text!)! - 1)"
            self.reloadInputViews()
            return
        }
        self.likeIcon.isSelected = true
        NSLog("click on like")
        AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = true
        AppDataManager.shared.postsData[self.tag].likeCount += 1
        self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
    }
    
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        NSLog("here")
        NotificationCenter.default.post(Notification(name: PostsDetailViewController.startCommentingNotificationName))
    }
    
}
