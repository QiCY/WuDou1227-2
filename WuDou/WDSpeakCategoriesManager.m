//
//  WDSpeakCategoriesManager.m
//  WuDou
//
//  Created by huahua on 16/9/12.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSpeakCategoriesManager.h"

@implementation WDSpeakCategoriesManager

+ (void)requestCategoriesWithCompletion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/categories/Load?access_token=%@",API_PORT,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"])
        {
            
            NSMutableArray * bigArray = [NSMutableArray array];
            NSMutableArray * leftArray = [NSMutableArray array];
            NSMutableArray * headerArray = [NSMutableArray array];
            NSMutableArray * cellArray = [NSMutableArray array];
            NSArray *allArrays = responseObject[@"data"];
            for (NSDictionary *cateDic1 in allArrays)
            {
                WDCategoriesModel *model1 = [[WDCategoriesModel alloc]initWithDictionary:cateDic1];
                [leftArray addObject:model1];
                NSDictionary *subCate1 = cateDic1[@"subcategory"];
                NSString *subRet1 = subCate1[@"ret"];
                if ([subRet1 isEqualToString:@"0"])
                {
                    NSArray *cateArray1 = subCate1[@"data"];
                    NSMutableArray * heardArr = [NSMutableArray array];
                    NSMutableArray * cellArr1 = [NSMutableArray array];
                    for (NSDictionary *cateDic2 in cateArray1)
                    {
                        WDCategoriesModel * model2 = [[WDCategoriesModel alloc]initWithDictionary:cateDic2];
                        [heardArr addObject:model2];
                        
                        NSDictionary *subCate2 = cateDic2[@"subcategory"];
                        NSString *subRet2 = subCate2[@"ret"];
                        if ([subRet2 isEqualToString:@"0"])
                        {
                            NSMutableArray * cellArr2 = [NSMutableArray array];
                            NSArray *cateArray2 = subCate2[@"data"];
                            for (NSDictionary *cateDic3 in cateArray2)
                            {
                                
                                WDCategoriesModel *model3 = [[WDCategoriesModel alloc]initWithDictionary:cateDic3];
                                [cellArr2 addObject:model3];
                            }
                            [cellArr1 addObject:cellArr2];
                        }
                    }
                    [headerArray addObject:heardArr];
                    [cellArray addObject:cellArr1];
                }
            }
            [bigArray addObject:leftArray];
            [bigArray addObject:headerArray];
            [bigArray addObject:cellArray];
            //            bigArray = [NSMutableArray arrayWithObjects:mainArray,subArray1,subArray2, nil];
            if (complete) {
                
                complete(bigArray,nil);
            }
            
        }else{
            
            NSString *error = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}


/** 分类搜索*/
+ (void)requestCategorySearchWithCatenumber:(NSString *)catenumber completion:(void(^)(NSMutableArray *array, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/categories/LoadSearch?access_token=%@&catenumber=%@",API_PORT,token,catenumber];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSMutableArray *bigArray;
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]){
            
            NSString *productscount = responseObject[@"productscount"];
            NSString *storescount = responseObject[@"storescount"];
            
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
            
            NSString *error = responseObject[@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

@end
