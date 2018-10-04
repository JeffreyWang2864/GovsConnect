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
            self.userImageView.clipsToBounds = true
            self.userImageView.layer.cornerRadius = self.userImageView.width / 2
            self.userTitleLabel.text = data.name
            self.navigationItem.title = data.name
            self.userDetailLabel.text = UserDetailViewController.getDescriptionText(data: data)
            self.profession = data.profession
            self.tableView.register(UINib(nibName: "UserDetailTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "USER_DETAIL_TABLEVIEW_CELL_ID")
            self.tableView.register(UINib(nibName: "CourseDescriptionTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "COURSE_DESCRIPTION_TABLEVIEW_CELL_ID")
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BUTTON_TABLEVIEW_CELL_ID")
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
        if PHONE_TYPE == .iphone5{
            self.backgroundView.constraints[0].constant = 150
            self.backgroundView.height = 150
            self.view.constraints[4].constant = 95
            self.userTitleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let data = AppDataManager.shared.users[uid]!
        
        if data.profession == .club || data.profession == .course{
            self.userImageView.image = UIImage.init(named: data.profilePictureName)!
        }else{
            let imgData = AppDataManager.shared.profileImageData[data.uid]!
            self.userImageView.image = UIImage.init(data: imgData)!
        }
        self.setBlurViewForBackgroundView(data)
    }
    
    private func setBlurViewForBackgroundView(_ dataObj: UserDataContainer) {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        let imageView = UIImageView()
        if AppDataManager.shared.profileImageData[dataObj.uid] == nil{
            imageView.image = UIImage(named: dataObj.profilePictureName)
        }else{
            let imgData = AppDataManager.shared.profileImageData[dataObj.uid]
            imageView.image = UIImage.init(data: imgData!)!
        }
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
            if self.profession == .course{
                return self.allowedInformation.count
            }
            return self.allowedInformation.count + 1
        }
        self.information = AppDataManager.shared.users[self.uid]!.information
        for i in stride(from: 0, to: self.information.count, by: 1){
            if self.information[i].visible{
                self.allowedInformation.append(i)
            }
        }
        //count + 1 because:
        //    course needs an extra cell to display the course information.
        //    students, faculty, and club need an extra cell to display a button.
        if self.profession == .course{
            return self.allowedInformation.count
        }
        return self.allowedInformation.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.profession == .course && indexPath.section == 0{
            return 200
        }else if self.profession != .course && indexPath.section == self.allowedInformation.count{
            return 40
        }
        return 50.5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.profession == .course && indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "COURSE_DESCRIPTION_TABLEVIEW_CELL_ID", for: indexPath) as! CourseDescriptionTableViewCell
            cell.uid = self.uid
            return cell
        }else if self.profession != .course && indexPath.section == self.allowedInformation.count{
            //last cell for student, falcuty and club
            let cell = tableView.dequeueReusableCell(withIdentifier: "BUTTON_TABLEVIEW_CELL_ID", for: indexPath)
            cell.textLabel!.text = "see \(self.navigationItem.title!)'s all posts"
            cell.textLabel!.textColor = APP_THEME_COLOR
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
        if self.profession != .course && indexPath.section == self.allowedInformation.count{
            //clicked on display one's information button
            let vc = ManagePostsViewController()
            vc.uid = self.uid
            vc.view.frame = self.view.bounds
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
