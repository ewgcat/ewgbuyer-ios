//
//  StoreWideMessageViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/13.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class StoreWideMessageViewController: BaseTableViewControllerNoTabbar {
    
    var dataArray:NSMutableArray?
    var clickDict:[NSIndexPath:Bool]?
    var loadCount:Int?
    var noData:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI () {
        title = "站内信"
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.separatorStyle = .None
        
        loadCount = 0
        clickDict = [:]
        
        //设置tableView上拉刷新、下拉加载
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        
        noData = MyObject.noDataView()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray!.count == 0 {
            tableView.backgroundView = noData
        } else {
            tableView.backgroundView = nil
        }
        return dataArray!.count
    }
    
    func footerLoadMore () {
        
        loadCount! += 20
        let loadCountStr = String(loadCount)
        print(loadCountStr)
        
        MyNetTool.requestForMessageSelectCount(loadCountStr) { (arr:NSMutableArray!) -> Void in
            self.dataArray = arr
            self.tableView.reloadData()
        }
        tableView.mj_footer.endRefreshing()
    }
    
    func headerRefresh() {
        MyNetTool.requestForMessageSelectCount("20") { (arr:NSMutableArray!) -> Void in
            self.dataArray = arr
            self.tableView.reloadData()
        }
        tableView.mj_header.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var selected:Bool
        
        if clickDict![indexPath] != nil {
            selected = clickDict![indexPath]! as Bool
        }else {
            selected = false
        }
        
        let cell = StoreMsgCell.storeMsgCell(tableView,btnSelect: selected)
        let model = dataArray![indexPath.row] as! StoreMsgModel
        cell.model = model
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! StoreMsgCell
        cell.arrowBtn.selected = !cell.arrowBtn.selected
        clickDict![indexPath] = cell.arrowBtn.selected
        tableView.reloadData()
    }
    
}