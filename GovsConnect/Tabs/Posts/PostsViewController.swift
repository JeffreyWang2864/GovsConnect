//
//  PostsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {
    @IBOutlet var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainTableView.register(UINib.init(nibName: "PostsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_CELL_ID")
        self.mainTableView.register(UINib.init(nibName: "PostSeparatorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "POSTS_TABLEVIEW_SEPARATOR_ID")
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.authorImage.image = UIImage.init(named: data.authorImageName)
        cell.authorNameDate.text = data.author + " · " + ""
        cell.postTitle.text = data.postTitle
        cell.postDescription.text = "\(data.postContent.prefix(upTo: data.postContent.index(data.postContent.startIndex, offsetBy: min(100, data.postContent.count))))"
        cell.isLiked = data.isLikedByCurrentUser
        cell.isCommented = data.isCommentedByCurrentUser
        cell.isViewed = data.isViewedByCurrentUser
        cell.likeLabel.text = "\(data.likeCount)"
        cell.commentLabel.text = "\(data.commentCount)"
        cell.viewLabel.text = "\(data.viewCount)"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.item % 2 == 1{
            return 7
        }
        return 134.5
    }
}
