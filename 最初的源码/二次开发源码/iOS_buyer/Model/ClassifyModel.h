//
//  ClassifyModel.h
//  My_App
//
//  Created by apple on 14-7-29.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyModel : NSObject
@property(strong ,nonatomic)NSString *classify_className;
@property(strong ,nonatomic)NSString *classify_icon_path;
@property(strong ,nonatomic)NSString *classify_id;
@property(strong ,nonatomic)NSString *classify_children;
@property(strong ,nonatomic)NSArray *classify_thirdArray;

//Googs
@property(strong ,nonatomic)NSString *goods_current_price;
@property(strong ,nonatomic)NSString *goods_main_photo;
@property(strong ,nonatomic)NSString *goods_name;
@property(strong ,nonatomic)NSString *goods_salenum;
@property(strong ,nonatomic)NSString *goods_id;//
@property(strong ,nonatomic)NSString *goods_status;
@property(strong ,nonatomic)NSString *goods_goods_count;
@property(strong ,nonatomic)NSString *goods_goods_spec;
@property(strong ,nonatomic)NSString *goods_cart_id;
@property(strong ,nonatomic)NSString *goods_cart_price;
@property(strong ,nonatomic)NSString *goods_evaluate;
@property(strong ,nonatomic)NSString *goods_xiangfu;
@property(strong ,nonatomic)NSString *goods_taidu;
@property(strong ,nonatomic)NSString *goods_sudu;
@property(strong ,nonatomic)NSString *goods_pingjiazhi;
@property(strong ,nonatomic)NSString *goods_pingcontent;
@property(strong ,nonatomic)NSString *goods_price1;
@property(strong ,nonatomic)NSString *goods_price2;
@property(strong ,nonatomic)NSString *goods_price3;
@property(strong ,nonatomic)NSString *goods_addTime;
@property(strong ,nonatomic)NSString *goods_sn;
@property(strong ,nonatomic)NSString *goods_refund_msg;
@property(strong ,nonatomic)NSString *goods_oid;
@property(strong ,nonatomic)NSString *goods_total_price;
@property(strong ,nonatomic)NSArray *goods_groupinfos;
@property(strong ,nonatomic)NSString *goods_apply_status;
@property(strong ,nonatomic)NSString *goods_evaluate_status;
@property(strong ,nonatomic)NSString *goods_receiver_address;
@property(strong ,nonatomic)NSString *goods_receiver_mobile;
@property(strong ,nonatomic)NSString *goods_receiver_name;
@property(strong ,nonatomic)NSString *goods_receiver_tel;
@property(strong ,nonatomic)NSString *goods_rid;
@property(strong ,nonatomic)NSString *goods_return_content;
@property(strong ,nonatomic)NSString *goods_self_address;//
@property(strong ,nonatomic)NSString *goods_pay_time;
@property(strong ,nonatomic)NSString *goods_status_msg;
@property(strong ,nonatomic)NSString *goods_inventory;
@property(strong ,nonatomic)NSString *detail_choice_type;

//详情
@property(strong ,nonatomic)NSString *detail_goods_photos_small;
@property(strong ,nonatomic)NSString *detail_goods_current_price;
@property(strong ,nonatomic)NSString *detail_goods_details;
@property(strong ,nonatomic)NSString *detail_goods_inventory;
@property(strong ,nonatomic)NSString *detail_goods_name;
@property(strong ,nonatomic)NSString *detail_goods_photos;
@property(strong ,nonatomic)NSString *detail_goods_price;
@property(strong ,nonatomic)NSString *detail_goods_salenum;
@property(strong ,nonatomic)NSString *detail_id;//
@property(strong ,nonatomic)NSString *detail_inventory_type;
@property(strong ,nonatomic)NSString *detail_status;
@property(strong ,nonatomic)NSString *detail_goods_bad_evaluate;
@property(strong ,nonatomic)NSString *detail_goods_middle_evaluate;
@property(strong ,nonatomic)NSString *detail_goods_well_evaluate;
@property(strong ,nonatomic)NSString *detail_evaluate_count;
@property(strong ,nonatomic)NSString *detail_trans_information;
@property(strong ,nonatomic)NSString *detail_consult_count;
@property(strong ,nonatomic)NSString *detail_current_city;
@property(strong ,nonatomic)NSString *detail_goods_type;
@property(strong,nonatomic)NSString *detail_goodsstatus_info;
//预售商品
@property(strong ,nonatomic)NSString *detail_advance_ding;
@property(strong,nonatomic)NSString *detail_advance_ding_pay;
@property(strong ,nonatomic)NSString *detail_advance_wei;
@property(strong,nonatomic)NSString *detail_ding_pay_end;
@property(strong,nonatomic)NSString *detail_wei_pay_end;
@property(strong,nonatomic)NSString *detail_ship_Date;

