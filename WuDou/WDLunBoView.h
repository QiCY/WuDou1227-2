//
//  WDLunBoView.h
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 分页小圆点控件的显示位置*/  
typedef enum {
    WDLunBoViewPageContolAlimentRight,
    WDLunBoViewPageContolAlimentCenter
} WDLunBoViewPageContolAliment;

/** 分页控件显示样式*/
typedef enum {
    WDLunBoViewPageContolStyleClassic,       
    WDLunBoViewPageContolStyleAnimated,      
    WDLunBoViewPageContolStyleNone
} WDLunBoViewPageContolStyle;

@class WDLunBoView;

@protocol WDLunBoViewDelegate <NSObject>
@optional
/** 点击对应index图片回调 */
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/** 图片滚动时回调 */
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didScrollToIndex:(NSInteger)index;

@end

@interface WDLunBoView : UIView

/** 网络图片 url数组 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/** 自动滚动间隔时间,默认2s */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/** 是否无限循环,默认Yes */
@property (nonatomic,assign) BOOL infiniteLoop;

/** 是否自动滚动,默认Yes */
@property (nonatomic,assign) BOOL autoScroll;

/** 图片滚动方向，默认为水平滚动 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/** 代理对象 */
@property (nonatomic, weak) id<WDLunBoViewDelegate> delegate;

/** 占位图，当网络未加载到图片时显示 */
@property (nonatomic, strong) UIImage *placeholderImage;

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

/** 分页控件样式，默认为动画样式 */
@property (nonatomic, assign) WDLunBoViewPageContolStyle pageControlStyle;

/** 分页控件位置 */
@property (nonatomic, assign) WDLunBoViewPageContolAliment pageControlAliment;

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlBottomOffset;

/** 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量 */
@property (nonatomic, assign) CGFloat pageControlRightOffset;

/** 初始化轮播图 */
+ (instancetype)lunBoViewWithFrame:(CGRect)frame delegate:(id<WDLunBoViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;

/** 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法 */
- (void)adjustWhenControllerViewWillAppera;

@end
