//
//  WDNearStoreManager.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDNearStoreManager.h"

@implementation WDNearStoreManager

+ (void)requestNearStoreWithStoreclasses:(NSString *)category storeorder:(NSString *)order storesate:(NSString *)state currentPage:(NSString *)page completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/stores/Load?access_token=%@&storeclasses=%@&storeorder=%@&storesate=%@&currentpage=%@",API_PORT,token,category,order,state,page];
    NSLog(@"request near store url is %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"request near store data is %@",responseObject);
        NSMutableArray *allDataArray;
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 1、全部商家/优惠商家
            NSDictionary *storesate = responseObject[@"storesate"];
            NSString *storesateRet = storesate[@"ret"];
            NSMutableArray *stateArray = [NSMutableArray array];
            if ([storesateRet isEqualToString:@"0"]) {
                
                NSArray *dataArray = storesate[@"data"];
                for (NSDictionary *modelDic in dataArray) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:modelDic];
                    [stateArray addObject:model];
                }
            }
            
            // 2、左边分类
            NSDictionary *storeclasses = responseObject[@"storeclasses"];
            NSString *storeclassesRet = storeclasses[@"ret"];
            NSMutableArray *classesArray = [NSMutableArray array];
            if ([storeclassesRet isEqualToString:@"0"]) {
                
                NSArray *dataArray = storeclasses[@"data"];
                for (NSDictionary *modelDic in dataArray) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:modelDic];
                    [classesArray addObject:model];
                }
            }
            
            // 3、右边分类
            NSDictionary *storeorder = responseObject[@"storeorder"];
            NSString *storeorderRet = storeorder[@"ret"];
            NSMutableArray *orderArray = [NSMutableArray array];
            if ([storeorderRet isEqualToString:@"0"]) {
                
                NSArray *dataArray = storeorder[@"data"];
                for (NSDictionary *modelDic in dataArray) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:modelDic];
                    [orderArray addObject:model];
                }
            }
            
            // 4、单元格数据
            NSDictionary *stores = responseObject[@"stores"];
            NSString *storesRet = stores[@"ret"];
            NSMutableArray *storesArray = [NSMutableArray array];
            if ([storesRet isEqualToString:@"0"]) {
                
                NSArray *dataArray = stores[@"data"];
                for (NSDictionary *modelDic in dataArray) {
                    
                    WDNearbyStoreModel *model = [[WDNearbyStoreModel alloc]initWithDictionary:modelDic];
                    [storesArray addObject:model];
                }
            }
            
            allDataArray = [NSMutableArray arrayWithObjects:stateArray,classesArray,orderArray,storesArray, nil];
            
            if (complete) {
                
                complete(allDataArray,nil);
            }
            
        }
        else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

/** 店铺详情*/
+ (void)requestStoreInfosWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesinfo2/Load?access_token=%@&storeid=%@",API_PORT,token,storeId];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *bigArray;
        NSMutableArray *storeInfosArray = [NSMutableArray array];
        NSMutableArray *storeCatesArray = [NSMutableArray array];
        NSLog(@" requestStoreInfosWithStoreId %@",responseObject);
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]){
            
            NSDictionary *storesinfo = responseObject[@"storesinfo"];
            WDStoreInfosModel *model = [[WDStoreInfosModel alloc]initWithDictionary:storesinfo];
            [storeInfosArray addObject:model];
            
            NSDictionary *storescategories = responseObject[@"storescategories"];
            NSString *storescategoriesRet = storescategories[@"ret"];
            if ([storescategoriesRet isEqualToString:@"0"]) {
                
                NSArray *datas = storescategories[@"data"];
                for (NSDictionary *modelDic in datas) {
                    
                    WDStoreInfoCatesModel *cateModel = [[WDStoreInfoCatesModel alloc]initWithDictionary:modelDic];
                    [storeCatesArray addObject:cateModel];
                }
            }
         
            bigArray = [NSMutableArray arrayWithObjects:storeInfosArray,storeCatesArray, nil];
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 店铺详情-净菜区/配送区*/
+ (void)requestStoreInfosWithStoreId:(NSString *)storeId sate:(NSString *)sate completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesinfo2/Load?access_token=%@&storeid=%@&sate=%@",API_PORT,token,storeId,sate];
    
    NSLog(@"requestStoreInfosWithStoreId   url ======%@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *bigArray;
        NSMutableArray *storeInfosArray = [NSMutableArray array];
        NSMutableArray *storeCatesArray = [NSMutableArray array];
        NSLog(@"requestStoreInfosWithStoreId %@  url ======%@",responseObject,urlStr);
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]){
            
            NSDictionary *storesinfo = responseObject[@"storesinfo"];
            WDStoreInfosModel *model = [[WDStoreInfosModel alloc]initWithDictionary:storesinfo];
            [storeInfosArray addObject:model];
            
            NSDictionary *storescategories = responseObject[@"storescategories"];
            NSString *storescategoriesRet = storescategories[@"ret"];
            if ([storescategoriesRet isEqualToString:@"0"]) {
                
                NSArray *datas = storescategories[@"data"];
                for (NSDictionary *modelDic in datas) {
                    
                    WDStoreInfoCatesModel *cateModel = [[WDStoreInfoCatesModel alloc]initWithDictionary:modelDic];
                    [storeCatesArray addObject:cateModel];
                }
            }
            
            bigArray = [NSMutableArray arrayWithObjects:storeInfosArray,storeCatesArray, nil];
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 加载店铺详情优惠券*/
+ (void)requestStoreInfoCouponsWithStoreId:(NSString *)storeid completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/coupons/Loadstore?access_token=%@&storeid=%@",API_PORT,token,storeid];
    NSLog(@"request store coupons url is %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"request store coupons data is %@",responseObject);
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *modelArr = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDMyCouponModel *model = [[WDMyCouponModel alloc] initWithDictionary:dic];
                [modelArr addObject:model];
            }
            
            if (complete) {
                
                complete(modelArr,nil);
            }
            
        }
        else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 领取优惠券*/