@property(strong ,nonatomic)NSString *detail_goods_main_photo;
@property(strong ,nonatomic)NSString *detail_goods_main_name;
@property(strong ,nonatomic)NSString *detail_goods_main_id;
@property(strong ,nonatomic)NSDictionary *detail_store_info;

@property(strong ,nonatomic)NSString *detail_goods_limit;
@property(strong ,nonatomic)NSString *detail_goods_all_count;
@property(strong ,nonatomic)NSString *detail_goods_buy_count;
//规格
@property(strong ,nonatomic)NSString *specifications_spec_key;
@property(strong ,nonatomic)NSString *specifications_spec_type;
@property(strong ,nonatomic)NSArray *specifications_spec_values;

//地区
@property(strong ,nonatomic)NSString *region_id;
@property(strong ,nonatomic)NSString *region_name;

//评价
@property(strong ,nonatomic)NSString *ping_Tie;
@property(strong ,nonatomic)NSString *ping_spec;
@property(strong ,nonatomic)NSString *ping_bad;
@property(strong ,nonatomic)NSString *ping_addTime;
@property(strong ,nonatomic)NSString *ping_content;
@property(strong ,nonatomic)NSString *ping_user;
@property(strong ,nonatomic)NSString *ping_middle;
@property(strong ,nonatomic)NSString *ping_ret;
@property(strong ,nonatomic)NSString *ping_well;
@property(assign ,nonatomic)NSInteger ping_height;
@property(assign ,nonatomic)NSInteger ping_reply_height;
@property(copy ,nonatomic)NSString *ping_reply_content;
@property(copy ,nonatomic)NSString *ping_reply_time;
@property(copy ,nonatomic)NSString *ping_reply_user;
@property(copy ,nonatomic)NSString *ping_reply;
@property(copy ,nonatomic)NSString *ping_user_photo;
@property(copy ,nonatomic)NSString *ping_user_user_id;

//car
@property(copy ,nonatomic)NSString *car_cart_id;
@property(copy ,nonatomic)NSString *car_cart_price;
@property(copy ,nonatomic)NSString *car_goods_count;
@property(copy ,nonatomic)NSString *car_goods_id;
@property(copy ,nonatomic)NSString *car_goods_main_photo;
@property(copy ,nonatomic)NSString *car_goods_name;
@property(copy ,nonatomic)NSString *car_goods_price;
@property(copy ,nonatomic)NSString *car_goods_spec;
@property(copy ,nonatomic)NSString *car_goods_status;
//地址管理
@property(copy ,nonatomic)NSString *manager_addr_id;
@property(copy ,nonatomic)NSString *manager_area;
@property(copy ,nonatomic)NSString *manager_areaInfo;
@property(copy ,nonatomic)NSString *manager_telephone;
@property(copy ,nonatomic)NSString *manager_mobile;
@property(copy ,nonatomic)NSString *manager_trueName;
@property(copy ,nonatomic)NSString *manager_zip;


//配送
@property(copy ,nonatomic)NSArray *peisongList;
@property(copy ,nonatomic)NSString *peisongstore_name;
@property(copy ,nonatomic)NSString *peisongstore_id;
@property(copy ,nonatomic)NSString *peisongvalue;
@property(copy ,nonatomic)NSString *peisonggoods_list;

