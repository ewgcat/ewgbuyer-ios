//
//  FormulaTableViewController.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/24.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit

class FormulaTableViewController: BaseTableViewControllerNoTabBarWithEmptySet, FormulaCellDelegate {
    
    var lotteryID : String!
    var lottery : CloudPurchaseLottery!
    lazy var showMore = false
    var model : FormulaModel?
    var dataArray : [AnyObject]?

    // MARK: - 生命周期
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        request()
    }
    
    // MARK: - 网络请求
    func request(){
        showMore = false
        model = FormulaModel()
        SYShopAccessTool.getLatest50WithLotteryID(lotteryID) { (arr) -> Void in
            if let arr = arr {
                self.dataArray = arr
                
                let titleRecord = CloudWinnerRecord()
                titleRecord.payTime = "夺宝时间"
                //                    titleRecord.payTimeStamp = ""
                titleRecord.user_name = "用户账号"
                self.dataArray?.insert(titleRecord, atIndex: 0)
                
                self.tableView.reloadData()
            }
        }
        Requester.postWithLastURL(CLOUDPURCHASE_GOODSDETAIL_URL, par: ["lottery_id": lotteryID], description: "商品详情") { (dict) -> Void in
            if let dict1 = dict["data"] as? NSDictionary {
                let l = CloudPurchaseLottery.yy_modelWithDictionary(dict1 as [NSObject : AnyObject])
                self.lottery = l
                self.model = FormulaModel(lottery: l)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI
    func setupUI(){
        title = "计算详情"
        tableView.backgroundColor = UIColor.normalGray
        tableView.headerViewForSection(0)?.backgroundColor = UIColor.normalGray
        tableView.addHeaderWithTarget(self, action: "headerRefresh")
        
        if tableView.respondsToSelector("setSeparatorInset:") {
            tableView.separatorInset = UIEdgeInsetsZero
        }
        if tableView.respondsToSelector("setLayoutMargins:") {
            tableView.layoutMargins = UIEdgeInsetsZero
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 下拉刷新数据
    func headerRefresh(){
        tableView.headerEndRefreshing()
        request()
    }
    
    // MARK: - 点击事件
    func clickForMoreButtonClicked(cell: FormulaCell2) {
        showMore = !showMore
        model?.showMore = showMore
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 10
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            showMore = !showMore
            model?.showMore = showMore
            tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if showMore {
            
            switch (indexPath.section, indexPath.row) {
                
            case (0,0):
                return FormulaCell1.cellHeight()
                
            case (0,1):
                return FormulaCell2.cellHeight()
                
            case (0, dataArray!.count + 2):
                return FormulaCell2.cellHeight()
                
            case (1,0):
                return FormulaCell4.cellHeight()
                
            case (0,let index):
                let record = dataArray![index - 2] as! CloudWinnerRecord
                return FormulaCell3.cellHeightWithModel(record, index: index - 2)
                
            default:
                break
                
            }
            
        } else {
            
            switch (indexPath.section, indexPath.row) {
                
            case (0,0):
                return FormulaCell1.cellHeight()
                
            case (0,1):
                return FormulaCell2.cellHeight()
                
            case (0,2):
                return FormulaCell2.cellHeight()
                
            case (1,0):
                return FormulaCell4.cellHeight()
                
            default:
                break
                
            }
            
        }
        
        return 0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows = 0
        
        switch (section, self.showMore) {
            
        case (0, true):
            guard let count = dataArray?.count else{
                rows = 3
                break
            }
            rows = count + 3
            
        case (0, false):
            rows = 3
            
        case (1, _):
            rows = 1
            
        default:
            break
            
        }
        
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if showMore {
            
            switch (indexPath.section, indexPath.row) {
                
            case (0,0):
                let cell = FormulaCell1.cellWithTableView(tableView, identifier: "FormulaCell1") as! FormulaCell1
                cell.model = model
                return cell
                
            case (0,1):
                let cell = FormulaCell2.cellWithTableView(tableView, identifier: "FormulaCell2") as! FormulaCell2
                model?.type = .a
                cell.model = model
                cell.delegate = self
                return cell
                
            case (0, dataArray!.count + 2):
                let cell = FormulaCell2.cellWithTableView(tableView, identifier: "FormulaCell2") as! FormulaCell2
                model?.type = .b
                cell.model = model
                return cell
                
            case (1,0):
                let cell = FormulaCell4.cellWithTableView(tableView, identifier: "FormulaCell4") as! FormulaCell4
                cell.model = model
                return cell
                
            case (0,let index):
                let cell = FormulaCell3.cellWithTableView(tableView, identifier: "FormulaCell3") as! FormulaCell3
                cell.model = dataArray![index - 2] as? CloudWinnerRecord
                return cell
                
            default:
                break
                
            }
            
        } else {
            
            switch (indexPath.section, indexPath.row) {
                
            case (0,0):
                let cell = FormulaCell1.cellWithTableView(tableView, identifier: "FormulaCell1") as! FormulaCell1
                cell.model = model
                return cell
                
            case (0,1):
                let cell = FormulaCell2.cellWithTableView(tableView, identifier: "FormulaCell2") as! FormulaCell2
                model?.type = .a
                cell.model = model
                cell.delegate = self
                return cell
                
            case (0,2):
                let cell = FormulaCell2.cellWithTableView(tableView, identifier: "FormulaCell2") as! FormulaCell2
                model?.type = .b
                cell.model = model
                return cell
                
            case (1,0):
                let cell = FormulaCell4.cellWithTableView(tableView, identifier: "FormulaCell4") as! FormulaCell4
                cell.model = model
                return cell
                
            default:
                break
                
            }
            
        }
        
        return UITableViewCell()
        
    }

    
    
    
}
