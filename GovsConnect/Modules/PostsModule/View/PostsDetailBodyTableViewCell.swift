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
    @IBOutlet var postBody: UITextView!
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
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_comment.png"), for: .normal)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_commented.png"), for: .selected)
        // Initialization code
    }
    
    func addImagesAtEnd(_ names: Array<String>){
        let c = self.imageStackView.constraints[0]
        c.constant = CGFloat(200 * names.count + 1)
        var index = 0
        for name in names{
            let v = UIImageView()
            v.tag = index
            index += 1
            v.image = UIImage(data: AppDataManager.shared.imageData[name] ?? Data())
            v.contentMode = .scaleAspectFit
            v.isUserInteractionEnabled = true
            let gr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnImage(_:)))
            v.addGestureRecognizer(gr)
            self.imageStackView.addArrangedSubview(v)
        }
    }
    
    @objc func didClickOnImage(_ sender: UITapGestureRecognizer){
        let v = GCImageViewController()
        v.view.frame = self.window!.rootViewController!.view.bounds
        self.window!.rootViewController!.present(v, animated: true, completion: nil)
        let imgD = AppDataManager.shared.postsData[self.tag].postImagesName
        v.setupPaging(imgD, at: sender.view!.tag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        
    }
    
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        if self.likeIcon.isSelected{      //aleady liked
            
            AppIOManager.shared.like(at: AppDataManager.shared.postsData[self.tag]._uid, method: "minus"){ isSucceed in
                makeMessageViaAlert(title: "Success", message: "minus one on like")
                self.likeIcon.isSelected = false
                AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = false
                AppDataManager.shared.postsData[self.tag].likeCount -= 1
                self.likeCount.text = "\(Int(self.likeCount.text!)! - 1)"
                self.reloadInputViews()
            }
            return
        }
        
        AppIOManager.shared.like(at: AppDataManager.shared.postsData[self.tag]._uid, method: "plus"){ isSucceed in
            self.likeIcon.isSelected = true
            AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = true
            AppDataManager.shared.postsData[self.tag].likeCount += 1
            self.likeCount.text = "\(Int(self.likeCount.text!)! + 1)"
        }
    }
    
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        NSLog("here")
        NotificationCenter.default.post(Notification(name: PostsDetailViewController.startCommentingNotificationName))
    }
    
}
