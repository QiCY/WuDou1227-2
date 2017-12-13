//
//  WDMyOrderCell.m
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyOrderCell.h"
#import "WDJifenMsgViewController.h"
#import "WDAddJudgementViewController.h"
#import "WDPayViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDStoreDetailViewController.h"

@interface WDMyOrderCell ()

@end

@implementation WDMyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  
}

- (void)setIsZhiFuEnabled:(BOOL)isZhiFuEnabled{
    
    _isZhiFuEnabled = isZhiFuEnabled;
    
    //  为了避免单元格复用，在添加子视图之前移除_showZhifuStateView上的所有子控件
    for (UIView *subview in _showZhifuStateView.subviews) {
        
        [subview removeFromSuperview];
    }
    
    //  已支付状态  并添加“去评价”和“再次购买”两个按钮
    if (_isZhiFuEnabled == 1) {
        
        UIButton *gotoComment = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _showZhifuStateView.bounds.size.width * 0.5, _showZhifuStateView.bounds.size.height)];
        [gotoComment setTitle:self.judgeText forState:UIControlStateNormal];
        gotoComment.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [gotoComment setBackgroundColor:[UIColor lightGrayColor]];
//        [gotoComment setBackgroundImage:[UIImage imageNamed:@"去评价.png"] forState:UIControlStateNormal];
        [gotoComment addTarget:self action:@selector(gotoCommentAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.isReview isEqualToString:@"0"]) {
            
            [_showZhifuStateView addSubview:gotoComment];
        }
        
        UIButton *buyAgain = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(gotoComment.frame), 0, _showZhifuStateView.bounds.size.width * 0.5, _showZhifuStateView.bounds.size.height)];
        [buyAgain setTitle:@"再次购买" forState:UIControlStateNormal];
        buyAgain.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [buyAgain setBackgroundColor:[UIColor orangeColor]];
        [buyAgain addTarget:self action:@selector(buyAgainAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showZhifuStateView addSubview:buyAgain];

    }
    //  待支付状态  并添加“立即支付”按钮
    if (_isZhiFuEnabled == 0) {
        
        UIButton *gotoZhifu = [[UIButton alloc] initWithFrame:CGRectMake(_showZhifuStateView.bounds.size.width * 0.5, 0, _showZhifuStateView.bounds.size.width * 0.5, _showZhifuStateView.bounds.size.height)];
//        [gotoZhifu setBackgroundImage:[UIImage imageNamed:@"立即支付.png"] forState:UIControlStateNormal];
        gotoZhifu.backgroundColor = KSYSTEM_COLOR;
        gotoZhifu.titleLabel.font = [UIFont systemFontOfSize:14];
        [gotoZhifu setTitle:@"立即支付" forState:UIControlStateNormal];
        [gotoZhifu addTarget:self action:@selector(gotoZhifuAction:) forControlEvents:UIControlEventTouchUpInside];
        [_showZhifuStateView addSubview:gotoZhifu];
    }
}

//  去评价
- (void)gotoCommentAction:(UIButton *)comment{
    
    WDAddJudgementViewController *addCommentVC = [[WDAddJudgementViewController alloc]init];
    addCommentVC.oid = self.oid;
    addCommentVC.judgeState = self.judgeText;
    [_myOrderVC.navigationController pushViewController:addCommentVC animated:YES];
}
//  再次购买
- (void)buyAgainAction:(UIButton *)buyagain{
        
//    WDNearDetailsViewController *nearDetailsVC = [[WDNearDetailsViewController alloc] init];
    WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
    nearVC.type = 1;
    nearVC.storeId = self.storeid;
    [WDAppInitManeger saveStrData:nearVC.storeId withStr:@"shopID"];
    
    [_myOrderVC.navigationController pushViewController:nearVC animated:YES];
    
}
//  立即支付
- (void)gotoZhifuAction:(UIButton *)zhifu{
    
//    NSLog(@"前往 立即支付");
    WDPayViewController * accountVC = [[WDPayViewController alloc]init];
    accountVC.orderDic = self.orderStr;
    accountVC.snType = @"1";
    [_myOrderVC.navigationController pushViewController:accountVC animated:YES];
}

- (void)setOrderPicImages:(NSMutableArray *)orderPicImages{
    
    _orderPicImages = orderPicImages;
    
    CGFloat picWidth = 60;
    _orderPics.contentSize = CGSizeMake((picWidth+10) * _orderPicImages.count,_orderPics.bounds.size.height);
    
    for (UIView *subV in _orderPics.subviews) {
        
        [subV removeFromSuperview];
    }
    
    for (int i = 0; i < _orderPicImages.count; i ++) {
        
        UIImageView *goodsPic = [[UIImageView alloc] initWithFrame:CGRectMake((10+picWidth)*i, 0, picWidth, _orderPics.bounds.size.height)];
        [goodsPic sd_setImageWithURL:[NSURL URLWithString:_orderPicImages[i]]];
        [_orderPics addSubview:goodsPic];
    }
    
}

@end
