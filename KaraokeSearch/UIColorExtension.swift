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
    
    class func NavBarColor() -> UIColor {
        return UIColor.rgbhex("6ADBAB", alpha: 1.0)
    }
    
    class func ViewBKColor() -> UIColor {
        return UIColor.rgbhex("772900", alpha: 0.9)
    }
}
