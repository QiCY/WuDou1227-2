//
//  DetailTableViewCell.m
//  WuDou
//
//  Created by huahua on 16/8/11.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setPicsArray:(NSMutableArray *)picsArray{
    
    _picsArray = picsArray;
    
    CGFloat itemW = 50;
    for (int i = 0; i < _picsArray.count ; i ++) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i * (itemW+5) , 2.5, itemW, itemW)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:_picsArray[i]]];
        [self.picScrollView addSubview:imageV];
    }
    
    CGFloat contentW = _picsArray.count * 55;
    if (contentW < self.picScrollView.width) {
        
//        self.picScrollView.scrollEnabled = NO;
    }
    else{
        
        self.picScrollView.contentSize = CGSizeMake(contentW, 0);
    }
}



@end
