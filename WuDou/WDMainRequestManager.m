//
//  WDMainRequestManager.m
//  WuDou
//
//  Created by huahua on 16/9/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMainRequestManager.h"

@implementation WDMainRequestManager

#pragma mark - 首页整个请求
+ (void)requestMainDatasWithCompletion:(void(^)(NSMutableArray *array, NSString *countDown, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/home/Load?access_token=%@&storeclasses",API_PORT,token];
    NSLog(@"main url is %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"main view data is %@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            NSMutableArray *allDatasArray;
        // 1. 解析广告数据
            NSMutableArray *array1 = [NSMutableArray array];
            NSMutableArray *array2 = [NSMutableArray array];
            NSMutableArray *array3 = [NSMutableArray array];
            NSMutableArray *array4 = [NSMutableArray array];
            NSMutableArray *array5 = [NSMutableArray array];
            NSMutableArray *AdverArray = [NSMutableArray arrayWithObjects:array1,array2,array3,array4,array5, nil];
            for (int i = 1; i < 6; i ++) {
                
                NSString *dicKey = [NSString stringWithFormat:@"adverts%d",i];
                NSDictionary *adverDic = responseObject[dicKey];
                NSString *adverRet = adverDic[@"ret"];
                if ([adverRet isEqualToString:@"0"]) {
                    
                    NSArray *datas = adverDic[@"data"];
                    for (NSDictionary *modelDic in datas) {
                        
                        WDAdvertisementModel *model = [[WDAdvertisementModel alloc]initWithDictionary:modelDic];
                        NSMutableArray *modelArray = AdverArray[i-1];
                        [modelArray addObject:model];
                    }
                }
            }
            
        // 2. 解析特价商品数据
            NSDictionary *special = responseObject[@"products_lower"];
            NSString *specialRet = special[@"ret"];
            NSString *countd = special[@"countdown"];
            NSMutableArray *specialArray = [NSMutableArray array];
            if ([specialRet isEqualToString:@"0"]) {
                
                NSArray *datasArray = special[@"data"];
                for (NSDictionary *modelDic in datasArray) {
                    
                    WDSpecialPriceModel *model = [[WDSpecialPriceModel alloc]initWithDictionary:modelDic];
                    [specialArray addObject:model];
                }
            }
            
        // 3. 解析附近店铺数据
            NSDictionary *nearBy = responseObject[@"stores_nearby"];
            NSString *nearByRet = nearBy[@"ret"];
            NSMutableArray *nearByArray = [NSMutableArray array];
            if ([nearByRet isEqualToString:@"0"]) {
                
                NSArray *datasArray = nearBy[@"data"];
                for (NSDictionary *modelDic in datasArray) {
                    
                    WDNearbyStoreModel *model = [[WDNearbyStoreModel alloc]initWithDictionary:modelDic];
                    [nearByArray addObject:model];
                }
            }
            
        // 4. 解析优选商品数据
            NSDictionary *goodChoice = responseObject[@"products_best"];
            NSString *goodChoiceRet = goodChoice[@"ret"];
            NSMutableArray *goodChoiceArray = [NSMutableArray array];
            if ([goodChoiceRet isEqualToString:@"0"]) {
                
                NSArray *datasArray = goodChoice[@"data"];
                for (NSDictionary *modelDic in datasArray) {
                    
                    WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc]initWithDictionary:modelDic];
                    [goodChoiceArray addObject:model];
                }
            }
//            解析精彩推荐的商品和广告
            NSDictionary *recommend_stores = responseObject[@"products_competitive"];
            NSMutableArray *recommendAdList = [[NSMutableArray alloc] init];
           
            
            NSArray *adList = recommend_stores[@"Adverts"];
            for (NSDictionary *adDic in adList) {
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc]initWithDictionary:adDic];
                [recommendAdList addObject:model];
            }
            NSArray *adList2 = recommend_stores[@"Adverts2"];
            for (NSDictionary *adDic in adList2) {
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc]initWithDictionary:adDic];
                [recommendAdList addObject:model];
            }
            NSArray *adList3 = recommend_stores[@"Adverts3"];
            for (NSDictionary *adDic in adList3) {
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc]initWithDictionary:adDic];
                [recommendAdList addObject:model];
            }
            NSArray *firstReList = recommend_stores[@"data"];
            NSMutableArray *firstGoodsList = [[NSMutableArray alloc] init];
            for (NSDictionary *reDic in firstReList) {
                WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc]initWithDictionary:reDic];
                [firstGoodsList addObject:model];
            }
            NSArray *secondReList = recommend_stores[@"data2"];
            NSMutableArray *secondGoodsList = [[NSMutableArray alloc] init];
            for (NSDictionary *reDic in secondReList) {
                WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc]initWithDictionary:reDic];
                [secondGoodsList addObject:model];
            }
            
            NSArray *thirdReList = recommend_stores[@"data3"];
            NSMutableArray *thirdGoodsList = [[NSMutableArray alloc] init];
            for (NSDictionary *reDic in thirdReList) {
                WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc]initWithDictionary:reDic];
                [thirdGoodsList addObject:model];
            }
