//
//  Product.h
//  支付宝集成
//
//  Created by xiaomage on 15/12/22.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product : NSObject

@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *detail;

- (instancetype)initWithName:(NSString *)name price:(double)price detail:(NSString *)detail;
+ (instancetype)ProductWithName:(NSString *)name price:(double)price detail:(NSString *)detail;

@end
