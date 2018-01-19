//
//  NetUtil.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class NetUtil {
    
    class func verify()->[String:String]{
        let filePath = NSHomeDirectory() + "/Documents/user_information.txt"
        let array = NSArray.init(contentsOfFile: filePath)
        let verify = array![3] as! String
        return ["verify":verify]
    }
    
}