//            所有精品推荐分区商品数组
            NSMutableArray *recommendGoodArray = [NSMutableArray arrayWithObjects:firstGoodsList,secondGoodsList,thirdGoodsList, nil];
            NSDictionary *recommentData = @{@"adverts":recommendAdList,@"goodsList":recommendGoodArray};
        // 5. 解析热点数据
            NSDictionary *news = responseObject[@"news"];
            NSString *newsRet = news[@"ret"];
            NSMutableArray *newsArray = [NSMutableArray array];
            if ([newsRet isEqualToString:@"0"]) {
                
                NSString *isshow = news[@"isshow"];
                if ([isshow isEqualToString:@"0"]) {  //有热点
                    
                    NSArray *data = news[@"data"];
                    for (NSDictionary *dic in data) {
                        
                        WDNewsModel *model = [[WDNewsModel alloc] initWithDictionary:dic];
                        [newsArray addObject:model];
                    }
                }
            }
            
            allDatasArray = [NSMutableArray arrayWithObjects:AdverArray,specialArray,nearByArray,goodChoiceArray,newsArray,recommentData, nil];
            if (complete) {
                
                complete(allDatasArray,countd, nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
         NSLog(@"error = %@", error);
    }];
}

+ (void)requestNearByShopMenuCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/home2/LoadType?access_token=%@",API_PORT,token];
    NSLog(@"requestNearByShopMenuCompletion url %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"requestNearByShopMenuCompletion  %@",responseObject);
        
       
        NSArray *list = (NSArray *)responseObject;
        NSMutableArray *mutaArray = [[NSMutableArray alloc] initWithArray:list];
            if (complete) {
                
                complete(mutaArray,nil);
            }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}
