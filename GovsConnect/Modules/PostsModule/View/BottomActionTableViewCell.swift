//
//  BottomActionTableViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/8.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class BottomActionTableViewCell: UITableViewCell {
    @IBOutlet var button: UIButton!
    var buttonDidClickBlock: ((IndexPath) -> ())!
    var indexPath: IndexPath!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear    
        self.button.clipsToBounds = true
        self.button.layer.cornerRadius = 15
        self.button.backgroundColor = UIColor.white
        self.button.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.button.setTitleColor(UIColor.gray, for: .disabled)
        self.button.titleLabel!.font = UIFont.systemFont(ofSize: 20)
        self.button.addTarget(self, action: #selector(self.buttonDidClick(_:)), for: .touchDown)
    }
    
    func setButtonActivity(){
        if AppIOManager.shared.connectionStatus != .none{
            //connect to internet
            self.button.setTitle("load more", for: .normal)
            self.button.isEnabled = true
        }else{
            self.button.setTitle("offline mode", for: .normal)
            self.button.isEnabled = false
        }
    }
    
    @objc func buttonDidClick(_ sender: UIButton){
        let newIndexPath = IndexPath(item: self.indexPath.item, section: self.indexPath.section - 1)
        self.buttonDidClickBlock(newIndexPath)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
