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
    var arrowImageView = UIImageView(image: UIImage(named: "system_drop_down_arrow.png")!)
    var menuView: DropdownMenu!
    var menuIndex = 0
    var fixedLunchData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
    var fixedDinnerData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReloadNotification(_:)), name: DiningHallMenuViewController.shouldReloadNotificationName, object: nil)
        self.setupTitleView()
        self.fixDataFromDataManager()
        self.segmentControl.tintColor = APP_THEME_COLOR
        self.segmentControl.addTarget(self, action: #selector(self.segmentControlDidChange(_:)), for: .valueChanged)
        
        self.collectionView.register(UINib.init(nibName: "MenuSpecialityCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MENU_SPECIALITY_COLLECTIONVIEW_CELL_ID")
        self.collectionView.register(UINib.init(nibName: "MenuEverydayCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MENU_EVERYDAY_COLLECTIONVIEW_CELL_ID")
        self.collectionView.register(GCSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "GC_SECTION_HEADER_ID")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        //tutorial
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            let predicate = NSPredicate(format: "key == %@", "dining hall menu tutorial")
            let res = AppPersistenceManager.shared.filterObject(of: .setting, with: predicate) as! Array<Setting>
            if res.count == 0{
                //dining hall menu tutorial not created yet
                self.displayDidSeeWidget()
                AppPersistenceManager.shared.saveObject(to: .setting, with: ["dining hall menu tutorial", "true"])
            }else if res[0].value! == "false"{
                //dining hall menu tutorial created, but didn't see
                self.displayDidSeeWidget()
                AppPersistenceManager.shared.updateObject(of: .setting, with: predicate, newVal: "true", forKey: "value")
            }
        }
    }
    
    func fixDataFromDataManager(){
        self.fixedLunchData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
        self.fixedDinnerData = [Array<DiscoverFoodDataContainer>(), Array<DiscoverFoodDataContainer>()]
        let todayFoods = AppDataManager.shared.discoverMenuData[self.menuIndex]
        
    }
    
    private func displayDidSeeWidget(){
        let askWidgetAlertController = UIAlertController(title: "Tutorial", message: "You can double tap to like a food", preferredStyle: .alert)
        let gif = UIImage.init(gifName: "govs-connect-menu-tutorial.gif")
        let gifView = UIImageView.init(gifImage: gif, loopCount: -1)
        gifView.frame = CGRect(x: 30, y: 63, width: 220, height: 140)
        askWidgetAlertController.view.addSubview(gifView)
        let height = NSLayoutConstraint(item: askWidgetAlertController.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        let width = NSLayoutConstraint(item: askWidgetAlertController.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 280)
        askWidgetAlertController.view.addConstraint(height)
        askWidgetAlertController.view.addConstraint(width)
        askWidgetAlertController.addAction(UIAlertAction(title: "Got it! Thanks.", style: .cancel, handler: { (alert) in
            //completion handler
        }))
        self.navigationController!.present(askWidgetAlertController, animated: true, completion: {
            //completion handler
        })
    }
    
    private func setupTitleView(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "system_reload"), style: .plain, target: self, action: #selector(self.didClickOnReload))
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "Wednesday 88/88"
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
        for title in AppDataManager.shared.discoverMenuTitle{
            let menuItem = DropdownItem(title: title)
            menuItems.append(menuItem)
        }
        let todayCalendar = Calendar.current
        let currentHour = todayCalendar.component(.hour, from: Date.init(timeIntervalSinceNow: 0))
        let currentWeekDay = todayCalendar.component(.weekday, from: Date.init(timeIntervalSinceNow: 0))
        let todayWeekDayPointer = currentWeekDay - 1
        self.titleLabel.text = AppDataManager.shared.discoverMenuTitle[todayWeekDayPointer]
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
    
    @objc func didClickOnReload(){
        AppIOManager.shared.loadFoodDataThisWeek({ (isSucceed) in
            self.fixDataFromDataManager()
            self.collectionView.reloadData()
        }) { (errStr) in
            makeMessageViaAlert(title: "failed to fetch food data", message: errStr)
        }
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
}

extension DiningHallMenuViewController: DropdownMenuDelegate{
    func dropdownMenu(_ dropdownMenu: DropdownMenu, didSelectRowAt indexPath: IndexPath) {
        self.titleLabel.text = AppDataManager.shared.discoverMenuTitle[indexPath.item]
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
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.segmentControl.selectedSegmentIndex == 0{
            //lunch
            return self.fixedLunchData[section].count
        }
        //dinner
        return self.fixedDinnerData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            //speciality
            return CGSize(width: (self.collectionView.width - 20) / 2, height: 90)
        }
        //everyday
        return CGSize(width: self.collectionView.width, height: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data: DiscoverFoodDataContainer!
        if self.segmentControl.selectedSegmentIndex == 0{
            //lunch
            data = self.fixedLunchData[indexPath.section][indexPath.item]
        }else{
            //dinner
            data = self.fixedDinnerData[indexPath.section][indexPath.item]
        }
        if indexPath.section == 0{
            //specialty
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MENU_SPECIALITY_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MenuSpecialityCollectionViewCell
            cell.data = data
            return cell
        }
        //everyday
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MENU_EVERYDAY_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MenuEverydayCollectionViewCell
        cell.data = data
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0{
            return CGSize(width: self.collectionView.width, height: 50)
        }
        return CGSize(width: self.collectionView.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{
            return 10
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GC_SECTION_HEADER_ID", for: indexPath) as! GCSectionHeader
            headerView.sectionHeaderlabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            headerView.sectionHeaderlabel.textAlignment = .left
            headerView.sectionHeaderlabel.frame = CGRect(x: 0, y: headerView.height - 50, width: headerView.width, height: 50)
            if indexPath.section == 0{
                headerView.sectionHeaderlabel.text = "Today's Special"
            }else{
                headerView.sectionHeaderlabel.text = "Everydays"
            }
            return headerView
        }
        
        return UICollectionReusableView()
    }
}



class GCSectionHeader: UICollectionReusableView {
    var sectionHeaderlabel: UILabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(sectionHeaderlabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
