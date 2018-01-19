//
//  Extension.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

extension UIView {
    
    //MARK: - 屏幕尺寸
    static var screenH:CGFloat { return UIScreen.mainScreen().bounds.size.height }
    static var screenW:CGFloat { return UIScreen.mainScreen().bounds.size.width }
    
    //MARK: -
}

extension UIColor {
    static var BACKGROUNDCOLOR:UIColor { return UIColor.init(red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 242.0 / 255.0, alpha: 1) }
    static var SELLER_BLUE:UIColor { return UIColor.init(red: 21.0 / 255.0, green: 164.0 / 255.0, blue: 1, alpha: 1) }
}