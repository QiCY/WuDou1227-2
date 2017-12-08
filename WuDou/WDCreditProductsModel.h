//
//  WDCreditProductsModel.h
//  WuDou
//
//  Created by huahua on 16/10/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDCreditProductsModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *pid, *name, *shopprice, *img, *stock, *exchangecount, *time, *sate, *contacts, *mobile, *reviewedsate, *creditsvalue;

@property(nonatomic, strong)NSDictionary *images;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
