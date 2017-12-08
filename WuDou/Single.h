//
//  Single.h
//  作业－传值代理版
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Single : NSObject

@property(nonatomic,copy)NSString *str;
@property(nonatomic,copy)NSString *detailStr;

+(instancetype)shareSingle;

@end
