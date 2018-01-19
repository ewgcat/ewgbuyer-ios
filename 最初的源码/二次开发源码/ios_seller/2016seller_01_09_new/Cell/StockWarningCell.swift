//
//  StockWarningCell.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class StockWarningCell: UITableViewCell {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    var model:StockWarningModel? {
        didSet{
            imageV.sd_setImageWithURL(NSURL.init(string: (model?.main_photo)!), placeholderImage: UIImage.init(named: "loading"))
            let qty = NSString.init(format: "%@", (model?.goods_warn_inventory)!)
            let str = "商品 \"" + model!.goods_name + "\" 库存已不足\(qty)件 " + "请尽快补充库存,以免影响正常销售" as NSString
            let desc = NSMutableAttributedString.init (string: str as String)
            let range = str.rangeOfString("库存已不足\(qty)件")
            desc.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: range)
            descLabel.attributedText = desc
        }
    }
    
    class func stockWarningCell (tableView:UITableView)->StockWarningCell {
        let cell = tableView .dequeueReusableCellWithIdentifier("StockWarningCell") as? StockWarningCell
        cell?.selectionStyle = .None
        return cell!
    }

}