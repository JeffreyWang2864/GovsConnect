//
//  GCWaterfallScrollView.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/1.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class GCWaterfallScrollView: UIScrollView {
    var spaceToScreen: CGFloat = 10
    var interCellSpace: CGFloat = 10
    var cells = Array<DiscoverBasicCellView>()
    var cellWidth: CGFloat = -1
    var cellHeight: CGFloat = -1
    var intercellOffset: CGFloat = 50
    func arrangeCells(){
        guard self.cells.count > 0 else{
            return
        }
        self.cellWidth = (UIScreen.main.bounds.width - (self.spaceToScreen * 2 + self.interCellSpace)) / 2
        var lastLeftHeight: CGFloat = self.spaceToScreen
        var lastRightHeight: CGFloat = self.spaceToScreen
        let rightSpaceX = self.spaceToScreen + self.cellWidth + self.interCellSpace
        self.cells[0].frame = CGRect(x: self.spaceToScreen, y: lastLeftHeight, width: self.cellWidth, height: self.cellHeight)
        self.cells[0].setUpViews()
        self.addSubview(cells[0])
        lastLeftHeight += (self.cellHeight + self.interCellSpace)
        let blockingView = DiscoverBasicCellView()
        blockingView.frame = CGRect(x: rightSpaceX, y: lastRightHeight, width: self.cellWidth, height: self.intercellOffset)
        blockingView.setUpViews()
        //self.addLastUpdateWarning(to: blockingView)
        self.addSubview(blockingView)
        lastRightHeight += (self.intercellOffset + self.interCellSpace)
        for i in stride(from: 1, to: self.cells.count, by: 1){
            let isRight = (i % 2 == 1)
            if isRight{
                self.cells[i].frame = CGRect(x: rightSpaceX, y: lastRightHeight, width: self.cellWidth, height: self.cellHeight)
                lastRightHeight += (self.cellHeight + self.interCellSpace)
            }else{
                self.cells[i].frame = CGRect(x: self.spaceToScreen, y: lastLeftHeight, width: self.cellWidth, height: self.cellHeight)
                lastLeftHeight += (self.cellHeight + self.interCellSpace)
            }
            self.cells[i].setUpViews()
            self.addSubview(self.cells[i])
        }
        let endBlockingView = DiscoverBasicCellView()
        if lastLeftHeight < lastRightHeight{
            endBlockingView.frame = CGRect(x: self.spaceToScreen, y: lastLeftHeight, width: self.cellWidth, height: lastRightHeight - lastLeftHeight - self.interCellSpace)
            lastLeftHeight += (lastRightHeight - lastLeftHeight)
        }else{
            endBlockingView.frame = CGRect(x: rightSpaceX, y: lastRightHeight, width: self.cellWidth, height: lastLeftHeight - lastRightHeight - self.interCellSpace)
            lastRightHeight += (lastLeftHeight - lastRightHeight)
        }
        endBlockingView.setUpViews()
        self.addSubview(endBlockingView)
        self.contentSize = CGSize(width: UIScreen.main.bounds.width, height: lastLeftHeight)
    }
    
    private func addLastUpdateWarning(to view: UIView){
        let warningImageView = UIImageView(frame: CGRect(x: 10, y: 14, width: 30 / 1.25, height: 25 / 1.25))
        if #available(iOS 13.0, *) {
            warningImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")!
        } else {
            // Fallback on earlier versions
        }
        warningImageView.tintColor = UIColorFromRGB(rgbValue: 0xFFAE34, alpha: 1.0)
        let warningLabel = UILabel(frame: CGRect(x: 40, y: 0, width: 120, height: 50))
        warningLabel.text = "important update from the developer"
        warningLabel.numberOfLines = 2
        warningLabel.lineBreakMode = .byTruncatingTail
        warningLabel.textColor = UIColorFromRGB(rgbValue: 0xFFAE34, alpha: 1.0)
        warningLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        view.addSubview(warningImageView)
        view.addSubview(warningLabel)
        
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.showLastUpdateWarning(_:)))
        view.addGestureRecognizer(tgr)
    }
    
    @objc private func showLastUpdateWarning(_ sender: UITapGestureRecognizer){
        makeMessageViaAlert(title: "Govs Connect Final Update?", message: "The information on this app is no longer accurate. I apologize for my lack of effort in putting into this project, especially in my senior year. I will probably make updates in the future, but for now please don't trust the info on this app.")
    }
}
