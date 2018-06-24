//
//  GCBaseTableViewCell.swift
//  GovsConnect
//
//  Created by Spring on 2018/6/20.
//  Copyright © 2018年 Eagersoft. All rights reserved.
//  基类cell

import UIKit

class GCBaseTableViewCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
