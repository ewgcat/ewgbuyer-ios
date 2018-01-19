//
//  NetTool.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/19.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation
import Alamofire

class NetTool{
    
    class func addToCart (goodsID:String, period:String) {
        if let userid = SYObject.currentUserID() {
            let par = ["goods_id":goodsID, "period":period, "user_id":userid]
            request(CLOUDPURCHASE_ADD_CART_URL, par: par) { (json) -> Void in
                print(json)
            }
        }
    }
    
    class func toStr (num: NSInteger) -> String {
        return "\(num)"
    }
    
    class func searchGoodsName(goodsName:String, selectCount: NSInteger, success:(NSMutableArray -> Void)){
        
        let par = [
            "keyword":goodsName,
            "begin_count":"0",
            "select_count":toStr(selectCount)
        ]
        
        request(CLOUDPURCHASE_SEARCH_URL, par: par) { (json) -> Void in
            let dataArray = NSMutableArray()
            let array = json["data"].arrayValue
            for smallJson in array{
                let model = OneYuanModel.yy_modelWithDictionary(smallJson.dictionaryObject)
                dataArray .addObject(model)
            }
            success(dataArray)
        }
    }
    
    //MARK: 通用请求方法(没有身份验证信息)
    class func request(lastUrl:String, par:[String:String], success:(JSON -> Void)) {
        let urlStr = FIRST_URL + lastUrl
        let request = Alamofire.request(.POST, urlStr, parameters: par)
        request.responseJSON { response in
            print("请求地址:" + String(response.request))
            
            
            if let jsonString = response.result.value {
                let json = JSON(jsonString)
                print("返回数据: \(json)")
                success(json)
            }
        }
    }
    
    
}