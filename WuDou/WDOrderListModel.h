//
//  WDOrderListModel.h
//  WuDou
//
//  Created by huahua on 16/9/29.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDOrderListModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *storeid, *storename, *storeimg, *paysate, *oid, *osn, *orderamount, *addtime, *orderstatusdescription, *isreviews, *reviewstext, *isEditshow, *EditshowText, *surplusmoney, *ordertype, *creditsvalue;

@property(nonatomic, strong)NSArray *productsdata;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;

@end