#pragma mark - 首页广告列表
+ (void)requestAdvertsCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/Adverts/List?access_token=%@&type=0",API_PORT,token];
    NSLog(@"requestAdvertsCompletion url %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"requestAdvertsCompletion  %@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            //            NSDictionary *storeDic = responseObject[@"stores"];
            //            NSArray *storesList = storeDic[@"data"];
            //            NSMutableArray *storesArray = [[NSMutableArray alloc] init];
            //            for (NSDictionary *storeData in storesList) {
            //                WDNearbyStoreModel *model = [[WDNearbyStoreModel alloc] initWithDictionary:storeData];
            //                [storesArray addObject:model];
            //            }
            //
            //            if (complete) {
            //
            //                complete(storesArray,nil);
            //            }
            //
            
            
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}
#pragma mark - 首页精品推荐列表
+ (void)requestRecommentGoodsCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/home2/Loadproducts_best?access_token=%@",API_PORT,token];
    NSLog(@"requestNearByShopMenu url %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"requestNearByShopMenu  %@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
//            NSDictionary *storeDic = responseObject[@"stores"];
//            NSArray *storesList = storeDic[@"data"];
//            NSMutableArray *storesArray = [[NSMutableArray alloc] init];
//            for (NSDictionary *storeData in storesList) {
//                WDNearbyStoreModel *model = [[WDNearbyStoreModel alloc] initWithDictionary:storeData];
//                [storesArray addObject:model];
//            }
//            
//            if (complete) {
//                
//                complete(storesArray,nil);
//            }
//          
            
            
           
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}
#pragma mark - 首页商品分类列表
+ (void)requestNearByShopMenuWithType:(NSString *)type completion:(void(^)(NSMutableArray *array,NSMutableArray* typeArray, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/home2/Load?access_token=%@&type=%@",API_PORT,token,type];
    NSLog(@"requestNearByShopMenu url %@",urlStr);
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSLog(@"requestNearByShopMenu  %@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *storeDic = responseObject[@"stores"];
            NSArray *storesList = storeDic[@"data"];
            NSMutableArray *storesArray = [[NSMutableArray alloc] init];
            for (NSDictionary *storeData in storesList) {
                WDNearbyStoreModel *model = [[WDNearbyStoreModel alloc] initWithDictionary:storeData];
                [storesArray addObject:model];
            }
            
            
            NSArray *typeList = responseObject[@"type"];
            
            
            if (complete) {
                
                complete(storesArray,typeList,nil);
            }
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 商品详情
+ (void)requestGoodsMsgWithGoodsId:(NSString *)goodsId completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/products/Load?access_token=%@&pid=%@",API_PORT,token,goodsId];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *goodsInfoArr = [NSMutableArray array];
        NSMutableArray *storeInfoArr = [NSMutableArray array];
        NSMutableArray *bigArr;
        NSLog(@"%@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"productsinfo"];
            NSString *productsinfoRet = responseObject[@"ret"];
            if ([productsinfoRet isEqualToString:@"0"]) {
                
                WDGoodsMsgModel *model = [[WDGoodsMsgModel alloc]initWithDictionary:productsinfo];
                [goodsInfoArr addObject:model];
            }
            
            NSDictionary *storesinfo = responseObject[@"storesinfo"];
            NSString *storesinfoRet = storesinfo[@"ret"];
            if ([storesinfoRet isEqualToString:@"0"]) {
                
                WDStoreMsgModel *model = [[WDStoreMsgModel alloc]initWithDictionary:storesinfo];
                [storeInfoArr addObject:model];
            }
            
            bigArr = [NSMutableArray arrayWithObjects:goodsInfoArr,storeInfoArr, nil];
            
            if (complete) {
                
                complete(bigArr,nil);
            }
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
         NSLog(@"error = %@", error);
    }];
}

#pragma mark - 产品详情下面-页面评价
+ (void)requestJudgementsWithPid:(NSString *)pid completion:(void(^)(NSMutableArray *array, NSString *error))complete{
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/productreviews/Load?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"requestJudgementsWithPid data is %@",responseObject);
        NSString * ret  = [responseObject objectForKey:@"ret"];
        NSMutableArray *bigArray;
        if ([ret isEqualToString:@"0"]) {
            
            NSString *treviewscount = responseObject[@"treviewscount"];
            NSString *percentage = responseObject[@"percentage"];
            NSArray *data = responseObject[@"data"];
            
            NSMutableArray *layoutArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                
                WDJudgeModel *model = [[WDJudgeModel alloc] initWithDictionary:dic];
                WDCellLayout *layout = [[WDCellLayout alloc] init];
                layout.judgeModel = model;
                [layoutArray addObject:layout];
            }
            
            bigArray = [NSMutableArray arrayWithObjects:treviewscount,percentage,layoutArray, nil];
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 产品搜索
+ (void)requestSearchProductsWithSearchKey:(NSString *)searchKey completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@api/search/Load?access_token=%@&searchkey=%@",API_PORT,token,searchKey];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        NSMutableArray *bigArray;
        NSLog(@"get = %@",responseObject);
        if ([ret isEqualToString:@"0"]){
            
            NSString * productscount = responseObject[@"productscount"];
            NSString * storescount = responseObject[@"storescount"];
            
            NSMutableArray *modelArray = [NSMutableArray array];
            NSMutableArray * goodArray = [NSMutableArray array];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary * modelDic in data)
            {
                WDSearchResultModel * model = [[WDSearchResultModel alloc]initWithDictionary:modelDic];
                [modelArray addObject:model];
                NSDictionary * dic = modelDic[@"stores_products"];
                NSMutableArray * dataArr = dic[@"subdata"];
                NSMutableArray * array = [NSMutableArray array];
                for (NSDictionary * goodDic in dataArr)
                {
                    WDSpecialPriceModel * goodModel = [WDSpecialPriceModel userWithDictionary:goodDic];
                    [array addObject:goodModel];
                }
                [goodArray addObject:array];
            }
            
            bigArray = [NSMutableArray arrayWithObjects:productscount, storescount, modelArray, goodArray,nil];
            
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载果蔬生鲜首页数据
+ (void)requestLoadFruitAndVegetableWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/SelfStores/Load?access_token=%@",API_PORT,token];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *bigArray;
            
            // 1. 解析广告数据
            NSDictionary *adverts1 = responseObject[@"adverts1"];
            NSString *adverts1Ret = adverts1[@"ret"];
            NSMutableArray *advertsArr = [NSMutableArray array];
            if ([adverts1Ret isEqualToString:@"0"]) {
                
                NSArray *data = adverts1[@"data"];
                for (NSDictionary *modelDic in data) {
                    
                    WDAdvertisementModel *model = [[WDAdvertisementModel alloc] initWithDictionary:modelDic];
                    [advertsArr addObject:model];
                }
            }

            // 2. 解析优选商品数据
            NSDictionary *products = responseObject[@"products"];
            NSString *productsRet = products[@"ret"];
            NSMutableArray *productsArr = [NSMutableArray array];
            if ([productsRet isEqualToString:@"0"]) {
                
                NSArray *data = products[@"data"];
                for (NSDictionary *modelDic in data) {
                    
                    WDSpecialPriceModel *model = [[WDSpecialPriceModel alloc]initWithDictionary:modelDic];
                    [productsArr addObject:model];
                }
                
            }
            
            // 3. 解析分类数据
            NSDictionary *adverts2 = responseObject[@"adverts2"];
            NSString *adverts2Ret = adverts2[@"ret"];
            NSMutableArray *adverts2Arr = [NSMutableArray array];
            if ([adverts2Ret isEqualToString:@"0"]) {
                
                NSArray *data = adverts2[@"data"];
                for (NSDictionary *modelDic in data) {
                    
                    WDAdvertisementModel *model = [[WDAdvertisementModel alloc]initWithDictionary:modelDic];
                    [adverts2Arr addObject:model];
                }
            }
            
            // 4. 整合
            bigArray = [NSMutableArray arrayWithObjects:advertsArr,productsArr,adverts2Arr, nil];
            
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 加载果蔬生鲜产品列表
+ (void)requestLoadFruitAndVegetableWithUrltype:(NSString *)urltype currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@api/SelfStores/Loadproducts?access_token=%@&urltype=%@&currentpage=%@",API_PORT,token,urltype,currentpage];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *modelArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *modelDic in data) {
                
                WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc]initWithDictionary:modelDic];
                [modelArr addObject:model];
            }
            
            if (complete) {
                
                complete(modelArr,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 签到
+ (void)requestSignInWithCompletion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/signin/clock?access_token=%@",API_PORT,token];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else if ([ret isEqualToString:@"1"]){
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载积分商城首页广告
+ (void)requestLoadJifenStoreAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/credit/Loadadverts?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc] initWithDictionary:dic];
                [datasArr addObject:model];
            }
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载排行榜
+ (void)requestLoadLeaderboardWithType:(NSString *)type currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/credit/Loadcreditranking?access_token=%@&type=%@&currentpage=%@",API_PORT,token,type,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArr = [NSMutableArray array];
        
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDLeaderboardModel *model = [[WDLeaderboardModel alloc] initWithDictionary:dic];
                [datasArr addObject:model];
            }
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载积分商城产品数据
+ (void)requestLoadJifenStoreProductsWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/credit/Loadcreditproducts?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArr = [NSMutableArray array];
        
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDCreditProductsModel *model = [[WDCreditProductsModel alloc] initWithDictionary:dic];
                [datasArr addObject:model];
            }
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载单个积分产品信息
+ (void)requestLoadJifenStoreProductsMsgWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/credit/Loadinfo?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"productsinfo"];
            WDCreditProductsModel *model = [[WDCreditProductsModel alloc] initWithDictionary:productsinfo];
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 兑换积分商品
+ (void)requestExchangeJIfenGoodsWithAddressId:(NSString *)addressid goodsId:(NSString *)pid completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/creditorders/SubmitOrder?access_token=%@&addressid=%@&pid=%@",API_PORT,token,addressid,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"msg"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载二手品首页广告
+ (void)requestLoadSecondStoreAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/secondhand/Loadadverts?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc] initWithDictionary:dic];
                [datasArr addObject:model];
            }
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载二手品首页产品数据
+ (void)requestLoadSecondStoreMainDatasWithRegion:(NSString *)region money:(NSString *)money sate:(NSString *)sate keyValue:(NSString *)keyvalue currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/secondhand/Loadproduct?access_token=%@&region=%@&money=%@&sate=%@&keyvalue=%@&currentpage=%@",API_PORT,token,region,money,sate,keyvalue,currentpage];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *datasArr;
            
            NSMutableArray *cateArray1 = [NSMutableArray array];
            NSMutableArray *cateArray2 = [NSMutableArray array];
            NSMutableArray *cateArray3 = [NSMutableArray array];
            NSMutableArray *productArray = [NSMutableArray array];
            
            NSDictionary *region = responseObject[@"region"];
            NSString *regionRet = region[@"ret"];
            if ([regionRet isEqualToString:@"0"]) {
                
                NSArray *data = region[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray1 addObject:model];
                }
            }
            
            NSDictionary *money = responseObject[@"money"];
            NSString *moneyRet = money[@"ret"];
            if ([moneyRet isEqualToString:@"0"]) {
                
                NSArray *data = money[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray2 addObject:model];
                }
            }
            
            NSDictionary *sate = responseObject[@"sate"];
            NSString *sateRet = sate[@"ret"];
            if ([sateRet isEqualToString:@"0"]) {
                
                NSArray *data = sate[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray3 addObject:model];
                }
            }
            
            NSDictionary *products = responseObject[@"products"];
            NSString *productsRet = products[@"ret"];
            if ([productsRet isEqualToString:@"0"]) {
                
                NSArray *data = products[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDSearchInfosModel *model = [[WDSearchInfosModel alloc] initWithDictionary:dic];
                    [productArray addObject:model];
                }
            }
            
            datasArr = [NSMutableArray arrayWithObjects:cateArray1,cateArray2,cateArray3,productArray, nil];
            
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载我的二手品详细信息
+ (void)requestLoadSecondStoreProductsMsgsWithPid:(NSString *)pid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/secondhand/Loadinfo?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"productsinfo"];
            WDCreditProductsModel *model = [[WDCreditProductsModel alloc] initWithDictionary:productsinfo];
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载便民服务首页广告
+ (void)requestLoadConvenientAdsWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/myservice/Loadadverts?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSMutableArray *datasArr = [NSMutableArray array];
        if ([ret isEqualToString:@"0"]) {
            
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *dic in data) {
                
                WDAdvertisementModel *model = [[WDAdvertisementModel alloc] initWithDictionary:dic];
                [datasArr addObject:model];
            }
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 加载便民服务资讯类列表
+ (void)requestLoadConvenientMainDatasWithRegion:(NSString *)region sate:(NSString *)sate cateId:(NSString *)cateid keyValue:(NSString *)keyvalue currentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/myservice/Loadnews?access_token=%@&region=%@&sate=%@&cateid=%@&keyvalue=%@&currentpage=%@",API_PORT,token,region,sate,cateid,keyvalue,currentpage];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSMutableArray *datasArr;
            
            NSMutableArray *cateArray1 = [NSMutableArray array];
            NSMutableArray *cateArray2 = [NSMutableArray array];
            NSMutableArray *cateArray3 = [NSMutableArray array];
            NSMutableArray *productArray = [NSMutableArray array];
            
            NSDictionary *region = responseObject[@"region"];
            NSString *regionRet = region[@"ret"];
            if ([regionRet isEqualToString:@"0"]) {
                
                NSArray *data = region[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray1 addObject:model];
                }
            }
            
            NSDictionary *categories = responseObject[@"categories"];
            NSString *categoriesRet = categories[@"ret"];
            if ([categoriesRet isEqualToString:@"0"]) {
                
                NSArray *data = categories[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray2 addObject:model];
                }
            }
            
            NSDictionary *sate = responseObject[@"sate"];
            NSString *sateRet = sate[@"ret"];
            if ([sateRet isEqualToString:@"0"]) {
                
                NSArray *data = sate[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDCategoryModel *model = [[WDCategoryModel alloc]initWithDictionary:dic];
                    [cateArray3 addObject:model];
                }
            }
            
            NSDictionary *news = responseObject[@"news"];
            NSString *productsRet = news[@"ret"];
            if ([productsRet isEqualToString:@"0"]) {
                
                NSArray *data = news[@"data"];
                for (NSDictionary *dic in data) {
                    
                    WDSearchInfosModel *model = [[WDSearchInfosModel alloc] initWithDictionary:dic];
                    [productArray addObject:model];
                }
            }
            
            datasArr = [NSMutableArray arrayWithObjects:cateArray1,cateArray2,cateArray3,productArray, nil];
            
            if (complete) {
                
                complete(datasArr,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 获取便民服务详细信息
+ (void)requestLoadConvenientProductsMsgsWithNewsId:(NSString *)newsid completion:(void(^)(WDCreditProductsModel *pmodel, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/myservice/Loadinfo?access_token=%@&newsid=%@",API_PORT,token,newsid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSDictionary *productsinfo = responseObject[@"newsinfo"];
            WDCreditProductsModel *model = [[WDCreditProductsModel alloc] initWithDictionary:productsinfo];
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 二手商品详细页面查看联系方式
+ (void)requestLookSecondGoodsMobileWithPid:(NSString *)pid completion:(void(^)(NSString *mobile, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/secondhand/Creditsorder?access_token=%@&pid=%@",API_PORT,token,pid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *result = responseObject[@"mobile"];
            if (complete) {
                
                complete(result,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 便民服务详细页面查看联系方式
+ (void)requestLookConvenientMobileWithNewsId:(NSString *)newsid completion:(void(^)(NSString *mobile, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/myservice/Creditsorder?access_token=%@&newsid=%@",API_PORT,token,newsid];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *result = responseObject[@"mobile"];
            if (complete) {
                
                complete(result,nil);
            }
            
        }else{
            
            NSString *msg = responseObject[@"msg"];
            
            if (complete) {
                
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 获取区域信息
+ (void)requestLoadAreaWithCompletion:(void(^)(NSMutableArray * dataArray, NSString *error))complete
{
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/region/Load?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"])
        {
            NSMutableArray * array = responseObject[@"data"];
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in array)
            {
                WDAreaModel * model = [[WDAreaModel alloc]initWithDictionary:dic];
                [dataArr addObject:model];
            }
            if (complete)
            {
                complete(dataArr,nil);
            }
            
        }else
        {
            NSString *msg = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 个人中心-便民服务-发布便民服务-类别列表
+ (void)requestLoadCategoryListWithCompletion:(void(^)(NSMutableArray * dataArray, NSString *error))complete{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/usersmyservice/Loadcate?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"])
        {
            NSMutableArray * array = responseObject[@"data"];
            NSMutableArray * dataArr = [NSMutableArray array];
            for (NSDictionary * dic in array)
            {
                WDAreaModel * model = [[WDAreaModel alloc]initWithDictionary:dic];
                [dataArr addObject:model];
            }
            if (complete)
            {
                complete(dataArr,nil);
            }
            
        }else
        {
            NSString *msg = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 发布我的二手品
+ (void)requestPublishMySecondGoodsWithName:(NSString *)name region:(NSString *)region money:(NSString *)money sate:(NSString *)sate contacts:(NSString *)contacts mobile:(NSString *)mobile media_ids:(NSString *)media_ids content:(NSString *)content completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/mysecondhand/Add?access_token=%@&name=%@&region=%@&money=%@&sate=%@&contacts=%@&mobile=%@&media_ids=%@&content=%@",API_PORT,token,name,region,money,sate,contacts,mobile,media_ids,content];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"msg"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else
        {
            NSString *msg = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 发布我的便民服务
+ (void)requestPublishMyServerWithName:(NSString *)name region:(NSString *)region sate:(NSString *)sate cateId:(NSString *)cateid contacts:(NSString *)contacts mobile:(NSString *)mobile media_ids:(NSString *)media_ids content:(NSString *)content completion:(void(^)(NSString *result, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/usersmyservice/Add?access_token=%@&name=%@&region=%@&sate=%@&cateid=%@&contacts=%@&mobile=%@&media_ids=%@&content=%@",API_PORT,token,name,region,sate,cateid,contacts,mobile,media_ids,content];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *msg = responseObject[@"msg"];
            if (complete) {
                
                complete(msg,nil);
            }
            
        }else
        {
            NSString *msg = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 首页-特价-更多页面接口
+ (void)requestMoreTejiaWithCurrentPage:(NSString *)currentpage completion:(void(^)(NSMutableArray * dataArray, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr =[NSString stringWithFormat:@"%@api/productslower/Load?access_token=%@&currentpage=%@",API_PORT,token,currentpage];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        NSLog(@"get = %@",responseObject);
        if ([ret isEqualToString:@"0"])
        {
            
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dic in data) {
                
                WDGoodChoiceModel *model = [[WDGoodChoiceModel alloc] initWithDictionary:dic];
                [modelArray addObject:model];
            }
            if (complete) {
                
                complete(modelArray,nil);
            }
              
        }else
        {
            NSString *msg = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,msg);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

@end
