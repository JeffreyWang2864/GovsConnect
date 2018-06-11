//
//  PostsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    static let shouldRefreashCellNotificationName = Notification.Name("shouldRefreashCellNotificationName")
    @IBOutlet var mainTableView: UITableView!
    var refreashControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldRefreashCell(_:)), name: PostsViewController.shouldRefreashCellNotificationName, object: nil)
        self.mainTableView.register(UINib.init(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_CELL_ID")
        self.mainTableView.register(UINib.init(nibName: "PostSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID")
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.refreshControl = self.refreashControl
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressOnView(_:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delegate = self
        self.mainTableView.addGestureRecognizer(longPressGesture)
        self.refreashControl.addTarget(self, action: #selector(self.refreachNewData(_:)), for: UIControlEvents.valueChanged)
        self.refreashControl.tintColor = APP_THEME_COLOR
        self.refreashControl.backgroundColor = APP_BACKGROUND_GREY
        self.refreashControl.attributedTitle = NSAttributedString(string: "release to refreash", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.init(name: "Helvetica Neue", size: 11)!])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @objc func refreachNewData(_ sender: UIRefreshControl){
        NSLog("update data")
        self.refreashControl.attributedTitle = NSAttributedString(string: "refreashing", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.init(name: "Helvetica Neue", size: 11)!])
        let newData = PostsDataContainer(AppDataManager.shared.users["ranpe001"]!, NSDate.init(timeIntervalSinceNow: 0), "There are \(AppDataManager.shared.postsData.count) posts in total!", LOREM_IPSUM_2, 0, 0, 0, false, false, false)
        AppDataManager.shared.postsData.insert(newData, at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreashControl.attributedTitle = NSAttributedString(string: "release to refreash", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.init(name: "Helvetica Neue", size: 11)!])
            self.mainTableView.reloadData()
            self.refreashControl.endRefreshing()
        }
    }
    
    @objc func shouldRefreashCell(_ sender: Notification){
        self.mainTableView.reloadData()
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppDataManager.shared.postsData.count * 2 - 1
    }
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.item % 2 == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID", for: indexPath) as! PostSeparatorTableViewCell
            return cell
            
        }
        let realIndexPathItem = indexPath.item - Int(indexPath.item / 2)
        let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_CELL_ID", for: indexPath) as! PostsTableViewCell
        let data = AppDataManager.shared.postsData[realIndexPathItem]
        cell.authorImage.image = UIImage.init(named: data.author.profilePictureName)
        cell.authorNameDate.text = data.author.name + " · " + prettyTimeSince(data.postDate.timeIntervalSinceNow)
        cell.postTitle.text = data.postTitle
        cell.postDescription.text = "\(data.postContent.prefix(upTo: data.postContent.index(data.postContent.startIndex, offsetBy: min(100, data.postContent.count))))"
        cell.likeIcon.isSelected = data.isLikedByCurrentUser
        cell.commentIcon.isSelected = data.isCommentedByCurrentUser
        cell.viewIcon.isSelected = data.isViewedByCurrentUser
        cell.likeLabel.text = "\(data.likeCount)"
        cell.commentLabel.text = "\(data.commentCount)"
        cell.viewLabel.text = "\(data.viewCount)"
        cell.tag = realIndexPathItem
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 2 == 1{
            return 7
        }
        return 134.5
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let corresCell = self.mainTableView.cellForRow(at: indexPath)!
        NotificationCenter.default.post(name: BaseViewController.presentPostsDetailNotificationName, object: nil, userInfo: ["indexPath": corresCell.tag])
        corresCell.selectionStyle = .none
    }
}

extension PostsViewController: UIGestureRecognizerDelegate{
    @objc func longPressOnView(_ sender: UILongPressGestureRecognizer){
        let p = sender.location(in: self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: p)
        guard indexPath != nil && sender.state == UIGestureRecognizerState.began else{
            return
        }
        let realIndexPathItem = indexPath!.item / 2
        let selectedRowSenderUID = AppDataManager.shared.postsData[realIndexPathItem].author.uid
        guard selectedRowSenderUID == AppDataManager.shared.currentPersonID else{
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "delete my post", style: .destructive, handler: { (action) in
            AppDataManager.shared.postsData.remove(at: realIndexPathItem)
            self.mainTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
