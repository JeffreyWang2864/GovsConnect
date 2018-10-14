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
        
        if AppDataManager.shared.currentPersonID == "ranpe001"{
            //guest
            makeMessageViaAlert(title: "Cannot like as guest", message: "")
            return
        }
        
        if self.likeIcon.isSelected{      //aleady liked
            
            AppIOManager.shared.like(at: AppDataManager.shared.postsData[self.tag]._uid, method: "minus"){ isSucceed in
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
            self.likeAnimation()
        }
    }
    
    func likeAnimation(){
        let bigLikeImageV = UIImageView(frame: CGRect(x: self.left + self.width / 2 - 20, y: self.height / 2 - 20, width: 40, height: 40))
        bigLikeImageV.contentMode = .scaleAspectFill
        bigLikeImageV.image = UIImage.init(named: "system_like.png")!
        self.addSubview(bigLikeImageV)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.2, options: .allowUserInteraction, animations: {
            bigLikeImageV.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            bigLikeImageV.alpha = 1.0
        }) { finished in
            bigLikeImageV.alpha = 0.0
            bigLikeImageV.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            bigLikeImageV.removeFromSuperview()
        }
    }
    
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        NSLog("here")
        NotificationCenter.default.post(Notification(name: PostsDetailViewController.startCommentingNotificationName))
    }
    
}
