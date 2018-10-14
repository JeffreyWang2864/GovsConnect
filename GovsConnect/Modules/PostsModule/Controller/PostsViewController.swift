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
    static let shouldRealRefreashCellNotificationName = Notification.Name("shouldRealRefreashCellNotificationName")
    @IBOutlet var mainTableView: UITableView!
    var loginViewController: GCLoginRequireViewController?
    var refreashControl = UIRefreshControl()
    var longPressGestureRecongnizer = UILongPressGestureRecognizer()
    var newPostButton = UIBarButtonItem()
    var loadDataLock = true
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReloadCell(_:)), name: PostsViewController.shouldRefreashCellNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldRefreashCell(_:)), name: PostsViewController.shouldRealRefreashCellNotificationName, object: nil)
        self.mainTableView.register(UINib.init(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_CELL_ID")
        self.mainTableView.register(UINib.init(nibName: "BottomActionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BOTTOM_ACTION_TABLEVIEW_CELL_ID")
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
        self.newPostButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "system_new_post"), style: .plain, target: self, action: #selector(newPostButtonDidClick))
        self.navigationController?.navigationBar.topItem?.setRightBarButton(self.newPostButton, animated: false)
        self.newPostButton.isEnabled = false
        UIApplication.shared.statusBarStyle = .lightContent
        self.loginViewController = GCLoginRequireViewController.init(nibName: "GCLoginRequireViewController", bundle: Bundle.main)
        self.loginViewController!.view.frame = self.view.bounds
        if !AppIOManager.shared.isLogedIn{
            self.view.addSubview(self.loginViewController!.view)
            return
        }
        self.newPostButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.becomeFirstResponder()
    }
    
    @objc func newPostButtonDidClick(){
        if AppDataManager.shared.currentPersonID == "ranpe001"{
            //guest
            makeMessageViaAlert(title: "Cannot post as guest", message: "")
            return
        }
        let postVc = NewPostViewController(nibName: "NewPostViewController", bundle: nil)
        if AppDataManager.shared.currentUserConnections.count > 0{
            //user have connected to some organiation
            let alertOptionHandler = { (index: Int) in
                { (action: UIAlertAction!) -> Void in
                    let uid = AppDataManager.shared.currentUserConnections[index]
                    postVc.sender_uid = uid
                    self.navigationController!.present(postVc, animated: true, completion: {
                        UIApplication.shared.statusBarStyle = .default
                    })
                }
            }
            let optionsAlert = UIAlertController(title: "Post as", message: nil, preferredStyle: .actionSheet)
            for i in stride(from: 0, to: AppDataManager.shared.currentUserConnections.count, by: 1){
                let cur_org_id = AppDataManager.shared.currentUserConnections[i]
                let action = UIAlertAction(title: AppDataManager.shared.users[cur_org_id]!.name, style: .default, handler: alertOptionHandler(i))
                optionsAlert.addAction(action)
            }
            let curUsername = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.name
            optionsAlert.addAction(UIAlertAction(title: curUsername, style: .default, handler: { (alert) in
                postVc.sender_uid = AppDataManager.shared.currentPersonID
                self.navigationController!.present(postVc, animated: true, completion: {
                    UIApplication.shared.statusBarStyle = .default
                })
            }))
            optionsAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            self.navigationController!.present(optionsAlert, animated: true) {
                //code
            }
            return
        }
        postVc.sender_uid = AppDataManager.shared.currentPersonID
        self.navigationController!.present(postVc, animated: true, completion: {
            UIApplication.shared.statusBarStyle = .default
        })
    }
    
    @objc func refreachNewData(_ sender: UIRefreshControl){
        NSLog("update data")
        self.refreashControl.attributedTitle = NSAttributedString(string: AppIOManager.shared.connectionStatus == .none ? "offline mode, cannot refreash" : "refreashing", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont.init(name: "Helvetica Neue", size: 11)!])
        if AppIOManager.shared.connectionStatus != .none{
            AppDataManager.shared.loadPostDataFromServerAndUpdateLocalData()
            AppIOManager.shared.updateProfileImage()
        }
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
    
    @objc func loginAction(_ sender: Notification){
        if AppIOManager.shared.isLogedIn{
            if self.loginViewController!.loginView != nil{
                self.loginViewController!.loginView!.dismiss(animated: false) {
                   //code
                }
            }
            if self.loginViewController!.isThatYouView != nil{
                self.loginViewController!.isThatYouView!.dismiss(animated: false) {
                    //code
                }
            }
            self.refreachNewData(self.refreashControl)
            self.newPostButton.isEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loginViewController!.view.removeFromSuperview()
            }
            return
        }
        //log out
        self.view.addSubview(self.loginViewController!.view)
        self.loginViewController!.view.frame = self.view.bounds
        self.newPostButton.isEnabled = false
    }
    
    @objc func shouldReloadCell(_ sender: Notification){
        self.mainTableView.reloadData()
    }
    
    @objc func shouldRefreashCell(_ sender: Notification){
        self.refreachNewData(self.refreashControl)
    }
    
    func updatePost(curIndex: IndexPath){
        guard self.loadDataLock else{
            return
        }
        self.loadDataLock = false
        let alert = UIAlertController(title: nil, message: "Fetching new posts...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        self.present(alert, animated: true, completion: nil)
        let post_id = AppDataManager.shared.postsData[curIndex.section]._uid
        AppIOManager.shared.loadNextPostData(from: post_id, {
            //completion handler
            self.mainTableView.reloadData()
            self.mainTableView.scrollToRow(at: curIndex, at: .top, animated: false)
            alert.dismiss(animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.loadDataLock = true
                }
            })
        }) { (errStr) in
            //error handler
            alert.dismiss(animated: true, completion: {
                makeMessageViaAlert(title: "Error when loading post data", message: errStr)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    self.loadDataLock = true
                }
            })
        }
    }
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
         return AppDataManager.shared.postsData.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return 1
    }
    
    func tableView (_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == AppDataManager.shared.postsData.count{
            //bottom button
            let cell = tableView.dequeueReusableCell(withIdentifier: "BOTTOM_ACTION_TABLEVIEW_CELL_ID", for: indexPath) as! BottomActionTableViewCell
            cell.buttonDidClickBlock = self.updatePost
            cell.indexPath = indexPath
            cell.setButtonActivity()
            return cell
        }
        //let realIndexPathItem = indexPath.section
        let data = AppDataManager.shared.postsData[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_CELL_ID", for: indexPath) as! PostsTableViewCell
        cell.data = data
        cell.tag = indexPath.section
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
        cell.authorBlock = {
            let vc = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
            vc.view.frame = self.view.bounds
            vc.uid = AppDataManager.shared.postsData[indexPath.section].author.uid
            self.navigationController!.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == AppDataManager.shared.postsData.count{
            //bottom button
            return 70
        }
        if AppDataManager.shared.postsData[indexPath.section].postImagesName.count > 0{
            return 272.5
        }
        return 139.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 7;
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == AppDataManager.shared.postsData.count{
            //bottom button
            self.mainTableView.deselectRow(at: indexPath, animated: true)
            return
        }
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
        guard selectedRowSenderUID == AppDataManager.shared.currentPersonID || AppDataManager.shared.currentUserConnections.contains(selectedRowSenderUID) else{
            return
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete my post", style: .destructive, handler: { (action) in
            
            let post_id = AppDataManager.shared.postsData[realIndexPathItem]._uid
            AppIOManager.shared.del_post(post_id: post_id, { (isSucceed) in
                self.refreachNewData(self.refreashControl)
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
