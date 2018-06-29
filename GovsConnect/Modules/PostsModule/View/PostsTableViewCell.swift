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
    @IBOutlet var imageStackView: UIStackView!

    var viewBlock:PostsTableViewCellViewBlock?
    var commentBlock:PostsTableViewCellCommentBlock?
    var data:PostsDataContainer!{
        didSet{
            self.authorImage.image = UIImage.init(named: data.author.profilePictureName)
            self.authorNameDate.text = data.author.name + " · " + prettyTimeSince(data.postDate.timeIntervalSinceNow)
            self.postTitle.text = data.postTitle
            self.postDescription.text = "\(data.postContent.prefix(upTo: data.postContent.index(data.postContent.startIndex, offsetBy: min(100, data.postContent.count))))"
            self.likeIcon.isSelected = data.isLikedByCurrentUser
            self.commentIcon.isSelected = data.isCommentedByCurrentUser
            self.viewIcon.isSelected = data.isViewedByCurrentUser
            self.likeLabel.text = "\(data.likeCount)"
            self.commentLabel.text = "\(data.commentCount)"
            self.viewLabel.text = "\(data.viewCount)"
            let heightConstraint = self.imageStackView.constraints[0]
            self.imageStackView.arrangedSubviews.map{
                $0.removeFromSuperview()
            }
            if data.postImagesName.count == 0{
                heightConstraint.constant = 1
            }else{
                heightConstraint.constant = 120
                self.displayPreviewImages(imageNames: Array<String>(data.postImagesName.prefix(upTo: min(3, data.postImagesName.count))))
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_view.png"), for: .normal)
        self.viewIcon.setImage(#imageLiteral(resourceName: "system_viewed.png"), for: .selected)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_comment.png"), for: .normal)
        self.commentIcon.setImage(#imageLiteral(resourceName: "system_commented.png"), for: .selected)
    }
    
    func displayPreviewImages(imageNames: Array<String>){
        assert(imageNames.count > 0 && imageNames.count < 4)
        self.imageStackView.spacing = 2
        self.imageStackView.distribution = .fillEqually
        var index = 0
        for imageName in imageNames{
            let v = UIImageView()
            v.tag = index
            index += 1
            v.image = UIImage.init(named: imageName)
            v.isUserInteractionEnabled = true
            let tapGestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnImage(_:)))
            v.addGestureRecognizer(tapGestureRecongnizer)
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

    //点击查看
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        if((self.viewBlock) != nil){
            self.viewBlock!()
        }
    }
    
    //点击喜欢
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
    
    //点击评论
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        if(self.commentBlock != nil){
            self.commentBlock?()
        }
    }
}
