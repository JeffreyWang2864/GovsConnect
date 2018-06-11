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
    static let startCommentingNotificationName = Notification.Name("startCommentingNotificationName")
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.startCommenting(_:)), name: PostsDetailViewController.startCommentingNotificationName, object: nil)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        let rawTitle = AppDataManager.shared.postsData[self.correspondTag].postTitle
        var fixedTitle = rawTitle.prefix(upTo: rawTitle.index(rawTitle.startIndex, offsetBy: min(24, rawTitle.count)))
        if fixedTitle.count == 24{
            fixedTitle += "..."
        }
        self.navigationController!.navigationBar.topItem!.title = "\(fixedTitle)"
        AppDataManager.shared.postsData[self.correspondTag].viewCount += 1
        AppDataManager.shared.postsData[self.correspondTag].isViewedByCurrentUser = true
        self.authorImage.image = UIImage.init(named: AppDataManager.shared.postsData[self.correspondTag].author.profilePictureName)!
        self.authorName.text = AppDataManager.shared.postsData[self.correspondTag].author.name
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "PostsDetailBodyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID")
        self.tableView.register(UINib.init(nibName: "PostSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID")
        self.tableView.register(UINib.init(nibName: "PostsDetailReplyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_REPLY_TABLEVIEW_CELL_ID")
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressOnView(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        self.commentInputBox.delegate = self
        self.commentInputBox.layer.cornerRadius = 15
        self.commentInputBox.layer.borderWidth = 1.5
        self.commentInputBox.layer.borderColor = APP_THEME_COLOR.cgColor
        self.commentInputBox.text = "Add your comment..."
        self.commentInputBox.textColor = .lightGray
        self.commentInputBox.textContainer.maximumNumberOfLines = 1
        self.commentInputBox.textContainer.lineBreakMode = .byTruncatingTail
        self.setupKeyboardDismissRecognizer()
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
    
    @objc func startCommenting(_ sender: Notification){
        let replyTo: String? = sender.userInfo?["replyTo"] as? String
        if replyTo != nil{
            self.commentInputBox.restorationIdentifier = replyTo!
        }
        self.commentInputBox.becomeFirstResponder()
    }
    
    @IBAction func replyButtonDidClick(_ sender: UIButton){
        let replyText = self.commentInputBox.text
        self.commentInputBox.text = ""
        self.changeCommentBoxHeight(toFit: 1)
        self.view.endEditing(true)
        if replyText! == "" || replyText == "Add your comment..."{
            return
        }
        
        if self.commentInputBox.restorationIdentifier != nil{
            AppDataManager.shared.postsData[self.correspondTag].replies.append(ReplyDataContainer.init(AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!, AppDataManager.shared.users[self.commentInputBox.restorationIdentifier!]!, replyText!, 0, false))
            self.commentInputBox.restorationIdentifier = nil
        }else{
            AppDataManager.shared.postsData[self.correspondTag].replies.append(ReplyDataContainer.init(AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!, nil, replyText!, 0, false))
        }
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
        return AppDataManager.shared.postsData[self.correspondTag].replies.count * 2 + 1
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
        let data = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem]
        cell.likeIcon.isSelected = data.isLikedByCurrentUser
        cell.likeCount.text = "\(data.likeCount)"
        if data.receiver != nil{
            cell.replyHeading.text = "\(data.sender.name) replies to \(data.receiver!.name)'s post"
        }else{
            cell.replyHeading.text = "\(data.sender.name) replies"
        }
        cell.replyBody.text = data.body
        cell.replierImage.image = UIImage.init(named: data.sender.profilePictureName)!
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
        let requireLines = min(10, numberOfVisibleLines(textView))
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
        textView.textContainer.maximumNumberOfLines = 0
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

extension PostsDetailViewController: UIGestureRecognizerDelegate{
    @objc func longPressOnView(_ sender: UILongPressGestureRecognizer){
        let p = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        guard indexPath != nil && sender.state == UIGestureRecognizerState.began else{
            return
        }
        guard indexPath?.item != 0 else{
            return
        }
        let realIndexPathItem = indexPath!.item / 2 - 1
        let selectedRowSenderUID = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem].sender.uid
        guard selectedRowSenderUID == AppDataManager.shared.currentPersonID else{
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "delete my comment", style: .destructive, handler: { (action) in
            AppDataManager.shared.postsData[self.correspondTag].replies.remove(at: realIndexPathItem)
            AppDataManager.shared.postsData[self.correspondTag].commentCount -= 1
            if !AppDataManager.shared.postsData[self.correspondTag].replies.contains(where: { (item) -> Bool in
                return item.sender.uid == selectedRowSenderUID ? true : false
            }){
                AppDataManager.shared.postsData[self.correspondTag].isCommentedByCurrentUser = false
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
