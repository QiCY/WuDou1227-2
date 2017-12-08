//
//  WDAddJudgementsCell.m
//  WuDou
//
//  Created by huahua on 16/12/3.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAddJudgementsCell.h"
#import "SGImagePickerController.h"

@interface WDAddJudgementsCell ()<UITextViewDelegate>
{
    NSString *_mediaId;
    NSInteger _star1;
    NSInteger _star2;
    NSInteger _star3;
}
@end

@implementation WDAddJudgementsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (NSMutableArray *)photosArray{
    
    if (!_photosArray) {
        
        _photosArray = [[NSMutableArray alloc] init];
    }
    return _photosArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self _createContentView];
        //  设置初始值，都为五颗星
        _star1 = 5;
        _star2 = 5;
        _star3 = 5;
        _dataDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@""
                    ,@"pid",
                    [NSString stringWithFormat:@"%ld",_star1],@"star1",
                    [NSString stringWithFormat:@"%ld",_star2],@"star2",
                    [NSString stringWithFormat:@"%ld",_star3],@"star3",
                    @"",@"message",
                    @"",@"media_ids", nil];
        //  添加通知，当textView开始输入的时候隐藏 placeholderLabel
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:self.judgements];
    }
    
    return self;
}

- (void)setDelegation:(id<WDAddJudgementsCellDelegate>)delegation{
    
    _delegation = delegation;
    
    if ([_delegation respondsToSelector:@selector(getUploadDataWithDic:currentRow:)]) {
        
        [_delegation getUploadDataWithDic:_dataDic currentRow:self.currentRow];
    }
}

//  通知的方法
- (void)textDidChange{
    
    self.textViewPlaceHolder.hidden = self.judgements.hasText;
}

//  移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

/** 创建cell界面*/
- (void)_createContentView{
    
    self.goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
//    self.goodsImage.image = [UIImage imageNamed:@"sale"];
    [self.contentView addSubview:self.goodsImage];
    
    self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.goodsImage.frame)+10, 0, kScreenWidth - CGRectGetMaxX(self.goodsImage.frame) - 20, 40)];
    self.goodsName.centerY = self.goodsImage.centerY;
//    self.goodsName.text = @"商品名称";
    self.goodsName.numberOfLines = 2;
    self.goodsName.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.goodsName];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(self.goodsImage.frame)];
    
    UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.goodsImage.frame)+11, 20, 20)];
    image1.image = [UIImage imageNamed:@"评价图标"];
    [self.contentView addSubview:image1];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+10, image1.y, 100, 20)];
    label1.text = @"评价等级";
    label1.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:label1];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(label1.frame)];
    
    UILabel *leftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsName.x, CGRectGetMaxY(label1.frame)+11, 60, 20)];
    leftLabel1.text = @"物品质量";
    leftLabel1.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:leftLabel1];
    
    self.qualityStarView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel1.frame)+20, 0, 90, 18)];
    self.qualityStarView.centerY = leftLabel1.centerY;
    [self.contentView addSubview:self.qualityStarView];
    
    UILabel *leftLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsName.x, CGRectGetMaxY(leftLabel1.frame)+5, 60, 20)];
    leftLabel2.text = @"发货速度";
    leftLabel2.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:leftLabel2];
    
    self.speedStarView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel2.frame)+20, 0, 90, 18)];
    self.speedStarView.centerY = leftLabel2.centerY;
    [self.contentView addSubview:self.speedStarView];
    
    UILabel *leftLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.goodsName.x, CGRectGetMaxY(leftLabel2.frame)+5, 60, 20)];
    leftLabel3.text = @"发货速度";
    leftLabel3.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:leftLabel3];
    
    self.serviceStarView = [[StarView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftLabel3.frame)+20, 0, 90, 18)];
    self.serviceStarView.centerY = leftLabel3.centerY;
    [self.contentView addSubview:self.serviceStarView];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(self.serviceStarView.frame)];
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.serviceStarView.frame)+11, 20, 20)];
    image2.image = [UIImage imageNamed:@"评价详情"];
    [self.contentView addSubview:image2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image2.frame)+10, image2.y, 100, 20)];
    label2.text = @"评价详情";
    label2.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:label2];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(label2.frame)];
    
    self.judgements = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(label2.frame)+11, kScreenWidth-10, 80)];
    self.judgements.delegate = self;
    self.judgements.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.judgements];
    
    self.textViewPlaceHolder = [[UILabel alloc] initWithFrame:CGRectMake(10, self.judgements.y+5, kScreenWidth-20, 20)];
    self.textViewPlaceHolder.text = @"您的意见很重要，来评价吧！";
    self.textViewPlaceHolder.textColor = [UIColor lightGrayColor];
    self.textViewPlaceHolder.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.textViewPlaceHolder];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(self.judgements.frame)];
    
    UIImageView *image3 = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.judgements.frame)+11, 30, 30)];
    image3.image = [UIImage imageNamed:@"发照片"];
    [self.contentView addSubview:image3];
    
    self.sendPhoto = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image3.frame)+5, 0, 60, 30)];
    self.sendPhoto.centerY = image3.centerY;
    [self.sendPhoto setTitle:@"发照片" forState:UIControlStateNormal];
    [self.sendPhoto setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.sendPhoto setTitleColor:KSYSTEM_COLOR forState:UIControlStateHighlighted];
    self.sendPhoto.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.sendPhoto addTarget:self action:@selector(sendPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sendPhoto];
    
    self.photosView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(image3.frame)+5, kScreenWidth-20, 60)];
    [self.contentView addSubview:self.photosView];
    
    [self _createLineViewWithMaxY:CGRectGetMaxY(self.photosView.frame)];
}

