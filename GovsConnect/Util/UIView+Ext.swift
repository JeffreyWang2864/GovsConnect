//
//  UIView+Ext.swift
//  bubblepop
//
//  Created by _ on 2018/5/4.
//  Copyright © 2018年 cc. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    public var x:CGFloat{
        set{
            var f = self.frame
            f.origin.x = newValue
            self.frame = f
        }
        get{
            return self.frame.origin.x
        }
    }
    
    public var y:CGFloat{
        set{
            var f = self.frame
            f.origin.y = newValue
            self.frame = f
        }
        get{
            return self.frame.origin.y
        }
    }
    public var left:CGFloat{
        set{
            var f = self.frame
            f.origin.x = newValue
            self.frame = f
        }
        get{
            return self.frame.origin.x
        }
    }
    public var right:CGFloat{
        set{
            var f = self.frame
            f.origin.x = newValue - self.frame.size.width
            self.frame = f
        }
        get{
            return self.frame.origin.x+self.frame.size.width
        }
    }
    public var top:CGFloat{
        set{
            var f = self.frame
            f.origin.y = newValue
            self.frame = f
        }
        get{
            return self.frame.origin.y
        }
    }
    public var width:CGFloat{
        set{
            var f = self.frame
            f.size.width = newValue
            self.frame = f
        }
        get{
            return self.frame.size.width
        }
    }
    public var height:CGFloat
    {
        set{
            var f = self.frame
            f.size.height = newValue
            self.frame = f
        }
        get{
            return self.frame.size.height
        }
    }
    public var bottom:CGFloat
    {
        set{
            var f = self.frame
            f.origin.y = newValue - self.frame.size.width
            self.frame = f
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
    public func circleView()->Void
    {
        self.layer.cornerRadius = self.width * 0.5;
        self.clipsToBounds = true
    }
}

extension String{
    func serializable() -> String{
        var ret = self
        ret = ret.replacingOccurrences(of: ">", with: "_GrEa_")
        ret = ret.replacingOccurrences(of: "<", with: "_LeSs_")
        ret = ret.replacingOccurrences(of: " ", with: "_SpAc_")
        ret = ret.replacingOccurrences(of: "\"", with: "_EnQu_")
        ret = ret.replacingOccurrences(of: "”", with: "_CnQu_")
        ret = ret.replacingOccurrences(of: "\'", with: "_SiQu_")
        ret = ret.replacingOccurrences(of: "’", with: "_CsQu_")
        ret = ret.replacingOccurrences(of: "\\", with: "_AnSl_")
        ret = ret.replacingOccurrences(of: "\n", with: "_EnTe_")
        ret = ret.replacingOccurrences(of: "\r", with: "_EoLh_")
        ret = ret.replacingOccurrences(of: "&", with: "_AtMa_")
        ret = ret.replacingOccurrences(of: ";", with: "_SmCl_")
        ret = ret.replacingOccurrences(of: "#", with: "_NuMb_")
        ret = ret.replacingOccurrences(of: "%", with: "_PeRc_")
        ret = ret.replacingOccurrences(of: "^", with: "_JiAn_")
        ret = ret.replacingOccurrences(of: "{", with: "_LeHq_")
        ret = ret.replacingOccurrences(of: "}", with: "_RiHq_")
        ret = ret.replacingOccurrences(of: "|", with: "_ShUg_")
        ret = ret.replacingOccurrences(of: "€", with: "_EuRo_")
        ret = ret.replacingOccurrences(of: "£", with: "_PoUn_")
        ret = ret.replacingOccurrences(of: "¥", with: "_YuAn_")
        ret = ret.replacingOccurrences(of: "•", with: "_DoTs_")
        return ret
    }
}
