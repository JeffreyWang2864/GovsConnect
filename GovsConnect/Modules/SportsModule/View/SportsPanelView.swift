//
//  SportsPanelView.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2019/2/13.
//  Copyright © 2019 Eagersoft. All rights reserved.
//

import UIKit

class SportsPanelView: UIView{
    private var shadowLayer: CAShapeLayer!
    private var cornerRadii = CGSize(width: 15, height: 15)
    private var fillColor: UIColor = APP_BACKGROUND_LIGHT_GREY
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: cornerRadii).cgPath
            shadowLayer.fillColor = fillColor.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.2
            shadowLayer.shadowRadius = 3
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}

