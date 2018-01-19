//
//  CloudSearchViewController.swift
//  My_App
//
//  Created by shiyuwudi on 16/2/17.
//  Copyright © 2016年 shiyuwudi. All rights reserved.
//

import UIKit
import Alamofire
//import ReactiveCocoa

class CloudSearchViewController: BaseTableViewControllerNoTabBarWithEmptySet,UISearchResultsUpdating,OneYuanGoodsCellDelegate {
    
    lazy var topView = UIView()
    lazy var frameView = UIView()
    lazy var searchBtn = UIButton()
    lazy var textField = UITextField()
    lazy var dataArray = NSMutableArray()
    
    var count = 10
    let more = 10
    
    lazy var searchController = UISearchController(searchResultsController: nil)

    
    //MARK:- 点击事件
    func cartBtnClicked(){
        
        SYObject.checkLogin(navigationController) { (log) -> Void in
            if log {
                self.navigationController?.pushViewController(OneYuanCartTableViewController(), animated: true)
            }
        }
    }
    
    func addToCartBtnClicked(cell: OneYuanGoodsCell!) {
        let model = cell.model
        SYShopAccessTool.addToCartWithLotteryID(model.id, count: model.cloudPurchaseGoods.least_rmb)
    }
    
    //MARK:- table view
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        searchController.view.endEditing(true)
        let model = dataArray[indexPath.row] as! OneYuanModel
        let detailVC = CloudPurchaseGoodsDetailViewController()
        detailVC.ID = model.id;
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return OneYuanGoodsCell.cellHeight()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID = "OneYuanGoodsCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? OneYuanGoodsCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("OneYuanGoodsCell", owner: self, options: nil).last as? OneYuanGoodsCell
        }
        cell!.selectionStyle = .None
        let model = dataArray[indexPath.row] as! OneYuanModel
        cell!.model = model
        cell?.delegate = self
        return cell!
    }
    
    //MARK:- 下拉刷新,上拉加载
    func headerRefresh() {
        count = 10
        tableView.headerEndRefreshing()
        NetTool.searchGoodsName(title!, selectCount: 10) { (newArray) -> Void in
            self.dataArray = newArray
            self.tableView.reloadData()
        }
    }
    
    func footerRefresh() {
        tableView.footerEndRefreshing()
        count += more
        NetTool.searchGoodsName(title!, selectCount: count) { (newArray) -> Void in
            self.dataArray = newArray
            self.tableView.reloadData()
        }
    }
    
    //MARK:- 视图的生命周期方法
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hideSearch()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        addSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- UI
    func setupUI () {
        self.title = "搜索商品"
        tableView.addHeaderWithTarget(self, action: "headerRefresh")
        tableView.addFooterWithTarget(self, action: "footerRefresh")
        addCartBtn()
    }
    
    func addCartBtn(){
        let cartBtn = UIButton(type: .Custom)
        cartBtn.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        cartBtn.setBackgroundImage(UIImage(named: "cart_icon.png"), forState: .Normal)
        cartBtn.addTarget(self, action: "cartBtnClicked", forControlEvents: .TouchUpInside)
        let bbi = UIBarButtonItem(customView: cartBtn)
        navigationItem.rightBarButtonItems = [bbi]
    }
    
    func hideSearch(){
        searchController.view.hidden = true
    }
    
    func showSearch(){
        searchController.view.hidden = false
    }
    
    func addSearch(){
        searchController.searchResultsUpdater = self;
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.searchBarStyle = .Minimal
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.searchBar.returnKeyType = .Done
    }
    
    //MARK:- search delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        dataArray.removeAllObjects()
        let text = searchController.searchBar.text
        if text == nil || text == ""{
            return
        }
        title = text
        NetTool.searchGoodsName(text!, selectCount: 10) { (dataArray) -> Void in
            self.dataArray = dataArray
            self.tableView.performSelectorOnMainThread("reloadData", withObject: nil, waitUntilDone: true)
        }
    }
    
}


