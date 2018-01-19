//
//  ViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/11.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

@objc protocol CropViewControllerDelegate {
    func shouldShowNewLogo(cropViewCOntroller:CropViewController)
}

class CropViewController:UIViewController {
    
    let screenH = UIView.screenH
    let screenW = UIView.screenW
    
    let cropW = 210 as CGFloat//裁剪框宽度
    let cropH = 78 as CGFloat//裁剪框高度
    
    var cropView:UIView?//裁剪框
    var imageView:UIImageView?
    var scrollView:UIScrollView?
    var newImage:UIImage?//裁剪之后的图片
    
    var image:UIImage?//上个控制器传入的图片
    
    var delegate:CropViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI(){
        
        view.backgroundColor = UIColor.blackColor()
        
        addCropFrameView()
        addImage()
        addShadow()
        addToolbar(leftTitle: "取消", leftAction: "cancel", rightTitle: "裁剪", rightAction: "crop")
        
    }
    
    //MARK: - 添加上下阴影
    func addShadow(){
        
        let x1 = 0 as CGFloat
        let y1 = 0 as CGFloat
        let w1 = screenW
        let h1 = cropView!.frame.origin.y
        let topShadow = UIView.init(frame: CGRect.init(x: x1, y: y1, width: w1, height: h1))
        topShadow.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        let x2 = 0 as CGFloat
        let y2 = h1 + cropView!.frame.size.height
        let w2 = screenW
        let h2 = screenH - y2
        let bottomShadow = UIView.init(frame: CGRect.init(x: x2, y: y2, width: w2, height: h2))
        bottomShadow.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.3)
        
        view .addSubview(topShadow)
        view .addSubview(bottomShadow)
    }
    
    //MARK: - 放入原图片
    func addImage(){
        let scrollView = UIScrollView.init()
        scrollView.bounds = UIScreen.mainScreen().bounds
        scrollView.center = view.center
        var fr = scrollView.frame
        fr.origin.y -= cropView!.frame.minY
        scrollView.frame = fr
        self.scrollView = scrollView
        scrollView.contentSize = CGSize.init(width: screenW * 15, height: screenH * 15)
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        if let cropView1 = cropView{
            cropView1 .addSubview(scrollView)
            
            let size = image!.size
            let imageView = UIImageView.init(image: image)
            self.imageView = imageView
            
            let w = screenW
            let h = screenW / size.width * size.height
            
            imageView.bounds = CGRect.init(x: 0, y: 0, width: w, height: h)
            imageView.center = cropView!.center
            
            scrollView.addSubview(imageView)
        }
        
    }
    
    //MARK: - 添加裁剪框
    func addCropFrameView(){
        //画线
        let cX = 0 as CGFloat
        let cW = screenW
        // cH / cW = cropH / cropW
        let cH = cropH / cropW * cW
        let cY = 0.5 * (screenH - cH)
        
        let cropView = UIView.init(frame: CGRect.init(x: cX, y: cY, width: cW, height: cH))
        cropView.backgroundColor = UIColor.blackColor()
        cropView.layer.borderWidth = 1.0
        cropView.layer.borderColor = UIColor.whiteColor().CGColor
        view .addSubview(cropView)
        
        self.cropView = cropView
    }
    
    //MARK: - 添加底部工具栏
    func addToolbar(leftTitle leftTitle:String,leftAction:Selector,rightTitle:String,rightAction:Selector) {
        let tH = 44.0 as CGFloat
        
        let toolbar = UIToolbar.init(frame: CGRect.init(x: 0,y: screenH-tH,width: screenW,height: tH))
        view .addSubview(toolbar)
        
        let item1 = UIBarButtonItem.init(title: leftTitle, style: .Plain, target: self, action: leftAction)
        let item2 = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let item3 = UIBarButtonItem.init(title: rightTitle, style: .Plain, target: self, action: rightAction)
        toolbar.items = [item1,item2,item3]
    }
    
    //MARK: - 裁剪动作
    func crop(){
        cropView?.clipsToBounds = true
        scrollView?.scrollEnabled = false
        
        getImage()
        showNewImage()
        addToolbar(leftTitle: "取消", leftAction: "cancel", rightTitle: "完成", rightAction: "confirm")
    }
    
    //MARK: - 获得裁剪后的图片
    func getImage(){
        UIGraphicsBeginImageContext(cropView!.frame.size)
        let ctx = UIGraphicsGetCurrentContext()
        cropView!.layer .renderInContext(ctx!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.newImage = newImage
    }
    
    //MARK: - 显示裁剪后的图片
    func showNewImage(){
        
        let cropF = cropView!.frame
        
        for subview in view.subviews {
            subview.removeFromSuperview()
        }
        
        let newImageView = UIImageView.init(image: self.newImage!)
        newImageView.frame = cropF
        view.addSubview(newImageView)
        
    }
    
    //MARK: - 上传头像并显示在设置界面
    func confirm(){
        print("上传图片并显示到店铺logo")
        if let img = self.newImage {
            let imgData = UIImageJPEGRepresentation(img, 1)
            let encodedString = imgData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            let urlStr = SELLER_URL + IMG_UPLOAD_URL
            let par = [
                "user_id":MyNetTool.currentUserID(),
                "token":MyNetTool.currentToken(),
                "image":encodedString
            ]
            let headers = NetUtil.verify()
            
            let request = Alamofire.request(.POST, urlStr, parameters: par, headers: headers)
            request.responseJSON {response in
                print("请求地址:" + String(response.request))
                if let jsonString = response.result.value {
                    let json = JSON(jsonString)
                    print("返回数据: \(json)")
                    let imgJson = json["data"]["acc_id"]
                    let imgUrl = imgJson.object as? Int
                    if let imgUrl1 = imgUrl {
                        self.setLogo(String(imgUrl1))
                    }else {
                        MyObject.failedPrompt("上传图片失败")
                    }
                    
                }
            }
        }
    }
    
    //MARK: - 发送设置logo请求
    func setLogo (imgUrl:String) {
        let urlStr = SELLER_URL + SET_SELLER_INFO_URL
        let par = [
            "user_id":MyNetTool.currentUserID(),
            "token":MyNetTool.currentToken(),
            "store_logo_id":imgUrl
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
                        self.delegate?.shouldShowNewLogo(self)
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            MyObject.failedPrompt("店铺图标修改成功")
                        })
                    }
                }else {
                    MyObject.failedPrompt("网络请求失败")
                }
            }
        }
    }
    
    //MARK: - 取消操作
    func cancel(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 工厂方法
    class func cropViewController () -> CropViewController{
        return UIStoryboard.init(name: "Setting", bundle: nil).instantiateViewControllerWithIdentifier("crop") as! CropViewController
    }
}

//MARK: - UIScrollViewDelegate
extension CropViewController : UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}

