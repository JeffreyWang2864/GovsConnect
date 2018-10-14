//
//  SportHomeHeadTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
typealias SportHomeHeadClickBlock = (DiscoverMatchDataContainer?, Bool) -> Void

class SportHomeHeadTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView!
    var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    var homeHeadClickBlock:SportHomeHeadClickBlock?
    var dataArray:[DiscoverMatchDataContainer]! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.layout.scrollDirection = .horizontal
        self.collectionView = UICollectionView.init(frame: self.contentView.bounds, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColorFromRGB(rgbValue: 0xf3f3f3, alpha: 0.9)
        self.collectionView.register(SportHomeHeadCollectionViewCell.self, forCellWithReuseIdentifier: "HomeHeadCollectionViewCell")
        self.collectionView.register(SportHomeHeadBrowseAllCell.self, forCellWithReuseIdentifier: "HomeHeadBrowseAllCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        self.contentView.addSubview(self.collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.bounds
        self.layout.itemSize = CGSize.init(width: self.contentView.width - 30, height: self.contentView.height)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.section < self.dataArray.count) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeadCollectionViewCell", for: indexPath) as! SportHomeHeadCollectionViewCell
            let matchModel = self.dataArray[indexPath.section]
            cell.matchModel = matchModel
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeadBrowseAllCell", for: indexPath) as! SportHomeHeadBrowseAllCell
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.section < self.dataArray.count) {
            if (self.homeHeadClickBlock != nil) {
                let matchModel = self.dataArray[indexPath.section]
                self.homeHeadClickBlock!(matchModel, false)
            }
        } else {
            if (self.homeHeadClickBlock != nil) {
                self.homeHeadClickBlock!(nil, true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
}
