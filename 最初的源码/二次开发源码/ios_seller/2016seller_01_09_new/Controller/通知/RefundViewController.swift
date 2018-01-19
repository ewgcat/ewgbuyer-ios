//
//  RefundViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class RefundViewController: BaseViewControllerNoTabbar,UITableViewDataSource,UITableViewDelegate {
    
    //数组
    var refundArray:NSMutableArray?
    var returnArray:NSMutableArray?
    var dataArray:NSMutableArray?
    //tableView
    var myTableView:UITableView?
    
    var seg:UISegmentedControl?
    var noData:UIView?
    
    //MARK: - 视图的生命周期方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - 初始化UI
    func setupUI () {
        title = "退货退款"
        //添加segmented control
        let headers = ["退货订单","退款订单"]
        let seg = UISegmentedControl.init(items: headers)
        seg.frame = CGRect.init(x: 10, y: 74, width: UIView.screenW - 20, height: 40)
        seg.selectedSegmentIndex = 0
        seg.tintColor = UIColor.SELLER_BLUE
        seg.addTarget(self, action: "change:", forControlEvents: .ValueChanged)
        seg.backgroundColor = UIColor.BACKGROUNDCOLOR
        self.seg = seg
        view .addSubview(seg)
//        if UI Device.currentDevice().systemVersion >= 7 { automaticallyAdjustsScrollViewInsets = false }
        
        //tableview
        let myTableView = UITableView.init(frame: CGRect.init(x: 0, y: 124, width: UIView.screenW, height: UIView.screenH - 124))
        self.myTableView = myTableView
        myTableView.separatorStyle = .None
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.backgroundColor = UIColor.BACKGROUNDCOLOR
        myTableView.showsHorizontalScrollIndicator = false
        myTableView.showsVerticalScrollIndicator = false
        view .addSubview(myTableView)
        
        //刷新
        myTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        
        //空状态
        noData = MyObject.noDataView()
        
        //指定一开始的数组
        dataArray = returnArray
        myTableView.reloadData()
    }
    
    //MARK: - 触发Action
    //点击segmented control
    func change(seg:UISegmentedControl){
        if seg.selectedSegmentIndex == 0 {
            dataArray = returnArray
            myTableView!.reloadData()
        }else {
            dataArray = refundArray
            myTableView!.reloadData()
        }
    }
    
    //刷新
    func headerRefresh(){
        
    }
    //MARK: - tableView数据源
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //空状态
        if dataArray!.count == 0 {
            tableView.backgroundView = noData
        } else {
            tableView.backgroundView = nil
        }
        return dataArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = UITableViewCell.init()
        if dataArray?.count != 0{
            
            if seg?.selectedSegmentIndex == 0{
                
            }else {
                
            }
            
//            cell.textLabel?.text = dataArray?.objectAtIndex(indexPath.row) as
        }
        return cell
    }

}
