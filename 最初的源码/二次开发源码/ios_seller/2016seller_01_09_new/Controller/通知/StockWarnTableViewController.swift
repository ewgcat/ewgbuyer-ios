//
//  StockWarnTableViewController.swift
//  2016seller_01_09_new
//
//  Created by shiyuwudi on 16/1/14.
//  Copyright © 2016年 iskyshop. All rights reserved.
//

import Foundation

class StockWarnTableViewController: BaseTableViewControllerNoTabbar {
    
    var dataArray:NSMutableArray?
    var noData:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI(){
        title = "库存预警"
        //设置tableView上拉刷新、下拉加载
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        noData = MyObject.noDataView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArray!.count == 0 {
            tableView.backgroundView = noData
        } else {
            tableView.backgroundView = nil
        }
        return dataArray!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = StockWarningCell.stockWarningCell(tableView)
        cell.model = dataArray![indexPath.row] as? StockWarningModel
        return cell
    }
    
    func headerRefresh() {
        MyNetTool.requestForStockWarningSuccess { (arr:NSMutableArray!) -> Void in
            self.dataArray = arr
            self.tableView.reloadData()
        }
        tableView.mj_header.endRefreshing()
    }
    
}