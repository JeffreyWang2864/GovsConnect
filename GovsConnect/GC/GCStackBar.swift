//
//  GCStackBar.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/4/20.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class GCStackBar: UIView {
    var stackColors = [
        UIColorFromRGB(rgbValue: 0x6FB4FF, alpha: 1),
        UIColorFromRGB(rgbValue: 0xEEC558, alpha: 1),
        UIColorFromRGB(rgbValue: 0xE46A70, alpha: 1),
    ]
    var stackViews = Array<UIView>()
    var stackData = Array<Int>(){
        didSet{
            for view in self.stackViews{
                view.removeFromSuperview()
            }
            self.stackViews = []
            var x: CGFloat = 0.0
            let percentages = self.percentageStackData
            for i in stride(from: 0, to: percentages.count, by: 1){
                if percentages[i] == 0{
                    continue
                }
                let v = UIView(frame: CGRect(x: x, y: 0.0, width: self.width * percentages[i], height: self.height));
                v.backgroundColor = self.stackColors[i]
                self.addSubview(v)
                x += v.width
                self.stackViews.append(v)
            }
        }
    }
    var percentageStackData: Array<CGFloat>{
        let total = CGFloat(self.stackData.reduce(0, +))
        return self.stackData.map{
            CGFloat($0) / total
        }
    }
}
