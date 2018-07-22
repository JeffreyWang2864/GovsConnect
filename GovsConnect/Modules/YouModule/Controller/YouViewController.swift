//
//  YouViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/20.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class YouViewController: UIViewController {
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var postsCountView: UILabel!
    @IBOutlet var repliesCountView: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = APP_BACKGROUND_GREY
        let data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
        self.authorImageView.layer.cornerRadius = self.authorImageView.width / 2
        self.backgroundView.layer.cornerRadius = 15
        self.backgroundView.clipsToBounds = true
        self.authorImageView.image = UIImage.init(named: data.profilePictureName)
        self.authorImageView.contentMode = .scaleAspectFit
        self.authorImageView.clipsToBounds = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "YOU_SETTING_TABLEVIEW_CELL")
        self.authorName.text = data.name
        self.authorName.numberOfLines = 0
        self.postsCountView.text = "\(data.posts.count)"
        self.repliesCountView.text = "-1"
        self.tableView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
}

extension YouViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.9
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YOU_SETTING_TABLEVIEW_CELL", for: indexPath)
        cell.textLabel!.textColor = APP_THEME_COLOR
        switch indexPath.section{
        case 0:
            cell.textLabel!.text = "settings"
        case 1:
            cell.textLabel!.text = "about Govs Connect"
        case 2:
            cell.textLabel!.text = "give us a feedback"
        default:
            fatalError()
        }
        return cell
    }
}
