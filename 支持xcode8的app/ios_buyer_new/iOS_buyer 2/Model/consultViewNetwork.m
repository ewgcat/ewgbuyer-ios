//
//  consultViewNetwork.m
//  My_App
//
//  Created by apple on 15/8/12.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "consultViewNetwork.h"
#import "firstModel.h"

@implementation consultViewNetwork

+(ASIFormDataRequest *)startRequest_url:(NSString  *)url setKey:(NSArray *)keyArray setValue:(NSArray *)valueArr{
    NSURL *url2 = [NSURL URLWithString:url];
    NSLog(@"keyArray:%@",keyArray);
    NSLog(@"valueArr:%@",valueArr);
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url2];
    if (valueArr.count>=keyArray.count) {
        for(int i=0;i<keyArray.count;i++){
            [request setPostValue:[valueArr objectAtIndex:i] forKey:[keyArray objectAtIndex:i]];
        }
    }
    [request setRequestHeaders:[LJControl requestHeaderDictionary]];
    return request;
}
//数据处理
+(NSMutableArray *)dataManage:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"result=%@", dicBig);
    if (dicBig) {
        NSArray *arr = [dicBig objectForKey:@"eva_list"];
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        for(NSDictionary *dic in arr){
            ClassifyModel *model = [[ClassifyModel alloc]init];
            model.ping_addTime = [dic objectForKey:@"addTime"];
            model.ping_content = [dic objectForKey:@"content"];
            model.ping_user = [dic objectForKey:@"user"];
            model.ping_Tie = @"[当天追加]我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评我是追评";
            model.ping_spec = @"我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格我是规格";
            UILabel *labelcontent = [[UILabel alloc]init];
            labelcontent.numberOfLines = 0;
            labelcontent.font = [UIFont systemFontOfSize:14];
            labelcontent.text = model.ping_content;
            CGRect labelFrame = CGRectMake(60, 35, 0.0, 0.0);
            labelFrame.size = [labelcontent sizeThatFits:CGSizeMake(ScreenFrame.size.width-80,  0)];
            [labelcontent setFrame:labelFrame];
            model.ping_height = labelcontent.frame.size.height+35+25;
            [dataArray addObject:model];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataManageCount:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"result=%@", dicBig);
    if (dicBig) {
        NSString *str = [dicBig objectForKey:@"bad"];
        NSArray  * array= [str componentsSeparatedByString:@"-"];
        NSString *str2 = [dicBig objectForKey:@"middle"];
        NSArray  * array2 = [str2 componentsSeparatedByString:@"-"];
        NSString *str3 = [dicBig objectForKey:@"well"];
        NSArray  * array3 = [str3 componentsSeparatedByString:@"-"];
        [dataArray addObject:[array3 objectAtIndex:1]];
        
        NSInteger all = [[array objectAtIndex:0] intValue]+[[array2 objectAtIndex:0] intValue]+[[array3 objectAtIndex:0] intValue];
        [dataArray addObject:[NSString stringWithFormat:@"%ld",(long)all]];
        [dataArray addObject:[NSString stringWithFormat:@"%@",[array3 objectAtIndex:0]]];
        [dataArray addObject:[NSString stringWithFormat:@"%@",[array2 objectAtIndex:0]]];
        [dataArray addObject:[NSString stringWithFormat:@"%@",[array objectAtIndex:0]]];
    }
    return dataArray;
}
+(NSMutableArray *)dataEstimateData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"result_1=%@", dicBig);
    if (dataArray.count!=0) {
        [dataArray removeAllObjects];
    }
    if (dicBig) {
        NSArray *arr = [dicBig objectForKey:@"consult_list"];
        for(NSDictionary *dic in arr){
            ClassifyModel *maodel = [[ClassifyModel alloc]init];
            maodel.ping_addTime = [dic objectForKey:@"addTime"];
            maodel.ping_user = [dic objectForKey:@"consult_user"];
            maodel.ping_content = [dic objectForKey:@"content"];
            maodel.ping_reply = [dic objectForKey:@"reply"];
            if ([[dic objectForKey:@"reply"] intValue] == 1) {
                maodel.ping_reply_content = [dic objectForKey:@"reply_content"];
                maodel.ping_reply_time = [dic objectForKey:@"reply_time"];
                maodel.ping_reply_user = [dic objectForKey:@"reply_user"];
            }
            [dataArray addObject:maodel];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataFloorDataCacheData{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *secontionTitleArray = [[NSMutableArray alloc]init];
    NSMutableArray *secontionArray = [[NSMutableArray alloc]init];
    if([[NSFileManager defaultManager] fileExistsAtPath:HOMEPAGE_INFORMATION_FILEPATH(@"homepage.txt")] == YES){
        NSDictionary *dicBig = [HOMEPAGE_INFORMATION(@"homepage.txt") objectAtIndex:0];
        NSLog(@"dicBig:%@",dicBig);
        if (secontionTitleArray.count!=0) {
            [secontionTitleArray removeAllObjects];
        }
        if (secontionArray.count != 0) {
            [secontionArray removeAllObjects];
        }
        if(dicBig){
            NSArray *arrFloor = [dicBig objectForKey:@"floor_list"];
            for(NSDictionary *dic in arrFloor){
                NSArray *arrCeng = [dic objectForKey:@"lines_info"];
                NSMutableArray *arrcc = [[NSMutableArray alloc]init];
                for(NSDictionary *dicCeng in arrCeng){
                    firstModel *first = [[firstModel alloc]init];
                    
                    first.sequence = [[dicCeng objectForKey:@"sequence"] intValue];
                    first.line_type = [[dicCeng objectForKey:@"line_type"] intValue];
                    first.line_info = [dicCeng objectForKey:@"line_info"];
                    [arrcc addObject:first];
                }
                [secontionTitleArray addObject:[dic objectForKey:@"title"]];
                [secontionArray addObject:arrcc];
            }
        }
        [dataArray addObject:secontionTitleArray];
        [dataArray addObject:secontionArray];
    }
    return dataArray;
}
+(NSMutableArray *)dataFloorData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSMutableArray *secontionTitleArray = [[NSMutableArray alloc]init];
    NSMutableArray *secontionArray = [[NSMutableArray alloc]init];
    //返回code值判断登录是否成功
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dicBig_floor:%@",dicBig);
    

#if 1
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicBig options:NSJSONWritingPrettyPrinted error:&parseError];
        
    NSLog(@"jsonString==%@",[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);

    
#endif
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
                [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            }
        }
        
    });
    
    //保存得到的楼层数据
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"homepage.txt"];
    NSArray *array = [NSArray arrayWithObjects:dicBig, nil];
    [array writeToFile:filePaht atomically:NO];
    
    if(dicBig){
        NSArray *arrFloor = [dicBig objectForKey:@"floor_list"];
        for(NSDictionary *dic in arrFloor){
            NSArray *arrCeng = [dic objectForKey:@"lines_info"];
            NSMutableArray *arrcc = [[NSMutableArray alloc]init];
            for(NSDictionary *dicCeng in arrCeng){
                firstModel *first = [[firstModel alloc]init];
                
                first.sequence = [[dicCeng objectForKey:@"sequence"] intValue];
                first.line_type = [[dicCeng objectForKey:@"line_type"] intValue];
                first.line_info = [dicCeng objectForKey:@"line_info"];
                [arrcc addObject:first];
            }
            [secontionTitleArray addObject:[dic objectForKey:@"title"]];
            [secontionArray addObject:arrcc];
        }
    }
    [dataArray addObject:secontionTitleArray];
    [dataArray addObject:secontionArray];
    return  dataArray;
}
+(NSMutableArray *)dataIndexNavData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"first_nav_dicBig:%@",dicBig);
    if (dataArray.count!=0) {
        [dataArray removeAllObjects];
    }
    if (dicBig) {
        if ([[dicBig objectForKey:@"code"] intValue] == 100) {
            for(int i=1;i<9;i++){
                if ([dicBig objectForKey:[NSString stringWithFormat:@"index_%d",i]]) {
                    [dataArray addObject:[dicBig objectForKey:[NSString stringWithFormat:@"index_%d",i]]];
                }
            }
        }else{
            for(int i=0;i<8;i++){
                [dataArray addObject:[NSString stringWithFormat:@"first_%d",i]];
            }
        }
    }
    
    return dataArray;
}
+(NSMutableArray *)dataIndexAdData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"ad_dicBig:%@",dicBig);
    
    //保存得到的广告数据
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePaht = [documentsPath stringByAppendingPathComponent:@"indexAdData.txt"];
    NSArray *array = [NSArray arrayWithObjects:dicBig, nil];
    [array writeToFile:filePaht atomically:NO];
    
    if (dicBig) {
        if (dataArray.count != 0) {
            [dataArray removeAllObjects];
        }
        for(NSDictionary *dic in [dicBig objectForKey:@"ad_list"]){
            firstModel *first = [[firstModel alloc]init];
            first.click_url = [dic objectForKey:@"click_url"];
            first.index_id = [dic objectForKey:@"click_info"];
            first.img_url = [dic objectForKey:@"img_url"];
            [dataArray addObject:first];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataIndexAdDataCacheData{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    if([[NSFileManager defaultManager] fileExistsAtPath:HOMEPAGE_INFORMATION_FILEPATH(@"indexAdData.txt")] == YES){
        NSDictionary *dicBig = [HOMEPAGE_INFORMATION(@"indexAdData.txt") objectAtIndex:0];
        NSLog(@"dicBig:%@",dicBig);
        if (dicBig) {
            if (dataArray.count != 0) {
                [dataArray removeAllObjects];
            }
            for(NSDictionary *dic in [dicBig objectForKey:@"ad_list"]){
                firstModel *first = [[firstModel alloc]init];
                first.click_url = [dic objectForKey:@"click_url"];
                first.index_id = [dic objectForKey:@"click_info"];
                first.img_url = [dic objectForKey:@"img_url"];
                [dataArray addObject:first];
            }
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataBuyer_eturnListData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([[dicBig objectForKey:@"code"] intValue] == 100) {
        if (dataArray.count!=0) {
            [dataArray removeAllObjects];
        }
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.dingdetail_oid = [dic objectForKey:@"oid"];
            class.dingdetail_order_id = [dic objectForKey:@"order_id"];
            class.dingdetail_goods_maps = [dic objectForKey:@"goods_maps"];
            class.dingdetail_shipTime = [dic objectForKey:@"addTime"];
            class.dingdetail_goods_gsp_ids = [dic objectForKey:@"goods_gsp_ids"];
            [dataArray addObject:class];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataMoney_eturnListData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dicBig：%@",dicBig);
    
    if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
    }else{
        NSArray *arr = [dicBig objectForKey:@"datas"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"group_goods_img"];
            class.goods_name = [dic objectForKey:@"group_goods_name"];
            class.goods_current_price = [dic objectForKey:@"group_goods_price"];
            class.goods_status = [dic objectForKey:@"group_status"];
            class.goods_addTime = [dic objectForKey:@"group_addTime"];
            class.goods_id = [dic objectForKey:@"group_id"];
            class.goods_refund_msg = [dic objectForKey:@"refund_msg"];
            class.goods_sn = [dic objectForKey:@"group_sn"];
            [dataArray addObject:class];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataStore_CouponsListData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
    }else{
        NSArray *arr = [dicBig objectForKey:@"data"];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.coupon_beginTime = [dic objectForKey:@"coupon_begin_time"];
            class.coupon_endTime = [dic objectForKey:@"coupon_end_time"];
            class.coupon_status = [dic objectForKey:@"capture_status"];
            class.coupon_amount = [dic objectForKey:@"coupon_amount"];
            class.coupon_id = [dic objectForKey:@"coupon_id"];
            class.coupon_name = [dic objectForKey:@"coupon_name"];
            class.coupon_info = [dic objectForKey:@"coupon_surplus_amount"];
            class.coupon_pic = [dic objectForKey:@"coupon_pic"];
            class.coupon_order_amount = [dic objectForKey:@"coupon_order_amount"];
            [dataArray addObject:class];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataReveciveCouponsLData:(ASIFormDataRequest *)request{
    NSMutableArray *dataAll = [[NSMutableArray alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"dicBigdicBig:456%@",dicBig);
    if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
    }else{
        NSArray *arr = [dicBig objectForKey:@"goodsData"];
        [dataAll addObject:[NSString stringWithFormat:@"%@",[dicBig objectForKey:@"status"]]];
        for(NSDictionary *dic in arr){
            ClassifyModel *class = [[ClassifyModel alloc]init];
            class.goods_main_photo = [dic objectForKey:@"goods_pic"];
            class.goods_name = [dic objectForKey:@"goods_name"];
            class.goods_current_price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_price"]];
            class.goods_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_id"]];
            [dataArray addObject:class];
        }
    }
    [dataAll addObject:dataArray];
    return dataAll;
}
+(NSMutableArray *)dataClassData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
    }else{
        NSArray *array = [dicBig objectForKey:@"goodsclass_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.classify_className = [dic objectForKey:@"className"];
            classify.classify_icon_path = [dic objectForKey:@"icon_path"];
            classify.classify_id = [dic objectForKey:@"id"];
            classify.classify_children =[dic objectForKey:@"recommend_children"];
            [dataArray addObject:classify];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataClassThreeData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    if ([[dicBig objectForKey:@"ret"] isEqualToString:@"false"]) {
    }else{
        NSArray *array = [dicBig objectForKey:@"goodsclass_list"];
        for(NSDictionary *dic in array){
            ClassifyModel *classify = [[ClassifyModel alloc]init];
            classify.classify_className = [dic objectForKey:@"className"];
            classify.classify_id = [dic objectForKey:@"id"];
            classify.classify_thirdArray = [dic objectForKey:@"third"];
            [dataArray addObject:classify];
        }
    }
    return dataArray;
}
+(NSMutableArray *)dataGoodsListData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"goodsList:%@",dicBig);
    if (dataArray.count!=0) {
        [dataArray removeAllObjects];
    }
    NSArray *array = [dicBig objectForKey:@"goods_list"];
    for(NSDictionary *dic in array){
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        classify.goods_salenum = [dic objectForKey:@"goods_salenum"];
        classify.goods_name = [dic objectForKey:@"goods_name"];
        classify.goods_main_photo = [dic objectForKey:@"goods_main_photo"];
        classify.goods_id = [dic objectForKey:@"id"];
        classify.goods_current_price = [dic objectForKey:@"goods_current_price"];
        classify.goods_status = [dic objectForKey:@"status"];
        classify.goods_evaluate = [dic objectForKey:@"evaluate"];
        [dataArray addObject:classify];
    }
    return dataArray;
}
+(NSMutableArray *)dataFilterData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"goodsList:%@",dicBig);
    if (dataArray.count!=0) {
        [dataArray removeAllObjects];
    }
    NSArray *array = [dicBig objectForKey:@"result"];
    for(NSDictionary *dic in array){
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        classify.goods_name = [dic objectForKey:@"name"];
        classify.goods_id = [dic objectForKey:@"id"];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        [arr addObject:@"全部"];
        [arr addObjectsFromArray:[[dic objectForKey:@"value"] componentsSeparatedByString:@","]];
        
        classify.classify_thirdArray = arr;
        classify.ping_height = 0;
        [dataArray addObject:classify];
    }
    return dataArray;
}

+(NSMutableArray *)dataActivityData:(ASIFormDataRequest *)request{
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"goodsList:%@",dicBig);
    if (dataArray.count!=0) {
        [dataArray removeAllObjects];
    }
    NSArray *array = [dicBig objectForKey:@"result"];
    for(NSDictionary *dic in array){
        ClassifyModel *classify = [[ClassifyModel alloc]init];
        classify.coupon_beginTime = [dic objectForKey:@"ac_beginTime"];
        classify.coupon_endTime = [dic objectForKey:@"ac_endTime"];
        classify.coupon_name = [dic objectForKey:@"ac_title"];
        classify.goods_main_photo = [dic objectForKey:@"picture"];
        classify.goods_id = [dic objectForKey:@"id"];
        classify.goods_goods_spec = [dic objectForKey:@"time_desc"];
        [dataArray addObject:classify];
    }
    return dataArray;
}

+(NSMutableArray *)dataActivityGoodsData:(ASIFormDataRequest *)request{
    NSMutableArray *dataAll = [[NSMutableArray alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    
//    NSString *jsonString = [[NSString alloc] initWithData:request.responseData
//                                                 encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"jsonStringjsonString==%@",jsonString);
    
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"123dicBigdicBig:%@",dicBig);
    if(dicBig){
        if([[dicBig objectForKey:@"code"] intValue] != 404){
            NSArray *arr = [dicBig objectForKey:@"result_goodslist"];
            [dataAll addObject:[dicBig objectForKey:@"result_activtiy"]];
            for(NSDictionary *dic in arr){
                ClassifyModel *class = [[ClassifyModel alloc]init];
                class.goods_main_photo = [dic objectForKey:@"goods_picture"];
                class.goods_name = [dic objectForKey:@"goods_name"];
                class.goods_current_price = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"goods_price"] floatValue]];
                class.goods_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                class.goods_goods_count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goods_salenum"]];
                [dataArray addObject:class];
            }
            
            
            
            [dataAll addObject:dataArray];
            

            
            
           
        }else{
        }
    }
    
    return dataAll;
}
+(NSMutableArray *)dataIntegralRecommendData:(ASIFormDataRequest *)request{
    NSMutableArray *dataAll = [[NSMutableArray alloc]init];
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dicBig =[NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"积分推荐:%@",dicBig);
    if(dicBig){
        NSDictionary *dictMsg = [NSDictionary dictionaryWithObjectsAndKeys:[dicBig objectForKey:@"integral"], @"integral",[dicBig objectForKey:@"user_img"],@"user_img",[dicBig objectForKey:@"ret"],@"ret",[dicBig objectForKey:@"user_level"],@"user_level",[dicBig objectForKey:@"user_level_name"],@"user_level_name",[dicBig objectForKey:@"username"],@"username", nil];
        [dataAll addObject:dictMsg];
        NSArray *array = [dicBig objectForKey:@"recommend_igs"];
        for (NSDictionary *dic in array) {
            Model *shjm = [[Model alloc]init];
            shjm.ig_goods_img = [dic objectForKey:@"ig_goods_img"];
            shjm.ig_goods_integral = [dic objectForKey:@"ig_goods_integral"];
            shjm.ig_goods_name = [dic objectForKey:@"ig_goods_name"];
            shjm.ig_id = [dic objectForKey:@"ig_id"];
            shjm.ig_user_level = [dic objectForKey:@"ig_user_level"];
            shjm.igc_count = [dic objectForKey:@"ig_goods_count"];
            shjm.ig_goods_pay_price=[NSString stringWithFormat:@"%@元",[dic objectForKey:@"ig_goods_pay_price"]]; 
            [dataArray addObject:shjm];
        }
    }
    [dataAll addObject:dataArray];
    return dataAll;
}
@end
