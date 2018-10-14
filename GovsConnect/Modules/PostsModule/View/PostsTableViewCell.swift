//
//  PostsTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
typealias PostsTableViewCellViewBlock = () -> ()
typealias PostsTableViewCellCommentBlock = () -> ()
typealias PostsTableViewCellAuthorBlock = () -> ()

class PostsTableViewCell: UITableViewCell {
    @IBOutlet var authorImageButton: UIButton!
    @IBOutlet var authorNameDate: UILabel!
    @IBOutlet var postTitle: UILabel!
    @IBOutlet var postDescription: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    @IBOutlet var likeIcon: UIButton!
    @IBOutlet var commentIcon: UIButton!
    @IBOutlet var imageStackView: UIStackView!
    var viewBlock: PostsTableViewCellViewBlock?
    var commentBlock: PostsTableViewCellCommentBlock?
    var authorBlock: PostsTableViewCellAuthorBlock?
    var data:PostsDataContainer!{
        didSet{
            let imgData = AppDataManager.shared.profileImageData[self.data.author.uid]!
            self.authorImageButton.setImage(UIImage.init(data: imgData)!, for: .normal)
            self.authorImageButton.setImage(UIImage.init(data: imgData)!, for: .selected)
            self.authorImageButton.clipsToBounds = true
            self.authorImageButton.layer.cornerRadius = self.authorImageButton.width / 2
            self.authorNameDate.text = data.author.name + " · " + prettyTimeSince(data.postDate.timeIntervalSinceNow)
            self.postTitle.text = data.postTitle
            self.postDescription.text = "\(data.postContent.prefix(upTo: data.postContent.index(data.postContent.startIndex, offsetBy: min(100, data.postContent.count))))"
            self.likeIcon.isSelected = data.isLikedByCurrentUser
            self.commentIcon.isSelected = data.isCommentedByCurrentUser
            //self.viewIcon.isSelected = data.isViewedByCurrentUser
            self.likeLabel.text = "\(data.likeCount)"
            self.commentLabel.text = "\(data.commentCount)"
            //self.viewLabel.text = "\(data.viewCount)"
            let heightConstraint = self.imageStackView.constraints[0]
            self.imageStackView.arrangedSubviews.map{
                $0.removeFromSuperview()
            }
            if data.postImagesName.count == 0{
                heightConstraint.constant = 1
            }else{
                heightConstraint.constant = 120
                self.displayPreviewImages(imageNames: Array<String>(data.postImagesName))
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_comment.png"), for: .normal)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_commented.png"), for: .selected)
        let dtr = UITapGestureRecognizer(target: self, action: #selector(self.didDoubleTap(_:)))
        dtr.numberOfTapsRequired = 2
        self.addGestureRecognizer(dtr)
    }
    
    func displayPreviewImages(imageNames: Array<String>){
        self.imageStackView.spacing = 2
        self.imageStackView.distribution = .fillEqually
        var index = 0
        for imageName in imageNames{
            let v = UIImageView()
            v.contentMode = .scaleAspectFill
            v.clipsToBounds = true
            v.tag = index
            index += 1
            if index < 3{
                self.imageStackView.addArrangedSubview(v)
            }
            if AppDataManager.shared.imageData[imageName] == nil{
                AppIOManager.shared.loadImage(with: imageName) { (data) in
                    AppDataManager.shared.imageData[imageName] = data
                    v.image = UIImage(data: AppDataManager.shared.imageData[imageName]!)
                    v.isUserInteractionEnabled = true
                    let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnImage(_:)))
                    v.addGestureRecognizer(tapGestureRecongnizer)
                }
            }else{
                v.image = UIImage(data: AppDataManager.shared.imageData[imageName]!)!
                v.isUserInteractionEnabled = true
                let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnImage(_:)))
                v.addGestureRecognizer(tapGestureRecongnizer)
            }
            
        }
    }
    
    @objc func didDoubleTap(_ sender: UIGestureRecognizer){
        self.likeButtonDidClick(self.likeIcon)
    }
    
    @objc func didClickOnImage(_ sender: UITapGestureRecognizer){
        let v = GCImageViewController()
        v.view.frame = self.window!.rootViewController!.view.bounds
        self.window!.rootViewController!.present(v, animated: true, completion: nil)
        let imgD = AppDataManager.shared.postsData[self.tag].postImagesName
            v.setupPaging(imgD, at: sender.view!.tag)
    }

    //点击查看
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        if((self.viewBlock) != nil){
            self.viewBlock!()
        }
    }
    
    //点击喜欢
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        
        if AppDataManager.shared.currentPersonID == "ranpe001"{
            //guest
            makeMessageViaAlert(title: "Cannot like as guest", message: "")
            return
        }
        
        if self.likeIcon.isSelected{      //aleady liked
            
            AppIOManager.shared.like(at: AppDataManager.shared.postsData[self.tag]._uid, method: "minus"){ isSucceed in
                //makeMessageViaAlert(title: "Success", message: "minus one on like")
                self.likeIcon.isSelected = false
                AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = false
                AppDataManager.shared.postsData[self.tag].likeCount -= 1
                self.likeLabel.text = "\(Int(self.likeLabel.text!)! - 1)"
                self.reloadInputViews()
            }
            return
        }
        
        AppIOManager.shared.like(at: AppDataManager.shared.postsData[self.tag]._uid, method: "plus"){ isSucceed in
            self.likeIcon.isSelected = true
            AppDataManager.shared.postsData[self.tag].isLikedByCurrentUser = true
            AppDataManager.shared.postsData[self.tag].likeCount += 1
            self.likeLabel.text = "\(Int(self.likeLabel.text!)! + 1)"
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
    
    //点击评论
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        if(self.commentBlock != nil){
            self.commentBlock?()
        }
    }
    
    @IBAction func didClickOnAuthorImage(_ sender: UIButton){
        self.authorBlock?()
    }
}
