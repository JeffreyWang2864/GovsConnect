//
//  DiscoverBasicCellView.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/30.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class DiscoverBasicCellView: UIView{
    var mainImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        return iv
    }()
    
    var titleView: UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.numberOfLines = 0
        return l
    }()
    var data: DiscoverItemDataContainer!{
        didSet{
            self.mainImageView.image = UIImage(named: data.coverImageName)!
            self.titleView.text = data.coverTitle
        }
    }
    
    func setUpViews(){
        let spaceToBound: CGFloat = 8
        let titleViewHeight: CGFloat = 50
        self.titleView.frame = CGRect(x: spaceToBound, y: self.frame.size.height - 55, width: self.frame.size.width - spaceToBound * 2, height: titleViewHeight)
        self.mainImageView.frame = CGRect(x: spaceToBound, y: spaceToBound, width: self.frame.size.width - spaceToBound * 2, height: self.frame.size.height - spaceToBound * 2 - titleViewHeight)
        self.addSubview(self.titleView)
        self.addSubview(self.mainImageView)
        self.layer.backgroundColor = APP_BACKGROUND_LIGHT_GREY.cgColor
        self.layer.cornerRadius = 15
    }
}
