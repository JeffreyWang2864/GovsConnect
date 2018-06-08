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
    var isLiked: Bool{
        set{
            self.likeIcon.isSelected = newValue ? true : false
        }
        get{
            return self.likeIcon.isSelected ? true : false
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_like.png"), for: .normal)
        self.likeIcon.setImage(#imageLiteral(resourceName: "system_liked.png"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func viewButtonDidClick(_ sender: UIButton){
        NSLog("click on view")
    }
    
    @IBAction func likeButtonDidClick(_ sender: UIButton){
        if self.isLiked{      //aleady liked
            self.isLiked = false
            NSLog("unliked")
            return
        }
        self.isLiked = true
        NSLog("click on like")
    }
    
    @IBAction func commentButtonDidClick(_ sender: UIButton){
        NSLog("click on comment")
    }
    
}
