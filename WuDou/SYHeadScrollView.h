//
//  SYHeadScrollView.h
//  SuiYangApp
//
//  Created by admin on 2017/11/23.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonClicked)(NSInteger index);

@interface SYHeadScrollView : UIScrollView
@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *selectBtnLine;
@property(nonatomic,copy)ButtonClicked buttonClicked;
@property(nonatomic,strong)NSArray *selectedList,*unSelectedList;
- (id)initWithFrame:(CGRect)frame withDataList:(NSMutableArray *)list didClick:(ButtonClicked)clickBlock;
- (id)initWithFrame:(CGRect)frame withDataList:(NSMutableArray *)list selectedImgs:(NSArray *)selectedList unSelectedImgs:(NSArray *)unSelectedList didClick:(ButtonClicked)clickBlock;
-(void)setCurrentBtn:(NSInteger)index;
@end