//优惠劵
@property(copy ,nonatomic)NSString *coupon_addTime;
@property(copy ,nonatomic)NSString *coupon_amount;
@property(copy ,nonatomic)NSString *coupon_beginTime;
@property(copy ,nonatomic)NSString *coupon_endTime;
@property(copy ,nonatomic)NSString *coupon_id;
@property(copy ,nonatomic)NSString *coupon_info;
@property(copy ,nonatomic)NSString *coupon_name;
@property(copy ,nonatomic)NSString *coupon_order_amount;
@property(copy ,nonatomic)NSString *coupon_sn;
@property(copy ,nonatomic)NSString *coupon_status;
@property(copy ,nonatomic)NSString *coupon_pic;
@property(copy,nonatomic)NSString * coupon_store_name;
//订单详情
@property(copy ,nonatomic)NSString *dingdetail_coupon_price;
@property(copy ,nonatomic)NSString *dingdetail_goods_list;
@property(copy ,nonatomic)NSString *dingdetail_goods_price;
@property(copy ,nonatomic)NSString *dingdetail_invoice;
@property(copy ,nonatomic)NSString *dingdetail_invoiceType;
@property(copy ,nonatomic)NSString *dingdetail_order_id;
@property(copy ,nonatomic)NSString *dingdetail_order_status;
@property(copy ,nonatomic)NSString *dingdetail_order_num;
@property(copy ,nonatomic)NSString *dingdetail_order_total_price;
@property(copy ,nonatomic)NSString *dingdetail_payType;
@property(copy ,nonatomic)NSString *dingdetail_receiver_Name;
@property(copy ,nonatomic)NSString *dingdetail_receiver_area;
@property(copy ,nonatomic)NSString *dingdetail_receiver_area_info;
@property(copy ,nonatomic)NSString *dingdetail_receiver_mobile;
@property(copy ,nonatomic)NSString *dingdetail_ship_price;
@property(copy ,nonatomic)NSString *dingdetail_receiver_zip;
@property(copy ,nonatomic)NSString *dingdetail_store_name;
@property(copy ,nonatomic)NSString *dingdetail_oid;
@property(copy ,nonatomic)NSArray *dingdetail_goods_maps;
@property(copy ,nonatomic)NSString *dingdetail_return_can;
@property(copy ,nonatomic)NSString *dingdetail_shipCode;
@property(copy ,nonatomic)NSString *dingdetail_shipTime;
@property(copy ,nonatomic)NSString *dingdetail_express_company;
@property(copy ,nonatomic)NSArray *dingdetail_trans_list;//goods_gsp_ids
@property(copy ,nonatomic)NSString *dingdetail_goods_gsp_ids;
@property(copy ,nonatomic)NSString *dingdetail_order_pay_msg;
@property(copy ,nonatomic)NSString *dingdetail_order_pay_time;

@property(copy ,nonatomic)NSString *trans_message;
@property(copy ,nonatomic)NSString *trans_status;
@property(copy ,nonatomic)NSString *trans_content;
@property(copy ,nonatomic)NSString *trans_time;

@property (copy,nonatomic) NSString *store_id;
@property (copy,nonatomic) NSString *store_name;
@property (copy,nonatomic) NSString *store_store_logo;

//零元购
@property (copy,nonatomic) NSString *free_acc;
@property (copy,nonatomic) NSString *free_id;
@property (copy,nonatomic) NSString *free_count;
@property (copy,nonatomic) NSString *free_name;
@property (copy,nonatomic) NSString *free_price;

//Detail零元购
@property (copy,nonatomic) NSString *freeDetail_apply_count;
@property (copy,nonatomic) NSString *freeDetail_current_count;
@property (copy,nonatomic) NSString *freeDetail_default_count;
@property (copy,nonatomic) NSString *freeDetail_endTime;
@property (copy,nonatomic) NSString *freeDetail_free_acc;
@property (copy,nonatomic) NSString *freeDetail_free_details;
@property (copy,nonatomic) NSString *freeDetail_free_id;
@property (copy,nonatomic) NSString *freeDetail_free_name;
@property (copy,nonatomic) NSString *freeDetail_free_price;

@end