//
//  FormulaModel.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation

enum FormulaType {
    case a,b,normal
}

struct FormulaModel {
    
    var formula : String = ""
    var numberA : String = ""
    var numberB : String = ""
    var bingoNumber : String = ""
    var expect : String = ""
    var type : FormulaType = .normal
    var showMore : Bool = false
    
    init() {}
    
    init(lottery:CloudPurchaseLottery) {
        self.formula = "[( 数值A+数值B) + 商品所需人次] 取余数 + 10000001"
        if lottery.user_time_num_count != nil {
            self.numberA = lottery.user_time_num_count
        } else {
            self.numberA = ""
        }
        if lottery.lottery_num != nil {
            self.numberB = lottery.lottery_num
        } else {
            self.numberB = "正在等待开奖..."
        }
        if lottery.lucky_code != nil{
            self.bingoNumber = lottery.lucky_code
        } else {
            self.bingoNumber = "等待揭晓"
        }
        if lottery.expect != nil {
            self.expect = lottery.expect
        } else {
            self.expect = ""
        }
        
    }
    
}
