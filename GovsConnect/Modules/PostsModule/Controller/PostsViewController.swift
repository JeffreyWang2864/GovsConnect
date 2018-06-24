//
//  PostsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    static let shouldRefreashCellNotificationName =  Notification.Name("shouldRefreashCellNotificationName")
    @IBOutlet var mainTableView: UITableView!
    var refreashControl = UIRefreshControl()
    var longPressGestureRecongnizer = UILongPressGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldRefreashCell(_:)), name: PostsViewController.shouldRefreashCellNotificationName, object: nil)
        
        self.mainTableView.register(UINib.init(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_CELL_ID")
        self.mainTableView.register(UINib.init(nibName: "PostsTableViewImageCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_IMAGE_CELL_ID")
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.estimatedRowHeight = 0
        self.mainTableView.estimatedSectionHeaderHeight = 0
        self.mainTableView.estimatedSectionFooterHeight = 0

        self.mainTableView.refreshControl = self.refreashControl
        self.addLongPressGestureRecongnizer()
        self.refreashControl.addTarget(self, action: #selector(self.refreachNewData(_:)), for: UIControlEvents.valueChanged)
        self.refreashControl.tintColor = APP_THEME_COLOR
        self.refreashControl.backgroundColor = APP_BACKGROUND_GREY
        self.refreashControl.attributedTitle = NSAttributedString(string: "release to refreash", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.init(name: "Helvetica Neue", size: 11)!])
        self.navigationItem.title = "Posts"
        let newPostButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "system_new_post"), style: .plain, target: self, action: #selector(newPostButtonDidClick))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(newPostButton, animated: false)
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    @objc func newPostButtonDidClick(){
        let postVc = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        self.navigationController?.present(postVc, animated: true, completion: {
            UIApplication.shared.statusBarStyle = .default
        })
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
    
    func addLongPressGestureRecongnizer(){
        self.longPressGestureRecongnizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressOnView(_:)))
        self.longPressGestureRecongnizer.minimumPressDuration = 0.5
        self.longPressGestureRecongnizer.delegate = self
        self.mainTableView.addGestureRecognizer(self.longPressGestureRecongnizer)
    }
    
    func removeLongPressGestureRecongnizer(){
        self.mainTableView.removeGestureRecognizer(self.longPressGestureRecongnizer)
    }
    
    @objc func shouldRefreashCell(_ sender: Notification){
        self.mainTableView.reloadData()
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
         return AppDataManager.shared.postsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realIndexPathItem = indexPath.section
        let data = AppDataManager.shared.postsData[realIndexPathItem]
        
        //带图片的cell
        if data.postImagesName.count > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_IMAGE_CELL_ID", for: indexPath) as! PostsTableViewImageCell
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
            if cell.imageStackView.arrangedSubviews.count == 0{
                cell.addToView(imageNames: data.postImagesName)
            }
            cell.tag = realIndexPathItem
            return cell
        }else{
            //不带图片的cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_CELL_ID", for: indexPath) as! PostsTableViewCell
            cell.viewBlock = {
                let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
                detailViewController.correspondTag = indexPath.section
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            cell.commentBlock = {
                let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
                detailViewController.correspondTag = indexPath.section
                detailViewController.isComment = true
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
            cell.data = data
            cell.tag = realIndexPathItem
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if AppDataManager.shared.postsData[indexPath.section].postImagesName.count > 0{
            return 267.5
        }
        return 134.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realIndexPathItem = indexPath.section
        let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
        detailViewController.correspondTag = realIndexPathItem
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension PostsViewController: UIGestureRecognizerDelegate{
    @objc func longPressOnView(_ sender: UILongPressGestureRecognizer){
        let p = sender.location(in: self.mainTableView)
        let indexPath = self.mainTableView.indexPathForRow(at: p)
        guard indexPath != nil && sender.state == UIGestureRecognizerState.began else{
            return
        }
        let realIndexPathItem = indexPath!.section
        let selectedRowSenderUID = AppDataManager.shared.postsData[realIndexPathItem].author.uid
        guard selectedRowSenderUID == AppDataManager.shared.currentPersonID else{
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete my post", style: .destructive, handler: { (action) in
            AppDataManager.shared.postsData.remove(at: realIndexPathItem)
            self.mainTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
