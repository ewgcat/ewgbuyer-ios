//
//  BaseProtocols.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation

protocol StandardCell {
    static func cellHeight() -> CGFloat
}

extension StandardCell {
    
    static func cellWithTableView(tableView:UITableView, identifier:String) -> AnyObject? {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        if let cell = cell {
            return cell
        }else {
            return NSBundle.mainBundle().loadNibNamed(identifier, owner: nil, options: nil).last
        }
    }

    
}