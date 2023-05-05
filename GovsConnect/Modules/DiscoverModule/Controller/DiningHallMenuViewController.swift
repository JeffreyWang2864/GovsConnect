//
//  DiningHallMenuViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/3/8.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import TBDropdownMenu

class DiningHallMenuViewController: UIViewController {
    static public let shouldReloadNotificationName = Notification.Name("DiningHallMenuViewController.shouldReloadNotificationName")
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentControl: UISegmentedControl!
    var titleLabel = UILabel()
    let allTitleLabel = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var arrowImageView = UIImageView(image: UIImage(named: "system_drop_down_arrow.png")!)
    var menuView: DropdownMenu!
    var menuIndex = 0
    var displayMenuData = [[(String, String)](),
                           [(String, String)](),
                           [(String, String)]()]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReloadNotification(_:)), name: DiningHallMenuViewController.shouldReloadNotificationName, object: nil)
        self.setupTitleView()
        self.fixDataFromDataManager()
        self.segmentControl.addTarget(self, action: #selector(self.segmentControlDidChange(_:)), for: .valueChanged)
        self.collectionView.register(UINib.init(nibName: "MenuSectionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: MenuSectionCollectionViewCell.ID)
        self.collectionView.register(UINib.init(nibName: "MenuEmptyCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: MenuEmptyCollectionViewCell.ID)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DEFAULT_CELL_ID")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func fixDataFromDataManager(){
        var displayMenuDataDict = [Dictionary<String, String>(),
                                   Dictionary<String, String>(),
                                   Dictionary<String, String>()]
        self.displayMenuData = [[(String, String)](),
                               [(String, String)](),
                               [(String, String)]()]
        for item in AppDataManager.shared.discoverMenuData[self.menuIndex]{
            if let _ = displayMenuDataDict[item.menu][item.section]{
                displayMenuDataDict[item.menu][item.section]! += "\n\(item.title)"
            }else{
                displayMenuDataDict[item.menu][item.section] = item.title
            }
        }
        
        for i in 0..<displayMenuDataDict.count{
            for (sectionName, detail) in displayMenuDataDict[i]{
                self.displayMenuData[i].append((sectionName, detail))
            }
            
        }
    }
    
    private func setupTitleView(){
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "Wednesday"
        self.titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.titleLabel.textColor = UIColor.white
        let idealWidth = self.titleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        self.titleLabel.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: idealWidth, height: 40))
        let fatherTitleView = UIView(frame: CGRect(x: 0, y: 0, width: self.titleLabel.frame.size.width + 35, height: self.titleLabel.frame.size.height))
        self.arrowImageView.frame = CGRect(x: self.titleLabel.frame.size.width + 5, y: 0, width: 30, height: self.titleLabel.frame.size.height)
        self.arrowImageView.contentMode = .scaleAspectFit
        fatherTitleView.addSubview(self.titleLabel)
        fatherTitleView.addSubview(self.arrowImageView)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnTitle(_:)))
        fatherTitleView.isUserInteractionEnabled = true
        fatherTitleView.addGestureRecognizer(recognizer)
        self.navigationItem.titleView = fatherTitleView
        var menuItems = Array<DropdownItem>()
        for title in self.allTitleLabel{
            let menuItem = DropdownItem(title: title)
            menuItems.append(menuItem)
        }
        let todayCalendar = Calendar.current
        let currentHour = todayCalendar.component(.hour, from: Date.init(timeIntervalSinceNow: 0))
        let currentWeekDay = todayCalendar.component(.weekday, from: Date.init(timeIntervalSinceNow: 0))
        let todayWeekDayPointer = currentWeekDay - 1
        self.titleLabel.text = self.allTitleLabel[todayWeekDayPointer]
        self.menuIndex = todayWeekDayPointer
        if currentHour >= 14{
            //
            self.segmentControl.selectedSegmentIndex = 1
        }else{
            //
            self.segmentControl.selectedSegmentIndex = 0
        }
        self.menuView = DropdownMenu(navigationController: self.navigationController!, items: menuItems, selectedRow: todayWeekDayPointer)
        self.menuView.highlightColor = APP_THEME_COLOR
        self.menuView.delegate = self
    }
    
    @objc private func didClickOnTitle(_ sender: UITapGestureRecognizer) {
        self.menuView.showMenu()
        self.arrowImageViewRotatePi()
    }
    
    @objc func shouldReloadNotification(_ notification: Notification){
        self.fixDataFromDataManager()
        self.collectionView.reloadData()
    }
    
    func arrowImageViewRotatePi(in interval: TimeInterval = 0.25){
        UIView.animate(withDuration: interval){
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
        }
    }
    
    @objc func segmentControlDidChange(_ segmentControl: UISegmentedControl){
        self.collectionView.reloadData()
    }
    
    private func heightForMenuDetailCell(text: String, width: CGFloat) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Georgia-Italic", size: 14)
        label.text = text
        label.sizeToFit()
        return label.frame.height * 1.25
    }
}

extension DiningHallMenuViewController: DropdownMenuDelegate{
    func dropdownMenu(_ dropdownMenu: DropdownMenu, didSelectRowAt indexPath: IndexPath) {
        self.titleLabel.text = self.allTitleLabel[indexPath.item]
        self.menuIndex = indexPath.item
        self.arrowImageViewRotatePi()
        //actions
        self.fixDataFromDataManager()
        self.collectionView.reloadData()
    }
    
    func dropdownMenuCancel(_ dropdownMenu: DropdownMenu) {
        self.arrowImageViewRotatePi()
    }
}

extension DiningHallMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.displayMenuData[self.segmentControl.selectedSegmentIndex].count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.displayMenuData[self.segmentControl.selectedSegmentIndex].count == 0{
            //no food data today
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuEmptyCollectionViewCell.ID, for: indexPath)
            return cell
        }
        if indexPath.item == self.displayMenuData[self.segmentControl.selectedSegmentIndex].count{
            //setting footer view
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DEFAULT_CELL_ID", for: indexPath)
            let l = UILabel(frame: CGRect(x: 10, y: 0, width: screenWidth - 40, height: 14))
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            l.text = "source: menu for \(dateFormatter.string(from: Date())) from thegovernorsacademy.org"
            l.textColor = .gray
            l.font = UIFont.systemFont(ofSize: 11)
            cell.addSubview(l)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuSectionCollectionViewCell.ID, for: indexPath) as! MenuSectionCollectionViewCell
        let data = self.displayMenuData[self.segmentControl.selectedSegmentIndex][indexPath.item]
        cell.data = data
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = screenWidth - 30
        if 0 == self.displayMenuData[self.segmentControl.selectedSegmentIndex].count{
            return CGSize(width: width, height: 240.0)
        }
        if indexPath.item == self.displayMenuData[self.segmentControl.selectedSegmentIndex].count{
            return CGSize(width: width, height: 14.0)
        }
        let data = self.displayMenuData[self.segmentControl.selectedSegmentIndex][indexPath.item]
        return CGSize(width: width, height: 110.0 + self.heightForMenuDetailCell(text: data.1, width: width))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth - 20, height: 10.0)
    }
}
