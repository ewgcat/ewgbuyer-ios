//
//  BaseViewControllerNoTabBar.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/17.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import Foundation
import UIKit

class BaseViewControllerNoTabBar: UIViewController {
    
    //构造
    override func viewDidLoad() {
        print("\(self.classForCoder).viewDidLoad()")
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController!.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController!.tabBar.hidden = false
    }
    
    //析构
    deinit {
        print("\(self.classForCoder).deinit")
    }
    
    //内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //导航栏左侧按钮
    func setLeftBtn() {
        self.setLeftBtn("", norImg: "back_lj", highImg: "", target: self, action: "backAction")
    }
    
    //导航栏左侧按钮
    func setLeftBtn(title: String, norImg: String, highImg: String, target: AnyObject?, action: Selector) {
        let leftButton = UIButton(type: .Custom)
        leftButton.frame = CGRectMake(0, 0, 15, 23.5)
        leftButton.setTitle(title, forState: .Normal)
        if !norImg.isEmpty {
            leftButton.setBackgroundImage(UIImage(named: norImg), forState: .Normal)
        }
        if !highImg.isEmpty {
            leftButton.setBackgroundImage(UIImage(named: highImg), forState: .Highlighted)
        }
        leftButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        leftButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        leftButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        let backBar = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = backBar
    }
    
    //导航栏左侧按钮
    func setRightBtn(title: String, norImg: String, highImg: String, target: AnyObject?, action: Selector) {
        let rightButton = UIButton(type: .Custom)
        rightButton.frame = CGRectMake(0, 0, 44, 44)
        rightButton.setTitle(title, forState: .Normal)
        rightButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        if !norImg.isEmpty {
            rightButton.setBackgroundImage(UIImage(named: norImg), forState: .Normal)
        }
        if !highImg.isEmpty {
            rightButton.setBackgroundImage(UIImage(named: highImg), forState: .Highlighted)
        }
        rightButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        rightButton.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        let rightBar = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem = rightBar
    }
    
    //pop返回
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension UIView {
    static var screenH:CGFloat { return UIScreen.mainScreen().bounds.size.height }
    static var screenW:CGFloat { return UIScreen.mainScreen().bounds.size.width }
}

extension UIColor {
    static var normalGray:UIColor { return UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1) }
}
