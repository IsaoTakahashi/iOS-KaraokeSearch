//
//  UIColorExtension.swift
//  KaraokeSearch
//
//  Created by 高橋 勲 on 2015/05/09.
//  Copyright (c) 2015年 高橋 勲. All rights reserved.
//

import UIKit

extension UIColor {
    class func rgbhex (var hexStr : NSString, var alpha : CGFloat) -> UIColor {
        hexStr = hexStr.stringByReplacingOccurrencesOfString("#", withString: "")
        let scanner = NSScanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            print("invalid hex string")
            return UIColor.whiteColor();
        }
    }
    
    class func MainColor() -> UIColor {
        return UIColor.rgbhex("23C47F", alpha: 1.0)
    }
    
    class func MainMidDarkColor() -> UIColor {
        return UIColor.rgbhex("009656", alpha: 1.0)
    }
    
    class func MainDarkColor() -> UIColor {
        return UIColor.rgbhex("007342", alpha: 1.0)
    }
    
    class func MainMidLightColor() -> UIColor {
        return UIColor.rgbhex("4EDDA0", alpha: 1.0)
    }
    
    class func MainLightColor() -> UIColor {
        return UIColor.rgbhex("BEF5DD", alpha: 1.0)
    }
    
    class func SubColor() -> UIColor {
        return UIColor.rgbhex("FFA52D", alpha: 1.0)
    }
    
    class func SubMidDarkColor() -> UIColor {
        return UIColor.rgbhex("DB7D00", alpha: 1.0)
    }
    
    class func SubDarkColor() -> UIColor {
        return UIColor.rgbhex("A86000", alpha: 1.0)
    }
    
    class func SubMidLightColor() -> UIColor {
        return UIColor.rgbhex("FFB85A", alpha: 1.0)
    }
    
    class func SubLightColor() -> UIColor {
        return UIColor.rgbhex("FFE6C5", alpha: 1.0)
    }
    
    class func NavBarColor() -> UIColor {
        return UIColor.MainMidLightColor()
    }
    
    class func NavBarTitleColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func ButtonTextColor() -> UIColor {
        return UIColor.whiteColor()
    }
    
    class func ButtonBKColor() -> UIColor {
        return UIColor.MainColor()
    }
    
    class func TextFieldTextColor() -> UIColor {
        return UIColor.MainMidLightColor()
    }
    
    class func StaticLabelTextColor() -> UIColor {
        return UIColor.MainMidLightColor()
    }
    
    class func LabelTextColor() -> UIColor {
        return UIColor.MainMidDarkColor()
    }
    
    class func CellTextColor() -> UIColor {
        return UIColor.MainColor()
    }
    
    class func ViewBKColor() -> UIColor {
        return UIColor.rgbhex("772900", alpha: 0.9)
    }
}
