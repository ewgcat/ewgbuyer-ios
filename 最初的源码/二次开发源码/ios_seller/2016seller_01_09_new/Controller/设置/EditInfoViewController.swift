//
//  EditInfoViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/21.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

@objc protocol EditInfoViewControllerDelegate {
    func shouldShowNewStoreInfo(editInfoVC:EditInfoViewController,message:String)
}

class EditInfoViewController: BaseViewControllerNoTabbar {
    
    var storeTitle:String?
    var oldValue:String?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate:EditInfoViewControllerDelegate?
    
    //MARK: - 构造方法
    class func editInfoViewController()->EditInfoViewController?{
        let editVC = UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewControllerWithIdentifier("editInfo") as? EditInfoViewController
        return editVC
    }
    //MARK: - 视图创建
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBtnWithTitle("提交", normalImg: nil, highlightImg: nil, target: self, action: "submit")
        setupUI()
    }
    
    func setupUI() {
        textField.text = oldValue
        self.title = "修改" + storeTitle!
        titleLabel.text = "请输入新的" + storeTitle!
        textField.becomeFirstResponder()
    }
    
//    func isPhone(num:String)->Bool {
//        let phoneRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"
//        let phoneTest = NSPredicate.init(format: "SELF MATCHES%@", phoneRegex)
//        let isMatch = phoneTest.evaluateWithObject(num)
//        return isMatch
//    }
    
    func submit () {
        
        view.endEditing(true)
        
        if textField.text == "" {
            MyObject.failedPrompt("内容不能为空")
            return
        }
        if textField.text == oldValue {
            MyObject.failedPrompt("内容没有改动")
            return
        }
        
        let urlStr = SELLER_URL + SET_SELLER_INFO_URL
        var key = ""
        if storeTitle == "店铺名称" {
            key = "store_name"
        }else if storeTitle == "联系方式" {
            key = "store_telephone"
            //判断电话格式(座机手机都有，遂放弃判断)
//            if isPhone(textField.text!) == false {
//                textField.text = ""
//                MyObject.failedPrompt("请输入正确的电话号码")
//                return
//            }
        }
        let par = [
            "user_id":MyNetTool.currentUserID(),
            "token":MyNetTool.currentToken(),
            key:textField.text
        ]
        let headers = NetUtil.verify()
        
        let request = Alamofire.request(.POST, urlStr, parameters: par, headers: headers)
        request.responseJSON {response in
            print("请求地址:" + String(response.request))
            if let jsonString = response.result.value {
                let json = JSON(jsonString)
                print("返回数据: \(json)")
                let ret = json["ret"].object as? String
                if ret == "100" {
                    if (self.delegate != nil) {
                        let msg = self.storeTitle! + "修改成功"
                        self.delegate?.shouldShowNewStoreInfo(self, message: msg)
                        self.navigationController?.popViewControllerAnimated(true)
                        
                    }
                }else {
                    MyObject.failedPrompt("网络请求失败")
                }
            }
        }
    }
}