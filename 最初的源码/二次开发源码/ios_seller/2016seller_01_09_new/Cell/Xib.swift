//
//  Xib.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/9.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation
import UIKit

//底部全选条
@objc protocol MultiSelectBarDelegate{
    func payOffClicked(multiSelectBar:MultiSelectBar)
    func multiSelClicked(multiSelectBar:MultiSelectBar)
}
class MultiSelectBar: UIView {
    
    var delegate:MultiSelectBarDelegate?
    
    @IBOutlet weak var payOffAmountLabel: UILabel!
    
    @IBOutlet weak var multiSelectBtn: UIButton!
    
    @IBAction func MultiSelectBtnClicked(sender: AnyObject) {
        let btn = sender as! UIButton
        btn.selected = !(btn.selected)
        if (delegate != nil){
            delegate?.multiSelClicked(self)
        }
    }

    @IBAction func payoffBtnClicked(sender: AnyObject) {
        if (delegate != nil){
            delegate?.payOffClicked(self)
        }
    }
    

}