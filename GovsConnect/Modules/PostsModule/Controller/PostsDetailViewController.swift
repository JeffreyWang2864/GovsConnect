//
//  PostsDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import CoreText

typealias PostsDetailCompleteBlock = () -> ()

class PostsDetailViewController: GCBaseViewController {
    static let startCommentingNotificationName = Notification.Name("startCommentingNotificationName")
    @IBOutlet var tableView: UITableView!
    @IBOutlet var authorImage: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var commentInputBox: UITextView!
    @IBOutlet var commentingView: UIView!
    @IBOutlet var authorView: UIView!
    var postsDetailCompleteBlock: PostsDetailCompleteBlock?
    var isComment:Bool = false  //是否是评论
    var correspondTag: Int = -1
    var previousOriginY: CGFloat = -1
    var previousLine: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        NotificationCenter.default.addObserver(self, selector: #selector(self.startCommenting(_:)), name: PostsDetailViewController.startCommentingNotificationName, object: nil)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationItem.title = "Post detail"
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "PostsDetailBodyTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID")
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
        let avtgr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnProfile(_:)))
        self.authorView.addGestureRecognizer(avtgr)
        
        AppIOManager.shared.loadReplyData(local_post_id: self.correspondTag){ isSucceed in
            if !AppDataManager.shared.postsData[self.correspondTag].isViewedByCurrentUser{
                let uid = AppDataManager.shared.postsData[self.correspondTag]._uid
                AppIOManager.shared.view(at: uid)
                AppDataManager.shared.postsData[self.correspondTag].isViewedByCurrentUser = true
                AppDataManager.shared.postsData[self.correspondTag].viewCount += 1
            }
            let dataIndex = AppDataManager.shared.postsData[self.correspondTag].author.uid
            let imgData = AppDataManager.shared.profileImageData[dataIndex]!
            self.authorImage.image = UIImage.init(data: imgData)!
            self.authorImage.clipsToBounds = true
            self.authorImage.layer.cornerRadius = self.authorImage.width / 2
            self.authorName.text = AppDataManager.shared.postsData[self.correspondTag].author.name
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(Notification(name: PostsViewController.shouldRefreashCellNotificationName))
        if self.postsDetailCompleteBlock != nil{
            self.postsDetailCompleteBlock!()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(self.isComment){
            self.isComment = false
            self.commentInputBox.becomeFirstResponder()
        }else{
            self.view.endEditing(true)
        }
    }
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func startCommenting(_ sender: Notification){
        let replyTo: String? = sender.userInfo?["replyTo"] as? String
        if replyTo != nil{
            if replyTo! == AppDataManager.shared.currentPersonID{
                let alertController = UIAlertController(title: "You cannot reply to your own post.", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "ok", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                return
            }
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
        
        let sender_uid = AppDataManager.shared.currentPersonID
        let receiver_uid = self.commentInputBox.restorationIdentifier ?? ""
        self.commentInputBox.restorationIdentifier = nil
        let postData: Dictionary<String, String> = ["sender_uid": sender_uid, "receiver_uid": receiver_uid, "body": replyText!]
        AppIOManager.shared.addReply(at: self.correspondTag, postData: postData){ isSucceed in
            self.tableView.reloadData()
            let lastIndex = IndexPath.init(row: 0, section: self.tableView.numberOfSections - 1)
            self.tableView.scrollToRow(at: lastIndex, at: .bottom, animated: false)
        }
    }
    
    @objc func didClickOnProfile(_ sender: UITapGestureRecognizer){
        let vc = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
        vc.view.frame = self.view.bounds
        vc.uid = AppDataManager.shared.postsData[self.correspondTag].author.uid
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension PostsDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return AppDataManager.shared.postsData[self.correspondTag].replies.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_DETAIL_BODY_TABLEVIEW_CELL_ID", for: indexPath) as! PostsDetailBodyTableViewCell
            let data = AppDataManager.shared.postsData[self.correspondTag]
            cell.tag = self.correspondTag
            cell.likeIcon.isSelected = data.isLikedByCurrentUser
            cell.commentIcon.isSelected = data.isCommentedByCurrentUser
            //cell.viewIcon.isSelected = data.isViewedByCurrentUser
            cell.likeCount.text = "\(data.likeCount)"
            cell.commentCount.text = "\(data.commentCount)"
            //cell.viewCount.text = "\(data.viewCount)"
            cell.postTitle.text = data.postTitle
            cell.postTitle.constraints[0].constant = suitableHeight(for: cell.postTitle, fixedWidth: cell.postTitle.width)
            cell.postBody.text = data.postContent
            cell.postBody.sizeToFit()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/d/yyyy, h:m a"
            cell.postDate.text = dateFormatter.string(from: data.postDate as Date)
            if data.postImagesName.count > 0 && cell.imageStackView.arrangedSubviews.count == 0 {
                cell.addImagesAtEnd(data.postImagesName)
            }
            return cell
        }else{
            let realIndexPathItem = indexPath.section - 1
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
            cell.replyBody.sizeToFit()
            let imgData = AppDataManager.shared.profileImageData[data.sender.uid]!
            cell.replierImageButton.setImage(UIImage.init(data: imgData)!, for: .normal)
            cell.replierImageButton.setImage(UIImage.init(data: imgData)!, for: .selected)
            cell.replierImageButton.clipsToBounds = true
            cell.replierImageButton.layer.cornerRadius = cell.replierImageButton.width / 2
            cell.authorBlock = {
                let vc = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
                vc.view.frame = self.view.bounds
                vc.uid = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem].sender.uid
                self.navigationController!.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let data = AppDataManager.shared.postsData[self.correspondTag]
            let tv = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 12, height: 50))
            tv.text = data.postTitle
            tv.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            let bv = UITextView(frame: CGRect(x: 0, y: 0, width: screenWidth - 12 - 40, height: 200))
            bv.text = data.postContent
            bv.font = UIFont.systemFont(ofSize: 16)
            return 59 + suitableHeight(for: tv, fixedWidth: tv.width) + suitableHeight(for: bv, fixedWidth: bv.width) + CGFloat(data.postImagesName.count * 200)
        }
        let realIndexPathItem = indexPath.section - 1
        let data = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem]
        let bv = UITextView(frame: CGRect(x: 0, y: 0, width: screenWidth - 50 - 8 - 5, height: 50))
        bv.text = data.body
        bv.font = UIFont.systemFont(ofSize: 14)
        return 40.5 + suitableHeight(for: bv, fixedWidth: bv.width)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
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
        guard indexPath?.section != 0 else{
            return
        }
        let realIndexPathItem = indexPath!.section - 1
        let selectedRowSenderUID = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem].sender.uid
        guard selectedRowSenderUID == AppDataManager.shared.currentPersonID else{
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete my comment", style: .destructive, handler: { (action) in
            let reply_id = AppDataManager.shared.postsData[self.correspondTag].replies[realIndexPathItem]._uid
            AppIOManager.shared.delReply(at: self.correspondTag, reply_id: reply_id, { (isSucceed) in
                self.tableView.reloadData()
            })
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