+ (void)requestGetCouponWithCouponid:(NSString *)couponid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/coupons/Receive?access_token=%@&couponid=%@",API_PORT,token,couponid];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString * msg = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(msg, nil);
            }
        }
        else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 店铺产品信息及搜索*/
+ (void)requestProductInfosWithStoreId:(NSString *)storeId cateId:(NSString *)cateId searchKey:(NSString *)searchKey completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesinfo/LoadProducts?access_token=%@&storeid=%@&cateid=%@&searchkey=%@",API_PORT,token,storeId,cateId,searchKey];
    NSString *cordingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:cordingStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArray = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]){
            
            NSArray *datas = responseObject[@"data"];
            for (NSDictionary *dic in datas) {
                
                WDSearchInfosModel *model = [[WDSearchInfosModel alloc]initWithDictionary:dic];
                [datasArray addObject:model];
            }
            
            if (complete) {
                
                complete(datasArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

/** 店铺产品信息-净菜区/配送区*/
+ (void)requestProductInfosWithStoreId:(NSString *)storeId cateId:(NSString *)cateId searchKey:(NSString *)searchKey sate:(NSString *)sate completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/storesinfo/LoadProducts?access_token=%@&storeid=%@&cateid=%@&searchkey=%@&sate=%@",API_PORT,token,storeId,cateId,searchKey,sate];
    NSString *cordingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:cordingStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArray = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]){
            
            NSArray *datas = responseObject[@"data"];
            for (NSDictionary *dic in datas) {
                
                WDSearchInfosModel *model = [[WDSearchInfosModel alloc]initWithDictionary:dic];
                [datasArray addObject:model];
            }
            
            if (complete) {
                
                complete(datasArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 选择配送时间*/
+ (void)requestChoiceSendTimeWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/distributiontime/Load?access_token=%@&storeid=%@",API_PORT,token,storeId];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArray = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]){
            
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                
                WDSendTimeModel *model = [[WDSendTimeModel alloc] initWithDictionary:dic];
                [datasArray addObject:model];
            }
            if (complete) {
                
                complete(datasArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];

}

/** 选择优惠券*/
+ (void)requestDiscountWithStoreId:(NSString *)storeId completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/coupons/Loadstore?access_token=%@&storeid=%@",API_PORT,token,storeId];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"%@",responseObject);
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArray = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]){
            
//            NSArray *array = responseObject[@"data"];
//            for (NSDictionary *dic in array) {
//                
//                WDSendTimeModel *model = [[WDSendTimeModel alloc] initWithDictionary:dic];
//                [datasArray addObject:model];
//            }
//            if (complete) {
//                
//                complete(datasArray,nil);
//            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

/** 提交订单*/
+ (void)requestSubmitOrderWithAddressId:(NSString *)addressid autoTimeId:(NSString *)autotimeid orderInfo:(NSString *)orderinfo buyyerMark:(NSString *)mark completion:(void(^)(NSString *osn,NSString *paysn, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/orders/SubmitOrder?access_token=%@&addressid=%@&autotimeid=%@&order_info=%@&buyerremark=%@",API_PORT,token,addressid,autotimeid,orderinfo,mark];
    NSString *cordingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:cordingStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *result1 = responseObject[@"osn"];
            NSString *result2 = responseObject[@"paysn"];
            if (complete) {
                
                complete(result1,result2,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 店铺详情编辑收藏*/
+ (void)requestEditCollectWithStoreorId:(NSString *)storeorid completion:(void(^)(NSString *state, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/favorite/EditBystoreorid?storeorid=%@&access_token=%@",API_PORT,storeorid,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *hasfavorite = responseObject[@"hasfavorite"];
            if (complete) {
                
                complete(hasfavorite,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 根据订单号获取支付报文签名*/
+ (void)requestSignWordWithPayType:(NSString *)paytype oid:(NSString *)oid signType:(NSString *)sntype completion:(void(^)(NSString *signStr, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/pay/SignOrder?access_token=%@&paytype=%@&sntype=%@&sn=%@",API_PORT,token,paytype,sntype,oid];
    NSString *cordingStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:cordingStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *signOrderStr = responseObject[@"signOrderStr"];
            if (complete) {
                
                complete(signOrderStr,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil, error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];
}

@end
