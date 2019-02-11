//
//  SportsViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/3.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    var collectionViewCurrentSelection: Int = 0
    var numberOfItems = 3
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib.init(nibName: "MatchCardCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "SPORTS_MATCH_CARD_COLLECTIONVIEW_CELL_ID")
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isPagingEnabled = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    @objc func loginAction(_ notification: Notification){
        
    }
}

extension SportsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "SPORTS_MATCH_CARD_COLLECTIONVIEW_CELL_ID", for: indexPath) as! MatchCardCollectionViewCell
        view.data = indexPath.item
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
        let pageWidth = screenWidth - 30
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
            print("right")
        } else {
            print("left")
        }
        
        let a:CGFloat = scrollView.contentOffset.x/pageWidth
        var index = Int( round(a+factor) )
        if index < 0 {
            index = 0
        }
        if index > self.numberOfItems - 1 {
            index = self.numberOfItems - 1
        }
        let indexPath = IndexPath(row: index, section: 0)
        self.collectionViewCurrentSelection = index
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let targetCell = self.collectionView.cellForItem(at: IndexPath.init(row: self.collectionViewCurrentSelection, section: 0)) as! MatchCardCollectionViewCell
        targetCell.endLive()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let targetCell = self.collectionView.cellForItem(at: IndexPath.init(row: self.collectionViewCurrentSelection, section: 0)) as! MatchCardCollectionViewCell
        targetCell.becomeLive()
    }
}


