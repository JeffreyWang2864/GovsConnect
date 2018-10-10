//
//  String+Ext.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/9.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

extension String{
    func boundingRectWithSize(size: CGSize,font: UIFont,lineSpacing: CGFloat,maxLines: Int) -> CGFloat {
        if (maxLines <= 0) {
            return 0
        }
        let maxHeight = font.lineHeight * CGFloat(maxLines) + CGFloat(lineSpacing) * CGFloat((maxLines - 1))
        let orginalSize = self.boundingRectWithSize(size: size, font: font, lineSpacing: lineSpacing)
        if (orginalSize.height >= maxHeight) {
            return maxHeight
        } else {
            return orginalSize.height
        }
    }
    
    func containChinese(string: String) -> Bool {
        for (_, value) in string.characters.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
    
    func boundingRectWithSize(size:CGSize,font:UIFont,lineSpacing:CGFloat) -> CGSize {
        let attributeString = NSMutableAttributedString.init(string: self)
        let paragraphStyle = NSMutableParagraphStyle.init()
        paragraphStyle.lineSpacing = lineSpacing
        attributeString.addAttributes([NSAttributedString.Key.paragraphStyle : paragraphStyle], range: NSRange.init(location: 0, length: self.count))
        attributeString.addAttributes([NSAttributedString.Key.font : font], range: NSRange.init(location: 0, length: self.count))
        var rect = attributeString.boundingRect(with: size, options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue), context: nil)
        if (rect.size.height - font.lineHeight <= paragraphStyle.lineSpacing) {
            if (self.containChinese(string: self)) {
                rect = CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height-paragraphStyle.lineSpacing)
            }
        }
        return rect.size
    }
}
