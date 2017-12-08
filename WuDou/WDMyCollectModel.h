//
//  WDMyCollectModel.h
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WDMyCollectModel : NSObject

/** 属性*/
@property(nonatomic, copy)NSString *recordid, *name, *starcount, *commentcount, *img, *url, *urlType, *productcount, *monthlysales;

+(id)userWithDictionary:(NSDictionary*)userDic;
-(id)initWithDictionary:(NSDictionary*)userDic;


@end
