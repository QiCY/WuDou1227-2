//
//  WDUserMsgModel.m
//  WuDou
//
//  Created by huahua on 16/9/19.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDUserMsgModel.h"

@implementation WDUserMsgModel

+(id)userWithDictionary:(NSDictionary*)userDic{
    
    return [[self alloc]initWithDictionary:userDic];
}

-(id)initWithDictionary:(NSDictionary*)userDic{
    
    if (self = [super init])
    {
        _username = [userDic[@"username"]copy];
        NSString *url = [userDic[@"avatar"]copy];
        _avatar = [NSString stringWithFormat:@"%@%@",IMAGE_URL,url];
        _credits = [userDic[@"credits"]copy];
        _sex = [userDic[@"sex"]copy];
        
    }
    return self ;
}

@end
