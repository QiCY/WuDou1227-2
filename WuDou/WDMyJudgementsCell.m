//
//  WDMyJudgementsCell.m
//  WuDou
//
//  Created by huahua on 16/12/2.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMyJudgementsCell.h"
#import "WXPhotoBrowser.h"

@interface WDMyJudgementsCell ()<PhotoBrowerDelegate>

@end

@implementation WDMyJudgementsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 创建评论label
    _judgesTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    _judgesTextLabel.numberOfLines = 0;
    _judgesTextLabel.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:_judgesTextLabel];
    
    // 创建底部图片
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _bottomView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_bottomView];
}

- (void)setLayout:(WDMyJudgementsLayout *)layout{
    
    _layout = layout;
    
    _judgesTextLabel.text = _layout.judgesModel.message;
    _judgesTextLabel.frame = _layout.judgesLabelFrame;
    
    NSString *socre = _layout.judgesModel.percentage;
    CGFloat value = [socre floatValue];
    self.judgesStarView.starCount = value;
    
    self.judgesName.text = self.cellType ? _layout.judgesModel.username : _layout.judgesModel.pname;
    self.judgesTime.text = _layout.judgesModel.time;
    
    // 添加评论图片
    self.bottomView.frame = _layout.bottomImgsViewFrame;
    if (_layout.bottomImgsViewFrame.size.height != 0) {
        
        NSArray *picArray = _layout.judgesModel.imgs;
        
        for (UIView *subV in self.bottomView.subviews) {
            
            [subV removeFromSuperview];
        }
        
        for (int i = 0; i < picArray.count; i ++) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake((5+60)*i, 0, 60, 60)];
            imageV.tag = i;
            //打开用户响应
            imageV.userInteractionEnabled = YES;
            
            // 添加单击手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [imageV addGestureRecognizer:tap];
            
            NSDictionary *imgDic = picArray[i];
            NSString *imageName = imgDic[@"img"];
            NSString *imageUrlStr = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageName];
            [imageV sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]];
            [self.bottomView addSubview:imageV];
        }
        _bottomView.contentSize = CGSizeMake(65 * picArray.count, 40);
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:tap.view.tag delegate:self];
}

#pragma mark - PhotoBrowserDelegate
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser{
    
    return _layout.judgesModel.imgs.count;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    //1.创建图片对象
    WXPhoto *photo = [[WXPhoto alloc] init];
    
    NSArray *urls = [[NSArray alloc] init];
    
    //2.传递视图和数据
    photo.srcImageView = self.bottomView.subviews[index];
      //传递所有的urls
    urls = _layout.judgesModel.imgs;
    
    //3.大图的URL 传给 Photo对象
    NSString *imageStr = urls[index][@"img"];
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@",IMAGE_URL,imageStr];
    photo.url = [NSURL URLWithString:photoUrl];
    
    return photo;
}


@end
