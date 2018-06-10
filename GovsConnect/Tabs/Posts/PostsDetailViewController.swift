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
    @IBOutlet var commentInputBox: UITextView!
    @IBOutlet var commentingView: UIView!
    var correspondTag: Int = -1
    var previousOriginY: CGFloat = -1
    var previousLine: Int = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: self.view.window)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        let rawTitle = AppDataManager.shared.postsData[self.correspondTag].postTitle
        var fixedTitle = rawTitle.prefix(upTo: rawTitle.index(rawTitle.startIndex, offsetBy: min(24, rawTitle.count)))
        if fixedTitle.count == 24{
            fixedTitle += "..."
        }
        self.navigationController!.navigationBar.topItem!.title = "\(fixedTitle)"
        AppDataManager.shared.postsData[self.correspondTag].viewCount += 1
        AppDataManager.shared.postsData[self.correspondTag].isViewedByCurrentUser = true
        self.authorImage.image = UIImage.init(named: AppDataManager.shared.postsData[self.correspondTag].authorImageName)!
        self.authorName.text = AppDataManager.shared.postsData[self.correspondTag].author
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "PostsDetailBodyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID")
        self.tableView.register(UINib.init(nibName: "PostSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID")
        self.tableView.register(UINib.init(nibName: "PostsDetailReplyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_REPLY_TABLEVIEW_CELL_ID")
        self.commentInputBox.delegate = self
        self.commentInputBox.layer.cornerRadius = 15
        self.commentInputBox.layer.borderWidth = 1.5
        self.commentInputBox.layer.borderColor = APP_THEME_COLOR.cgColor
        self.commentInputBox.text = "Add your comment..."
        self.commentInputBox.textColor = .lightGray
        self.commentInputBox.textContainer.maximumNumberOfLines = 1
        self.commentInputBox.textContainer.lineBreakMode = .byTruncatingTail
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: self.view.window)
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
        guard let keyboardSize = sender.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        let keyboardHeight = keyboardSize.cgRectValue.height // keyboard height as CGFloat
        let posY = self.view.frame.origin.y - (keyboardHeight - 49)
        if self.view.frame.origin.y < 0{
            return
        }
        self.previousOriginY = self.view.frame.origin.y
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(origin: CGPoint.init(x: self.view.frame.origin.x, y: posY), size: self.view.frame.size)
        });
        self.setupKeyboardDismissRecognizer()
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillHide(_ sender: Notification){
        NSLog("keyboardWillHide")
        UIView.animate(withDuration: 0.25, animations: {
            self.view.frame = CGRect(origin: CGPoint.init(x: self.view.frame.origin.x, y: self.previousOriginY), size: self.view.frame.size)
        });
    }
    
    @IBAction func replyButtonDidClick(_ sender: UIButton){
        let replyText = self.commentInputBox.text
        self.commentInputBox.text = ""
        self.changeCommentBoxHeight(toFit: 1)
        self.view.endEditing(true)
        if replyText! == ""{
            return
        }
        AppDataManager.shared.postReplies[self.correspondTag].append(ReplyDataContainer.init("Jeffrey Wang", nil, replyText!, "testing_profile_picture_1.png", 0, false))
        AppDataManager.shared.postsData[self.correspondTag].commentCount += 1
        AppDataManager.shared.postsData[self.correspondTag].isCommentedByCurrentUser = true
        self.tableView.reloadData()
        let lastIndex = IndexPath.init(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension PostsDetailViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let requireLines = numberOfVisibleLines(textView)
        if self.previousLine != requireLines{
            self.changeCommentBoxHeight(toFit: requireLines)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        if (textView.text == "Add your comment..."){
            textView.text = ""
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
        textView.textContainer.maximumNumberOfLines = 10
        self.changeCommentBoxHeight(toFit: numberOfVisibleLines(textView))
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if (textView.text == ""){
            textView.text = "Add your comment..."
            textView.textColor = .lightGray
        }
        textView.resignFirstResponder()
    }
    
    func changeCommentBoxHeight(toFit lines: Int){
        let lineHeight = self.commentInputBox.font!.lineHeight
        let addingHeight = CGFloat(lines - self.previousLine) * lineHeight
        NSLog("\(addingHeight)")
        let c = self.commentingView.constraints[0]
        c.constant += addingHeight
        self.previousLine = lines
    }
}
