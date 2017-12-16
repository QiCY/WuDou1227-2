//
//  WDStoreInfoGoodsView.h
//  WuDou
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WDSearchInfosModel.h"
#import "WDListRihtTableViewCell.h"
#import "WDNearDetailsTableViewCell.h"
@protocol WDStoreInfoGoodsViewDelegate
@optional
- (void)addBtnClicked:(WDSearchInfosModel *)good count:(NSString *)count indexPath:(NSIndexPath *)indexPath;
- (void)deleteBtnClicked:(WDSearchInfosModel *)good count:(NSString *)count indexPath:(NSIndexPath *)indexPath;
-(void)didClickedGood:(WDSearchInfosModel *)good;
-(void)didScrollToUp;
-(void)didScrollToDown;
@end

@interface WDStoreInfoGoodsView : UIView<UITableViewDelegate,UITableViewDataSource,NearCellDelegate>
@property(nonatomic,strong)UITableView *leftTableView,*rightTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *selectArray;
@property(nonatomic,assign)id<WDStoreInfoGoodsViewDelegate>delegate;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,assign)BOOL  isDidSelect;
@property(nonatomic,assign)BOOL isScroll;
- (void)setDataArray:(NSMutableArray *)dataList selectList:(NSMutableArray *)selectList indexPath:(NSIndexPath *)indexPath;
- (void)setDataArray:(NSMutableArray *)dataList selectList:(NSMutableArray *)selectList;
@end
