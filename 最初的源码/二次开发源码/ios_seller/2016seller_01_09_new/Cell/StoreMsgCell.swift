//
//  StoreMsgCell.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class StoreMsgCell: UITableViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var addTime: UILabel!
    @IBOutlet weak var arrowBtn: UIButton!
    
    var model:StoreMsgModel? {
        didSet{
            userName.text = model?.fromUser
            content.text = model?.content.stringByReplacingOccurrencesOfString("&nbsp;", withString: " ")
            let str = String(format: "%@", (model?.addTime)!)
            addTime.text = str
//            let date = NSDate.init(timeIntervalSince1970: str.doubleValue / 1000.0)
//            let arr = date.descriptionWithLocale("zh-CN").componentsSeparatedByString(" ")
//            let date1 = arr[0] + arr[3]
//            addTime.text = date1
        }
    }
    
    class func storeMsgCell (tableView:UITableView, btnSelect:Bool)->StoreMsgCell {
        var cell = tableView .dequeueReusableCellWithIdentifier("storeMsgCell") as? StoreMsgCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("StoreMsgCell", owner: self, options: nil).last as? StoreMsgCell
        }
        cell?.selectionStyle = .None
        cell?.content.font = UIFont.systemFontOfSize(15.0)
        cell?.addTime.font = UIFont.systemFontOfSize(15.0)
        cell?.arrowBtn.selected = btnSelect
        
        if btnSelect {
            cell?.content.numberOfLines = 0;
        }else {
            cell?.content.numberOfLines = 2;
        }
        return cell!
    }
    
}