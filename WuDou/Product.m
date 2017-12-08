//
//  Product.m
//  支付宝集成
//
//  Created by xiaomage on 15/12/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "Product.h"

@implementation Product

- (instancetype)initWithName:(NSString *)name price:(double)price detail:(NSString *)detail
{
    if (self = [super init]) {
        self.name = name;
        self.price = price;
        self.detail = detail;
    }
    return self;
}

+ (instancetype)ProductWithName:(NSString *)name price:(double)price detail:(NSString *)detail
{
    return [[self alloc] initWithName:name price:price detail:detail];
}


@end
