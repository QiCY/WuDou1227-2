//
//  WDNearDetailsTableViewCell.h
//  WuDou
//
//  Created by huahua on 16/8/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSearchInfosModel.h"


@protocol NearCellDelegate
-(void)addBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath;
-(void)deleteBtnClicked:(WDSearchInfosModel *)model count:(NSString *)count indexPath:(NSIndexPath *)indexPath;
@end

@interface WDNearDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (nonatomic,assign)id<NearCellDelegate>delegate;
@property (nonatomic,strong)WDSearchInfosModel *model;
@property (nonatomic,assign)int count;
@property (nonatomic,strong)NSIndexPath *indexPath;
- (void)setSearchInfoModel:(WDSearchInfosModel *)goods count:(NSString *)count indexPath:(NSIndexPath *)indexPath;

/** 是否显示减号和label*/
@property(nonatomic, assign)BOOL isShowEnabled;

@end



