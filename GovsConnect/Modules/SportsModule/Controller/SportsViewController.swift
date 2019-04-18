//
//  SportsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/3.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit
import PinterestSegment
import CalendarDateRangePickerViewController

class SportsViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    public static let reloadNotificationName = Notification.Name.init(rawValue: "SportsViewController.reloadNotificationName")
    var panelView = SportsPanelView()
    var dragSignView = UIView()
    var dateSegmentView: PinterestSegment?
    //var quickActionStackView = UIStackView()
    var quickActionStackView = UILabel()
    var browseByDateSelector: UINavigationController?
    var collectionViewCurrentSelection: Int = 0
    var dragGestureRecongnizer: UIPanGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReloadData(_:)), name: SportsViewController.reloadNotificationName, object: nil)
        self.collectionView.register(UINib.init(nibName: "MatchCardCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SPORTS_MATCH_CARD_COLLECTIONVIEW_CELL_ID")
        self.collectionView.register(UINib.init(nibName: "MatchNoDataCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MATCH_NO_DATA_COLLECTIONVIEW_CELL_ID")
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isPagingEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
        
        //panel view setup
        //self.panelView.clipsToBounds = true
        self.panelView = SportsPanelView(frame: CGRect(x: 0, y: -60, width: screenWidth, height: 130))
        self.view.addSubview(self.panelView)
        self.setupPanelView()
    }
    
    @objc func loginAction(_ notification: Notification){
        
    }
    
    private func setupPanelView(){
        self.dragSignView = UIView(frame: CGRect(x: self.panelView.width / 2 - 20, y: 121, width: 40, height: 4))
        self.dragSignView.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.dragSignView.alpha = 0.6
        self.dragSignView.layer.cornerRadius = 2
        self.dragSignView.isUserInteractionEnabled = false
        self.panelView.addSubview(self.dragSignView)
        UIView.animate(withDuration: 1.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.dragSignView.frame = CGRect(x: self.panelView.width / 2 - 20, y: 123, width: 40, height: 4)
        }, completion: nil)
        self.dragGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(self.didDragPanelView(_:)))
        self.panelView.isUserInteractionEnabled = true
        self.panelView.addGestureRecognizer(self.dragGestureRecongnizer!)
        var dataSegmentStyle = PinterestSegmentStyle()
        dataSegmentStyle.indicatorColor = UIColor(white: 0.95, alpha: 1)
        dataSegmentStyle.titleMargin = 15
        dataSegmentStyle.titlePendingHorizontal = 14
        dataSegmentStyle.titlePendingVertical = 14
        dataSegmentStyle.titleFont = UIFont.boldSystemFont(ofSize: 15)
        dataSegmentStyle.selectedTitleColor = UIColor.darkGray
        dataSegmentStyle.normalTitleColor = UIColor.lightGray
        
        //setup title for days
        var todayDate = Date().dayAfter.dayAfter
        var titles = ["yesterday", "today", "tomorrow"]
        let df = DateFormatter()
        df.dateFormat = "M/d/yyyy"
        for _ in (0..<2){
            titles.append(df.string(from: todayDate))
            todayDate = todayDate.dayAfter
        }
        
        self.dateSegmentView = PinterestSegment(frame: CGRect.init(x: 0, y: 70, width: self.panelView.width, height: 45), segmentStyle: dataSegmentStyle, titles: titles)
        self.panelView.addSubview(self.dateSegmentView!)
        self.dateSegmentView!.setSelectIndex(index: 1, animated: false)
        self.dateSegmentView!.valueChange = self.dateSegmentViewDidChange
        
        //quick action stack view
