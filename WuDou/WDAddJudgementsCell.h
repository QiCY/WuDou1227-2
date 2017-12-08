//
//  WDAddJudgementsCell.h
//  WuDou
//
//  Created by huahua on 16/12/3.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@protocol WDAddJudgementsCellDelegate <NSObject>

- (void)getUploadDataWithDic:(NSMutableDictionary *)dic currentRow:(NSInteger)row;

@end

@interface WDAddJudgementsCell : UITableViewCell

@property (strong, nonatomic) UIImageView *goodsImage;
@property (strong, nonatomic) UILabel *goodsName;
@property (strong, nonatomic) StarView *qualityStarView;
@property (strong, nonatomic) StarView *speedStarView;
@property (strong, nonatomic) StarView *serviceStarView;
@property (strong, nonatomic) UITextView *judgements;
@property (strong, nonatomic) UILabel *textViewPlaceHolder;
@property (strong, nonatomic) UIButton *sendPhoto;
@property (strong, nonatomic) UIView *photosView;

/** 图片数组*/
@property(nonatomic, strong)NSMutableArray *photosArray;
/** 父控制器*/
@property(nonatomic, strong)UIViewController *superV;
/** 上传数据的字典*/
@property(nonatomic, strong)NSMutableDictionary *dataDic;
/** pid*/
@property(nonatomic, copy)NSString *pid;
/** 当前单元格行数*/
@property(nonatomic, assign)NSInteger currentRow;
/** 代理对象*/
@property(nonatomic, weak)id<WDAddJudgementsCellDelegate> delegation;

@end
