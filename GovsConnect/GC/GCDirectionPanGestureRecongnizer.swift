//
//  GCDirectionPanGestureRecongnizer.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/11.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

class GCDirectionPanGestureRecongnizer: UIPanGestureRecognizer {
    enum Direction {
        case vertical
        case horizontal
    }
    let direction: Direction
    
    init(direction: Direction, target: AnyObject, action: Selector) {
        self.direction = direction
        super.init(target: target, action: action)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        
        if state == .began {
            let vel = velocity(in: view)
            switch direction {
            case .horizontal where fabs(vel.y) > fabs(vel.x):
                state = .cancelled
            case .vertical where fabs(vel.x) > fabs(vel.y):
                state = .cancelled
            default:
                break
            }
        }
    }
}

