//
//  RateYourFoodViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import TBDropdownMenu

class RateYourFoodViewController: UIViewController{
    @IBOutlet var collectionView: UICollectionView!
    var titleLabel = UILabel()
    var arrowImageView = UIImageView(image: UIImage(named: "system_drop_down_arrow.png")!)
    var menuView: DropdownMenu!
    var likeView: UILabel!
    var dislikeView: UILabel!
    var menuIndex = 0
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "system_reload"), style: .plain, target: self, action: #selector(self.didClickOnReload))
        self.titleLabel = UILabel()
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "lunch/brunch"
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
        let menuItem1 = DropdownItem(title: "lunch/brunch")
        let menuItem2 = DropdownItem(title: "dinner")
        self.menuView = DropdownMenu(navigationController: self.navigationController!, items: [menuItem1, menuItem2], selectedRow: 0)
        self.menuView.highlightColor = APP_THEME_COLOR
        self.menuView.delegate = self
        self.collectionView.register(UINib(nibName: "FoodCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FOOD_COLLECTION_VIEW_CELL")
        self.collectionView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.likeView = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 40))
        self.likeView.backgroundColor = UIColor.green
        self.likeView.alpha = 0.0
        self.likeView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.likeView.textAlignment = .center
        self.likeView.textColor = UIColor.white
        let dislikeViewY: CGFloat = {
            switch PHONE_TYPE{
            case .iphone5:
                return self.view.frame.size.height - 200
            case .iphone6:
                return self.view.frame.size.height - 103
            case .iphone6plus:
                return self.view.frame.size.height - 35
            case .iphonex:
                return self.view.frame.size.height - 15
            }
        }()
        self.dislikeView = UILabel(frame: CGRect(x: 0, y: dislikeViewY, width: screenWidth, height: 40))
        self.dislikeView.backgroundColor = UIColor.red
        self.dislikeView.layer.cornerRadius = 15
        self.dislikeView.alpha = 0.0
        self.dislikeView.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.dislikeView.textAlignment = .center
        self.dislikeView.textColor = UIColor.white
        self.view.addSubview(self.likeView)
        self.view.addSubview(self.dislikeView)
    }
    
    @objc private func didClickOnTitle(_ sender: UITapGestureRecognizer) {
        self.menuView.showMenu()
        self.arrowImageViewRotatePi()
    }
    
    @objc func didClickOnReload(){
        guard AppIOManager.shared.connectionStatus != .none else{
            makeMessageViaAlert(title: "Cannot reload on offline mode", message: "Your device is not connecting to the Internet.")
            return
        }
        AppIOManager.shared.loadFoodData { (isSucceed) in
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
        }
    }
    
    func arrowImageViewRotatePi(in interval: TimeInterval = 0.25){
        UIView.animate(withDuration: interval){
            self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: .pi)
        }
    }
}

extension RateYourFoodViewController: DropdownMenuDelegate{
    func dropdownMenu(_ dropdownMenu: DropdownMenu, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item == 0{
            self.titleLabel.text = "lunch/brunch"
            self.menuIndex = 0
        }else{
            self.titleLabel.text = "dinner"
            self.menuIndex = 1
        }
        self.collectionView.reloadData()
        self.arrowImageViewRotatePi()
    }
    
    func dropdownMenuCancel(_ dropdownMenu: DropdownMenu) {
        self.arrowImageViewRotatePi()
    }
    
    @objc func didLongPressOnCell(_ sender: GCDirectionPanGestureRecongnizer){
        let cell = self.collectionView.cellForItem(at: self.currentIndexPath) as! FoodCollectionViewCell
        switch sender.state{
        case .began:
            if cell.originFrame == nil{
                cell.originFrame = cell.frame
            }
            self.likeView.text = "like"
            self.dislikeView.text = "dislike"
            UIView.animate(withDuration: 0.3){
                self.likeView.alpha = 0.5
                self.dislikeView.alpha = 0.5
            }
        case .changed:
            let velocity = sender.velocity(in: self.view)
            cell.changeFrame(with: velocity.y)
            if cell.frame.origin.y < self.likeView.bottom && self.likeView.alpha == 0.5{
                self.likeView.text = "release to like"
                UIView.animate(withDuration: 0.2){
                    self.likeView.alpha = 1
                }
            }else if cell.frame.origin.y >= self.likeView.bottom && self.likeView.alpha != 0.5{
                self.likeView.text = "like"
                UIView.animate(withDuration: 0.2){
                    self.likeView.alpha = 0.5
                }
            }
            if cell.bottom > self.dislikeView.top && self.dislikeView.alpha == 0.5{
                self.dislikeView.text = "release to dislike"
                UIView.animate(withDuration: 0.2){
                    self.dislikeView.alpha = 1
                }
            }else if cell.bottom <= self.dislikeView.top && self.dislikeView.alpha != 0.5{
                self.dislikeView.text = "dislike"
                UIView.animate(withDuration: 0.2){
                    self.dislikeView.alpha = 0.5
                }
            }
        case .ended:
            let food_id = AppDataManager.shared.discoverMenu[self.menuIndex][self.currentIndexPath.item]._id
            if cell.frame.origin.y < self.likeView.bottom{
                //liked
                AppIOManager.shared.foodDataAction(food_id: food_id, method: "plus") { (isSucceed) in
                    self.likeView.text = "liked"
                    UIView.animate(withDuration: 0.3){
                        cell.changeBackToOriginal()
                        self.dislikeView.alpha = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        UIView.animate(withDuration: 0.3){
                            self.likeView.alpha = 0.0
                        }
                    }
                }
                break
            }else if cell.bottom > self.dislikeView.top{
                //disliked
                AppIOManager.shared.foodDataAction(food_id: food_id, method: "minus") { (isSucceed) in
                    self.dislikeView.text = "disliked"
                    UIView.animate(withDuration: 0.3){
                        cell.changeBackToOriginal()
                        self.likeView.alpha = 0.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        UIView.animate(withDuration: 0.3){
                            self.dislikeView.alpha = 0.0
                        }
                    }
                }
                break
            }
            //none selected
            UIView.animate(withDuration: 0.3){
                cell.changeBackToOriginal()
                self.likeView.alpha = 0.0
                self.dislikeView.alpha = 0.0
            }
        default:
            NSLog("default")
        }
    }
}

extension RateYourFoodViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDataManager.shared.discoverMenu[self.menuIndex].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FOOD_COLLECTION_VIEW_CELL", for: indexPath) as! FoodCollectionViewCell
        let data = AppDataManager.shared.discoverMenu[self.menuIndex][indexPath.item]
        cell.indexTag = indexPath
        cell.data = data
        let pgr = GCDirectionPanGestureRecongnizer(direction: .vertical, target: self, action: #selector(self.didLongPressOnCell(_:)))
        cell.addGestureRecognizer(pgr)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth - 40, height: screenWidth - 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let topSpace = (self.view.height - (screenWidth - 40)) / 2
        return UIEdgeInsets(top: topSpace, left: 20, bottom: topSpace, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let item = self.collectionView.contentOffset.x / self.collectionView.frame.size.width
        self.currentIndexPath.item = Int(item + 0.5)
    }
}
