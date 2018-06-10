//
//  PostsDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import CoreText

class PostsDetailViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var commentInputBox: UITextField!
    @IBOutlet var commentSendButton: UIButton!
    var correspondTag: Int = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        let rawTitle = AppDataManager.shared.postsData[self.correspondTag].postTitle
        var fixedTitle = rawTitle.prefix(upTo: rawTitle.index(rawTitle.startIndex, offsetBy: min(24, rawTitle.count)))
        if fixedTitle.count == 24{
            fixedTitle += "..."
        }
        self.navigationController!.navigationBar.topItem!.title = "\(fixedTitle)"
        self.authorImage.image = UIImage.init(named: AppDataManager.shared.postsData[self.correspondTag].authorImageName)!
        self.authorName.text = AppDataManager.shared.postsData[self.correspondTag].author
        self.commentInputBox.layer.cornerRadius = 15
        self.commentInputBox.layer.borderWidth = 1
        self.commentInputBox.layer.borderColor = APP_THEME_COLOR.cgColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "PostsDetailBodyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID")
        self.tableView.register(UINib.init(nibName: "PostSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID")
        self.tableView.register(UINib.init(nibName: "PostsDetailReplyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_REPLY_TABLEVIEW_CELL_ID")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(Notification(name: PostsViewController.shouldRefreashCellNotificationName))
    }
    
    @objc func keyboardWillShow(_ sender: Notification){
        
    }
    
    @objc func keyboardWillHide(_ sender: Notification){
        
    }
}

extension PostsDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDataManager.shared.postReplies[self.correspondTag].count * 2 + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID", for: indexPath) as! PostsDetailBodyTableViewCell
            let data = AppDataManager.shared.postsData[self.correspondTag]
            cell.tag = self.correspondTag
            cell.likeIcon.isSelected = data.isLikedByCurrentUser
            cell.commentIcon.isSelected = data.isCommentedByCurrentUser
            cell.viewIcon.isSelected = data.isViewedByCurrentUser
            cell.likeCount.text = "\(data.likeCount)"
            cell.commentCount.text = "\(data.commentCount)"
            cell.viewCount.text = "\(data.viewCount)"
            cell.postTitle.text = data.postTitle
            cell.postBody.text = data.postContent
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yyyy, HH:mm a"
            cell.postDate.text = dateFormatter.string(from: data.postDate as Date)
            return cell
        }
        if indexPath.item % 2 == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID", for: indexPath) as! PostSeparatorTableViewCell
            return cell
        }
        let realIndexPathItem = indexPath.item - (indexPath.item / 2) - 1
        let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_DETAIL_REPLY_TABLEVIEW_CELL_ID", for: indexPath) as! PostsDetailReplyTableViewCell
        cell.correspondTag = (self.correspondTag, realIndexPathItem)
        let data = AppDataManager.shared.postReplies[self.correspondTag][realIndexPathItem]
        cell.likeIcon.isSelected = data.isLikedByCurrentUser
        cell.likeCount.text = "\(data.likeCount)"
        if data.receiver != nil{
            cell.replyHeading.text = "\(data.sender) replies to \(data.receiver!)'s post"
        }else{
            cell.replyHeading.text = "\(data.sender) replies"
        }
        cell.replyBody.text = data.body
        cell.replierImage.image = UIImage.init(named: data.authorImageName)!
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 2 == 1{
            return 5
        }
        return -1
    }
}