//        self.quickActionStackView.removeFromSuperview()
//        self.quickActionStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: self.panelView.width, height: 65))
//        self.quickActionStackView.backgroundColor = UIColor.clear
//        self.quickActionStackView.distribution = .fillEqually
//        self.quickActionStackView.axis = .horizontal
//        self.quickActionStackView.contentMode = .center
//        self.quickActionStackView.spacing = (self.quickActionStackView.width - (65 * 4)) / 4
//        let labelTexts = ["browse by dates", "browse by catagory", "lastest results", "sport videos"]
//        let imageNames = ["system_sports_select_date.png", "system_sports_browse_by_category.png", "system_sports_see_result.png", "system_sports_video.png"]
//        for i in (0..<4){
//            let v = UIView(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
//            let imgV = UIImageView(frame: CGRect(x: 15, y: 2, width: 32, height: 32))
//            imgV.image = UIImage.init(named: imageNames[i])
//            imgV.contentMode = .scaleAspectFit
//            let l = UILabel(frame: CGRect(x: 0, y: 34, width: 65, height: 27))
//            l.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
//            l.textAlignment = .center
//            l.numberOfLines = 2
//            l.textColor = UIColor.darkGray
//            l.text = labelTexts[i]
//            v.addSubview(imgV)
//            v.addSubview(l)
//            let tgr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnTopAction(_:)))
//            tgr.numberOfTapsRequired = 1
//            v.addGestureRecognizer(tgr)
//            v.tag = i
//            self.quickActionStackView.addArrangedSubview(v)
//        }
        
        self.quickActionStackView = UILabel(frame: CGRect(x: 0, y: 0, width: self.panelView.width, height: 65))
        self.quickActionStackView.text = "more function coming soon..."
        self.quickActionStackView.textColor = .gray
        self.quickActionStackView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.quickActionStackView.textAlignment = .center
        self.panelView.addSubview(self.quickActionStackView)
    }
    
    @objc func didDragPanelView(_ sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: self.view)
        self.panelView.center = CGPoint(x: self.panelView.center.x, y: max(5, min(130 - self.panelView.height / 2, self.panelView.center.y + translation.y)))
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
    
    func dateSegmentViewDidChange(_ index: Int){
        self.collectionView.reloadData()
        self.collectionViewCurrentSelection = 0
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
//    @objc func didClickOnTopAction(_ sender: UITapGestureRecognizer){
//        let tag = sender.view!.tag
//        switch tag {
//        case 0:
//            //browse by date
//            let dateRangePickerViewController = CalendarDateRangePickerViewController(collectionViewLayout: UICollectionViewFlowLayout())
//            dateRangePickerViewController.delegate = self
//            dateRangePickerViewController.minimumDate = Date.init(timeIntervalSinceNow: -90 * 60 * 24 * 60)
//            dateRangePickerViewController.maximumDate = Date.init(timeIntervalSinceNow: 60 * 60 * 24 * 7)
//            self.browseByDateSelector = UINavigationController(rootViewController: dateRangePickerViewController)
//            self.navigationController?.present(self.browseByDateSelector!, animated: true){
//                UIApplication.shared.statusBarStyle = .default
//            }
//            break
//        case 1:
//            //browse by catagory
//            break
//        case 2:
//            //results
//            break
//        case 3:
//            //video
//            break
//        default:
//            fatalError()
//        }
//    }
    
    @objc func shouldReloadData(_ notification: Notification){
        self.collectionView.reloadData()
        self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        self.collectionViewCurrentSelection = 0
    }
}

extension SportsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count == 0{
            return 1
        }
        return AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count == 0{
            //no sports
            let view = collectionView.dequeueReusableCell(withReuseIdentifier: "MATCH_NO_DATA_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MatchNoDataCollectionViewCell
            view.data = self.dateSegmentView!.titles[self.dateSegmentView!.selectIndex]
            self.dragSignView.backgroundColor = UIColor.darkGray
            return view
        }
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "SPORTS_MATCH_CARD_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MatchCardCollectionViewCell
        view.data = AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex][indexPath.item]
        if indexPath.item == 0{
            self.dragSignView.backgroundColor = SPORTS_TYPE_COLOR[view.data!.catagory]!
            view.becomeLive()
        }
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth - 30, height: self.collectionView.height)
        //return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count > 0 else{
            return
        }
        let pageWidth = screenWidth - 30
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
            //print("right")
        } else {
            //print("left")
        }
        
        let a:CGFloat = scrollView.contentOffset.x/pageWidth
        var index = Int( round(a+factor) )
        if index < 0 {
            index = 0
        }
        if index > AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count - 1 {
            index = AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex].count - 1
        }
        if self.collectionViewCurrentSelection != index{
            print("new page")
            let oldIndexPath = IndexPath(row: self.collectionViewCurrentSelection, section: 0)
            let newIndexPath = IndexPath(row: index, section: 0)
            let oldCell = self.collectionView.cellForItem(at: oldIndexPath) as! GCAnimatedCell
            let newCell = self.collectionView.cellForItem(at: newIndexPath) as! GCAnimatedCell
            self.collectionViewCurrentSelection = index
            collectionView!.scrollToItem(at: newIndexPath, at: .left, animated: true)
            let dragSignViewColor = SPORTS_TYPE_COLOR[AppDataManager.shared.sportsGameData[self.dateSegmentView!.selectIndex][index].catagory]!
            UIView.animate(withDuration: 0.3){
                self.dragSignView.backgroundColor = dragSignViewColor
            }
            oldCell.endLive()
            newCell.becomeLive()
        }else{
            collectionView!.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .left, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        let targetCell = self.collectionView.cellForItem(at: IndexPath.init(row: self.collectionViewCurrentSelection, section: 0)) as! GCAnimatedCell
//        targetCell.endLive()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let targetCell = self.collectionView.cellForItem(at: IndexPath.init(row: self.collectionViewCurrentSelection, section: 0)) as! GCAnimatedCell
//        targetCell.becomeLive()
    }
}

extension SportsViewController: CalendarDateRangePickerViewControllerDelegate{
    func didTapCancel() {
        self.browseByDateSelector!.dismiss(animated: true){
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    func didTapDoneWithDateRange(startDate: Date!, endDate: Date!) {
        self.browseByDateSelector!.dismiss(animated: true){
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
}
