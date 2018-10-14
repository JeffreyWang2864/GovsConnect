//
//  SportHomeGridTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

typealias ClickBlock = (GCSportType) -> Void

class SportHomeGridTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView:UICollectionView!
    var dataArray:[GCSportType]! {
        didSet {
            self.collectionView.reloadData()
        }
    }
    var clickBlock:ClickBlock?
    
    var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let margin:CGFloat = 15
        let itemWidth:CGFloat = (screenWidth - margin * 4) / 3
        self.layout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        self.layout.minimumLineSpacing = margin
        self.layout.minimumInteritemSpacing = margin
        
        self.collectionView = UICollectionView.init(frame: self.contentView.bounds, collectionViewLayout: self.layout)
        self.collectionView.contentInset = UIEdgeInsets.init(top: 0, left: margin, bottom: margin, right: margin)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.register(SportHomeGridCollectionViewCell.self, forCellWithReuseIdentifier: "HomeGridCollectionViewCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.contentView.addSubview(self.collectionView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.bounds
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeGridCollectionViewCell", for: indexPath) as! SportHomeGridCollectionViewCell
        cell.matchTypeModel = self.dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let matchTypeModel = self.dataArray[indexPath.item]
        if (self.clickBlock != nil) {
            self.clickBlock!(matchTypeModel)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