/** 分隔线*/
- (void)_createLineViewWithMaxY:(CGFloat)y{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, y+5, kScreenWidth - 20, 1)];
    line.backgroundColor = kViewControllerBackgroundColor;
    [self.contentView addSubview:line];
}

/** 发照片*/
- (void)sendPhotoAction:(UIButton *)btn{
    
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];
    picker.maxCount = 3;
    //返回选择的缩略图
    [picker setDidFinishSelectImages:^(NSArray *images) {
        
        for (UIImageView *subView in self.photosView.subviews) {
            
            [subView removeFromSuperview];
        }
        
        self.photosArray = [NSMutableArray arrayWithArray:images];
        for (int i = 0; i < self.photosArray.count; i++) {
            
            UIImageView *photosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (80+5), 0, 80, 60)];
            photosImageView.image = self.photosArray[i];
            [self.photosView addSubview:photosImageView];
        }
        
        //  上传图片，拿到media_id
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *cate = @"3";
        
        NSString *urlStr = [NSString stringWithFormat:@"%@media/?access_token=%@&cate=%@",HTML5_URL,token,cate];
        
        [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int i = 0; i < _photosArray.count; i ++) {
                
                UIImage *image = _photosArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                [formData appendPartWithFileData:imageData name:@"pic" fileName:[NSString stringWithFormat:@"image%d",i] mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject = %@",responseObject);
            NSString *ret = responseObject[@"ret"];
            if ([ret isEqualToString:@"0"]) {
                
                NSString *media_ids = responseObject[@"media_ids"];
                
                _mediaId = media_ids;
                [_dataDic setObject:_mediaId forKey:@"media_ids"];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error = %@",error);
        }];
    }];
    
    [self.superV presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.contentView];
    
    if (CGRectContainsPoint(_qualityStarView.frame, point)) {
        
        _qualityStarView.starCount = ((point.x - _qualityStarView.frame.origin.x)*5 / 90.0 ) + 1;
        _star1 = _qualityStarView.starCount;
        NSLog(@"%ld",_star1);
        
    }
    if (CGRectContainsPoint(_speedStarView.frame, point)) {
        
        _speedStarView.starCount = ((point.x - _speedStarView.frame.origin.x)*5 / 90.0 ) + 1;
        _star2 = _speedStarView.starCount;
        
    }
    if (CGRectContainsPoint(_serviceStarView.frame, point)) {
        
        _serviceStarView.starCount = ((point.x - _serviceStarView.frame.origin.x)*5 / 90.0 ) + 1;
        _star3 = _serviceStarView.starCount;
    }
    
    [_dataDic setObject:self.pid forKey:@"pid"];
    [_dataDic setObject:[NSString stringWithFormat:@"%ld",_star1] forKey:@"star1"];
    [_dataDic setObject:[NSString stringWithFormat:@"%ld",_star2] forKey:@"star2"];
    [_dataDic setObject:[NSString stringWithFormat:@"%ld",_star3] forKey:@"star3"];
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里响应return键
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [_dataDic setObject:self.judgements.text forKey:@"message"];
}

@end
