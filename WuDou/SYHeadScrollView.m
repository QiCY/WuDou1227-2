//
//  SYHeadScrollView.m
//  SuiYangApp
//
//  Created by admin on 2017/11/23.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SYHeadScrollView.h"
#define showCount  (_dataList.count>5?5:_dataList.count)
#define BtnWidth       kScreenWidth/2
@implementation SYHeadScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame withDataList:(NSMutableArray *)list didClick:(ButtonClicked)clickBlock{
    if (self = [super initWithFrame:frame]) {
        self.dataList  = list;
        self.buttonClicked = clickBlock;
        [self createUI];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withDataList:(NSMutableArray *)list selectedImgs:(NSArray *)selectedList unSelectedImgs:(NSArray *)unSelectedList didClick:(ButtonClicked)clickBlock{
    if (self = [super initWithFrame:frame]) {
        self.dataList  = list;
        self.selectedList = selectedList;
        self.unSelectedList = unSelectedList;
        self.buttonClicked = clickBlock;
        [self createUI];
        [self addSubview:[self createVerLine:CGRectMake(0, 30, kScreenWidth, 0.5) color:[UIColor lightGrayColor]]];
    }
    return self;
}
-(void)createUI{
    NSArray *images = @[@"shucaiqu",@"jingcaiqu"];
    for (int i =0; i<_dataList.count; i++) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*BtnWidth, 0, BtnWidth, 30)];
        [button setTitle:_dataList[i] forState:UIControlStateNormal];
        if (self.selectedList) {
//            [button setBackgroundImage:[UIImage imageNamed:_selectedList[i]] forState:UIControlStateSelected];
//            [button setBackgroundImage:[UIImage imageNamed:_unSelectedList[i]] forState:UIControlStateNormal];
            
            
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            if (i==0) {
                _selectBtn = button;
                button.selected = YES;
            }
             button.tag = i+100;
        }else{
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:images[i]]];
            CGFloat width = [self getTextWidthWithFontSize:15 string:_dataList[i] height:30];
            imgView.frame = CGRectMake((BtnWidth-width)/2-30, 0, 30, 29);
            [button addSubview:imgView];
            if (i == 0) {
                _selectBtn = button;
                [_selectBtn setTitleColor:KSYSTEM_COLOR forState:UIControlStateNormal];
                [self addSelectBtnLine:_dataList[i] height:30 superView:_selectBtn];
            }else{
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
             button.tag = i;
        }
        
       
        if (i<_dataList.count-1) {
            [self addSubview:[self createVerLine:CGRectMake((i+1)*BtnWidth-0.5, 0, 0.5, 30) color:[UIColor lightGrayColor]]];
        }
        [button addTarget:self action:@selector(menuBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
    self.contentSize = CGSizeMake(_dataList.count*BtnWidth, 30);
}
- (UIView *)createVerLine:(CGRect)frame color:(UIColor *)color{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = color;
    return lineView;
}
//为选中的按钮添加下划线
- (void)addSelectBtnLine:(NSString *)text height:(CGFloat)height superView:(UIView *)supview{
    CGFloat width = [self getTextWidthWithFontSize:15 string:text height:height];
    self.selectBtnLine.frame = CGRectMake((BtnWidth-width)/2-30, supview.frame.size.height - 2, width+30, 2);
    [supview addSubview:self.selectBtnLine];
}
-(void)menuBtnClicked:(UIButton *)sender{
    if (self.selectedList) {
        if (sender !=_selectBtn) {
            _selectBtn.selected = !_selectBtn.selected;
            _selectBtn = sender;
            _selectBtn.selected = !_selectBtn.selected;
        }
    }else{
        if (sender != _selectBtn) {
            [_selectBtnLine removeFromSuperview];
            [_selectBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            _selectBtn = sender;
            [_selectBtn setTitleColor:KSYSTEM_COLOR forState:UIControlStateNormal];
            [self addSelectBtnLine:sender.titleLabel.text height:30 superView:_selectBtn];
        }
    }
   
    if (self.buttonClicked) {
        self.buttonClicked(sender.tag);
    }
}
-(CGFloat)getTextWidthWithFontSize:(CGFloat)size string:(NSString *)text height:(CGFloat)height{
    CGSize titleSize = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size;
    
    return titleSize.width;
}
- (void)setCurrentBtn:(NSInteger)index
{
    if (_selectBtn.tag != index) {
        UIButton *button = (UIButton *)[self viewWithTag:index];
        _selectBtn.selected = !_selectBtn.selected;
        _selectBtn = button;
        _selectBtn.selected = !_selectBtn.selected;
    }
   
}
-(UIView*)selectBtnLine{
    if (!_selectBtnLine) {
        _selectBtnLine = [[UIView alloc] init];
        _selectBtnLine.backgroundColor = KSYSTEM_COLOR;
    }
    return _selectBtnLine;
}
@end
