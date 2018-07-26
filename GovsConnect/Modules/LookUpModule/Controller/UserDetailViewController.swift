//
//  UserDetailViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/16.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController {
    static let studentLabels: Array<(str: String, type: UIDataDetectorTypes)> = [("Email:", .all), ("Website:", .link), ("Phone:", .phoneNumber), ("Address:", .all)]
    static let courseLabels: Array<(str: String, type: UIDataDetectorTypes)> = [("Length:", .all), ("Catagory:", .all), ("Is required:", .all), ("Grade:", .all), ("Credits:", .all), ("Location:", .all), ("Teacher:", .all)]
    static let clubLabels: Array<(str: String, type: UIDataDetectorTypes)> = [("Leader:", .all), ("Location:", .all), ("Activity hour:", .all)]
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userTitleLabel: UILabel!
    @IBOutlet var userDetailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    var uid: String!{
        didSet{
            let data = AppDataManager.shared.users[uid]!
            self.userImageView.image = UIImage(named: data.profilePictureName)
            self.userTitleLabel.text = data.name
            self.navigationItem.title = data.name
            self.userDetailLabel.text = UserDetailViewController.getDescriptionText(data: data)
            self.setBlurViewForBackgroundView(data.profilePictureName)
            self.profession = data.profession
            self.tableView.register(UINib(nibName: "UserDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "USER_DETAIL_TABLEVIEW_CELL_ID")
            self.tableView.register(UINib(nibName: "CourseDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "COURSE_DESCRIPTION_TABLEVIEW_CELL_ID")
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    var profession: UserDataContainer.Profession!
    var information: Array<(str: String, visible: Bool)>!
    var allowedInformation = Array<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.tableView.separatorStyle = .none
    }
    
    private func setBlurViewForBackgroundView(_ imageName: String) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.frame = CGRect(x: self.backgroundView.top, y: self.backgroundView.left, width: screenWidth, height: self.backgroundView.height)
        blurView.frame = CGRect(x: self.backgroundView.top, y: self.backgroundView.left, width: screenWidth, height: self.backgroundView.height)
        imageView.contentMode = .center
        imageView.contentScaleFactor = 0.6
        imageView.clipsToBounds = true
        imageView.alpha = 0.3
        self.backgroundView.addSubview(imageView)
        self.backgroundView.addSubview(blurView)
    }
    
    static func getDescriptionText(data userData: UserDataContainer) -> String{
        switch userData.profession {
        case .student:
            return "\(userData.department.rawValue) from \(userData.description)"
            
        case .facalty:
            return "\(userData.department.rawValue) teacher from \(userData.description)"
        case .course:
            return "\(userData.department.rawValue) department"
        case .club:
            return userData.description
        }
    }
}

extension UserDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.allowedInformation.count == 0 else{
            return self.allowedInformation.count
        }
        self.information = AppDataManager.shared.users[self.uid]!.information
        for i in stride(from: 0, to: self.information.count, by: 1){
            if self.information[i].visible{
                self.allowedInformation.append(i)
            }
        }
        if self.profession == .course{
            return self.allowedInformation.count + 1
        }
        return self.allowedInformation.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.profession == .course && indexPath.section == 0{
            return 200
        }
        return 50.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.profession == .course && indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "COURSE_DESCRIPTION_TABLEVIEW_CELL_ID", for: indexPath) as! CourseDescriptionTableViewCell
            cell.uid = self.uid
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "USER_DETAIL_TABLEVIEW_CELL_ID", for: indexPath) as! UserDetailTableViewCell
        switch self.profession {
        case .student?, .facalty?:
            cell.titleTextView.text = UserDetailViewController.studentLabels[self.allowedInformation[indexPath.section]].str
             cell.detailTextView.dataDetectorTypes = UserDetailViewController.studentLabels[self.allowedInformation[indexPath.section]].type
        case .course?:
            cell.titleTextView.text = UserDetailViewController.courseLabels[self.allowedInformation[indexPath.section]].str
            cell.detailTextView.dataDetectorTypes = UserDetailViewController.courseLabels[self.allowedInformation[indexPath.section]].type

        case .club?:
            cell.titleTextView.text = UserDetailViewController.clubLabels[self.allowedInformation[indexPath.section]].str
            cell.detailTextView.dataDetectorTypes = UserDetailViewController.clubLabels[self.allowedInformation[indexPath.section]].type
        default:
            fatalError()
        }
        cell.titleTextView.sizeToFit()
        cell.detailTextView.sizeToFit()
        cell.detailTextView.text = self.information[self.allowedInformation[indexPath.section]].str
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
