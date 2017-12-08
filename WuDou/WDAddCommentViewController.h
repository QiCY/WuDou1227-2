//
//  WDAddCommentViewController.h
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"
#import "WDMineManager.h"

@interface WDAddCommentViewController : UIViewController

/* 物品质量星星视图 **/
@property (weak, nonatomic) IBOutlet StarView *qualityStarView;
/* 发货速度星星视图 **/
@property (weak, nonatomic) IBOutlet StarView *speedStarView;
/* 微笑服务星星视图 **/
@property (weak, nonatomic) IBOutlet StarView *serviceStarView;
/* 提意见输入框 **/
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
/* 提示文字，当做UITextView的placeholder属性 **/
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
/* 发照片图标 **/
@property (weak, nonatomic) IBOutlet UIImageView *sendPhotoImage;
/* 发照片 **/
@property (weak, nonatomic) IBOutlet UIButton *sendPhoto;
/* 提交点评 **/
@property (weak, nonatomic) IBOutlet UIButton *submitAdvice;

@property (weak, nonatomic) IBOutlet UIView *mainView;
/* 从相册选取的照片 **/
@property (weak, nonatomic) IBOutlet UIView *photosView;

/** 订单id*/
@property(nonatomic, copy)NSString *oid;


@end
