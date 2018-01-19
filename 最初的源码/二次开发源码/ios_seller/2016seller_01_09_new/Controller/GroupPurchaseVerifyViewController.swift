//
//  GroupPurchaseVerifyViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class GroupPurchaseVerifyViewController: BaseViewControllerNoTabbar {
    
    @IBOutlet weak var resultTextField: UITextField!//数字显示屏

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        createInputView()
    }
    
    //MARK: - 设置UI
    func setupUI(){
        title = "团购验证"
    }
    
    //MARK: - 创建数字键盘
    func createInputView(){
        
        let inputPadView = UIView.init(frame: CGRect.init(x: 0, y: 107 + 44, width:UIView.screenW , height: UIView.screenH - 107 - 44 - 20))
        view.addSubview(inputPadView)
        inputPadView.backgroundColor = UIColor.BACKGROUNDCOLOR
        
        //68 * 68
        let w = inputPadView.frame.width / 3.0
        let h = inputPadView.frame.height / 4.0
        
        
        for index in 0..<12{
            let x = w  * CGFloat(index % 3)
            let y = h * CGFloat(index / 3)
            let btn = UIButton.init(type: .System)
            let frame = CGRect.init(x: x, y: y, width: w, height: h)
            let holderView = UIView.init(frame: frame)
            let bX = 0.5 * (w - 68)
            let bY = bX
            btn.frame = CGRect.init(x: bX, y: bY, width: 68, height: 68)
            let norName = "x0" + "\(index + 1)"
            let hiliName = "x00" + "\(index + 1)"
            btn.setBackgroundImage(UIImage.init(named: norName), forState: .Normal)
            btn.setBackgroundImage(UIImage.init(named: hiliName), forState: .Highlighted)
            inputPadView.addSubview(holderView)
            holderView.addSubview(btn)
            
            btn.tag = index
            btn.addTarget(self, action: "keypadClicked:", forControlEvents: .TouchUpInside)
        }
        
        
    }
    
    //MARK: - 点击事件
    func keypadClicked(btn:UIButton){
        //12确定
        var display = resultTextField.text
        let index = btn.tag
        print(index)
        //删除
        if index == 10 {
            if display == ""{
                return
            }
            display?.removeAtIndex(display!.endIndex.predecessor())
            resultTextField.text = display
            return
        }
        
        //确定
        if index == 11{
            resultTextField.text = ""
            confirm()
            return
        }
        
        if display == "" || display == nil {
            resultTextField.text = String(index)
        }else{
            let display1 = display! + String(index)
            resultTextField.text = display1
        }
        
    }
    
    //MARK: - 提交请求
    func confirm(){
        
        let urlStr = SELLER_URL + GROUP_VERIFY_URL
        let par = [
            "user_id":MyNetTool.currentUserID(),
            "token":MyNetTool.currentToken(),
            "value":resultTextField.text
        ]
        let headers = NetUtil.verify()
        
        let request = Alamofire.request(.POST, urlStr, parameters: par, headers:headers)
        request.responseJSON { response in
            print("请求地址:" + String(response.request))
            
            if let jsonString = response.result.value {
                let json = JSON(jsonString)
                print("返回数据: \(json)")
//                if (json["verify"] == "false"){
//                    MyObject.failedPrompt("登录超时,请重新登录!", complete: { () -> Void in
//                        MyNetTool.logout()
//                    })
//                    return
//                }
                let info = json["ret"]
                MyObject.failedPrompt(info.stringValue)
            }
        }
    }
    
    //MARK: - 工厂方法
    class func groupPurchaseVerifyVC ()->GroupPurchaseVerifyViewController{
        let sb = UIStoryboard.init(name: "GroupPurchase", bundle: nil)
        let groupPurchaseVerifyVC = sb.instantiateViewControllerWithIdentifier("groupPurchaseVerify") as! GroupPurchaseVerifyViewController
        return groupPurchaseVerifyVC
    }
}