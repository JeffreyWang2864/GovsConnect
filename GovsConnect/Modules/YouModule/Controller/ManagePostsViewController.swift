//
//  ManagePostsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/26.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class ManagePostsViewController: UIViewController {
    var tableView: UITableView = UITableView()
    var curUserPostsData: [PostsDataContainer]!
    var curUserPostsIndex: [Int]!
    var longPressGestureRecongnizer = UILongPressGestureRecognizer()
    var uid: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard AppIOManager.shared.connectionStatus != .none else{
            //offline mode
            self.dismiss(animated: true) {
                makeMessageViaAlert(title: "You can't view a person's all post under offline mode", message: "")
            }
            return
        }
        self.setupTableViewData()
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.view.addSubview(self.tableView)
        self.tableView.register(UINib(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_CELL_ID")
        self.tableView.separatorStyle = .none
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.uid! == AppDataManager.shared.currentPersonID || AppDataManager.shared.currentUserConnections.contains(self.uid!){
            self.navigationItem.title = "Manage my posts"
            self.addLongPressGestureRecongnizer()
        }else{
            self.navigationItem.title = "\(AppDataManager.shared.users[self.uid!]!.name)'s all posts"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParentViewController{
            NotificationCenter.default.post(Notification.init(name: PostsViewController.shouldRealRefreashCellNotificationName))
        }
        self.removeLongPressGestureRecongnizer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func setupTableViewData(){
        AppIOManager.shared.loadPostData(by: self.uid!, {
            //success handler
            self.tableView.delegate = self
            self.tableView.dataSource = self
            let ret = AppDataManager.shared.posts(by: self.uid!)
            self.curUserPostsData = ret.datas
            self.curUserPostsIndex = ret.index
            self.tableView.reloadData()
        }) { (errStr) in
            //error handler
            makeMessageViaAlert(title: "Error when loading post data", message: errStr)
        }
    }
    
    func addLongPressGestureRecongnizer(){
        self.longPressGestureRecongnizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressOnView(_:)))
        self.longPressGestureRecongnizer.minimumPressDuration = 0.5
        self.longPressGestureRecongnizer.delegate = self
        self.tableView.addGestureRecognizer(self.longPressGestureRecongnizer)
    }
    
    func removeLongPressGestureRecongnizer(){
        self.tableView.removeGestureRecognizer(self.longPressGestureRecongnizer)
    }
}

extension ManagePostsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.curUserPostsData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "posted at: \(timeStringFormat(self.curUserPostsData[section].postDate as Date, withWeek: true))"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.curUserPostsData[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "POSTS_TABLEVIEW_CELL_ID", for: indexPath) as! PostsTableViewCell
        cell.data = data
        cell.tag = self.curUserPostsIndex[indexPath.section]
        cell.viewBlock = {
            let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
            detailViewController.correspondTag = self.curUserPostsIndex[indexPath.section]
            detailViewController.postsDetailCompleteBlock = {
                self.setupTableViewData()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        cell.commentBlock = {
            let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
            detailViewController.correspondTag = self.curUserPostsIndex[indexPath.section]
            detailViewController.isComment = true
            detailViewController.postsDetailCompleteBlock = {
                self.setupTableViewData()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.curUserPostsData[indexPath.section].postImagesName.count > 0{
            return 267.5
        }
        return 134.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realIndexPathItem = self.curUserPostsIndex[indexPath.section]
        let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
        detailViewController.correspondTag = realIndexPathItem
        detailViewController.postsDetailCompleteBlock = {
            self.setupTableViewData()
            self.tableView.reloadData()
        }
        self.navigationController!.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ManagePostsViewController: UIGestureRecognizerDelegate{
    @objc func longPressOnView(_ sender: UILongPressGestureRecognizer){
        let p = sender.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: p)
        guard indexPath != nil && sender.state == UIGestureRecognizerState.began else{
            return
        }
        let realIndexPathItem = self.curUserPostsIndex[indexPath!.section]
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Delete my post", style: .destructive, handler: { (action) in
            let post_id = AppDataManager.shared.postsData[realIndexPathItem]._uid
            let alert = UIAlertController(title: nil, message: "deleting", preferredStyle: .alert)
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            loadingIndicator.startAnimating();
            alert.view.addSubview(loadingIndicator)
            self.present(alert, animated: true, completion: nil)
            AppIOManager.shared.del_post(post_id: post_id, { (isPassed) in
                //code
                NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    self.setupTableViewData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                        self.tableView.reloadData()
                        alert.dismiss(animated: true, completion: nil)
                    }
                }
            }, { (errStr) in
                alert.dismiss(animated: true){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        makeMessageViaAlert(title: "Error when deleting data", message: errStr)
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
