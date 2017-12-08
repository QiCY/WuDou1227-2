//
//  WDScrollView.m
//  WuDou
//
//  Created by huahua on 16/11/24.
//  Copyright © 2016年 os1. All rights reserved.
//  上下滚动文字

#import "WDScrollView.h"

@interface WDScrollView ()<UIScrollViewDelegate>
/** 滚动视图*/
@property (nonatomic,strong) UIScrollView *myScrollView;
/** label的宽度*/
@property (nonatomic,assign) CGFloat labelW;
/** label的高度*/
@property (nonatomic,assign) CGFloat labelH;
/** 定时器*/
@property (nonatomic,strong) NSTimer *timer;
/** 记录滚动的页码*/
@property (nonatomic,assign) int page;

@end

@implementation WDScrollView

- (UIScrollView *)myScrollView {
    
    if (_myScrollView == nil) {
        
        _myScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _myScrollView.showsHorizontalScrollIndicator = NO;
        _myScrollView.showsVerticalScrollIndicator = NO;
        _myScrollView.scrollEnabled = NO;
        _myScrollView.pagingEnabled = YES;
        [self addSubview:_myScrollView];
        
        [_myScrollView setContentOffset:CGPointMake(0 , self.labelH) animated:YES];
    }
    
    return _myScrollView;
}

//重写init方法
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.labelW = frame.size.width;
        
        self.labelH = frame.size.height;
        
        self.myScrollView.delegate = self;
        
        [self addTimer];
        
    }
    
    return self;
}

//重写set方法 创建对应的label
- (void)setTitleArray:(NSArray *)titleArray {
    
    _titleArray = titleArray;
    
    if (titleArray == nil) {
        [self removeTimer];
        return;
    }
    
    if (titleArray.count == 1) {
        [self removeTimer];
    }
    
    id lastObj = [titleArray lastObject];
    
    NSMutableArray *objArray = [[NSMutableArray alloc] init];
    
    [objArray addObject:lastObj];
    [objArray addObjectsFromArray:titleArray];
    
    self.titleNewArray = objArray;
    
    //CGFloat contentW = 0;
    CGFloat contentH = self.labelH *objArray.count;
    
    self.myScrollView.contentSize = CGSizeMake(0, contentH);
    
    CGFloat labelW = self.myScrollView.frame.size.width;
    self.labelW = labelW;
    CGFloat labelH = self.myScrollView.frame.size.height;
    self.labelH = labelH;
    CGFloat labelX = 0;
    
    //防止重复赋值数据叠加
    for (id label in self.myScrollView.subviews) {
        
        [label removeFromSuperview];
        
    }
    for (int i = 0; i < objArray.count; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.userInteractionEnabled = YES;
        
        titleLabel.tag = 100 + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTheLabel:)];
        
        [titleLabel addGestureRecognizer:tap];
        
        titleLabel.textAlignment = NSTextAlignmentLeft;
        
        CGFloat labelY = i * labelH;
        
        titleLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        titleLabel.text = objArray[i];
        
        [self.myScrollView addSubview:titleLabel];
    }
}

- (void)clickTheLabel:(UITapGestureRecognizer *)tap {
    
    if (self.clickLabelBlock) {
        
        NSInteger tag = tap.view.tag - 1;
        
        if (tag < 100) {
            
            tag = 100 + (self.titleArray.count - 1);
            
        }
        
        self.clickLabelBlock(tag,self.titleArray[tag - 100]);
        
    }
}

- (void)clickTitleLabel:(clickLabelBlock) clickLabelBlock {
    
    self.clickLabelBlock = clickLabelBlock;
}

- (void)nextLabel {
    
    CGPoint oldPoint = self.myScrollView.contentOffset;
    oldPoint.y += self.myScrollView.frame.size.height;
    [self.myScrollView setContentOffset:oldPoint animated:YES];
    
}

#pragma mark - Set方法
- (void)setIsCanScroll:(BOOL)isCanScroll {
    
    if (isCanScroll) {
        
        self.myScrollView.scrollEnabled = YES;
        
    } else {
        
        self.myScrollView.scrollEnabled = NO;
        
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    
    _titleColor = titleColor;
    
    for (UILabel *label in self.myScrollView.subviews) {
        
        label.textColor = titleColor;
        
    }
}

- (void)setTitleFont:(CGFloat )titleFont {
    
    _titleFont = titleFont;
    
    for (UILabel *label in self.myScrollView.subviews) {
        
        label.font = [UIFont systemFontOfSize: titleFont];;
        
    }
    
}

- (void)setBGColor:(UIColor *)BGColor {
    
    _BGColor = BGColor;
    
    self.backgroundColor = BGColor;
    
}

#pragma mark - UIScrollViewDelegate
//当图片滚动时调用scrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.myScrollView.contentOffset.y == self.myScrollView.frame.size.height*(self.titleArray.count )) {
        
        [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
    }
    
}

// 开始拖拽的时候调用
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self removeTimer];
}

// 结束拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    //开启定时器
    [self addTimer];
}

// 开启
- (void)addTimer{
    
    self.timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(nextLabel) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 关闭
- (void)removeTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

// 销毁
- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    
}

@end
