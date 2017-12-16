//
//  WDAddCommentViewController.m
//  WuDou
//
//  Created by huahua on 16/8/10.
//  Copyright © 2016年 os1. All rights reserved.
//  我的 -- 全部订单 -- 去评价（添加评价）

#import "WDAddCommentViewController.h"
#import "SGImagePickerController.h"
#import "WDWebViewController.h"

@interface WDAddCommentViewController ()<UITextViewDelegate>
{
    NSMutableArray *_photosArray;
    
    NSString *_mediaId;
    
    NSInteger _star1;
    NSInteger _star2;
    NSInteger _star3;
}
@end

@implementation WDAddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"添加评价";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    //  添加通知，当textView开始输入的时候隐藏 placeholderLabel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:self.adviceTextView];
    
    _adviceTextView.delegate = self;
    
    //  设置初始值，都为五颗星
    _star1 = 5;
    _star2 = 5;
    _star3 = 5;
}

//  通知的方法
- (void)textDidChange{
    
    _placeholderLabel.hidden = _adviceTextView.hasText;
}

//  移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 60, 40);
     [btn setImageEdgeInsets:UIEdgeInsetsMake(12, 5, 12,45)];
    [btn setImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(goBackAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*back = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.navigationItem.leftBarButtonItem = back;
}

- (void)goBackAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//  发照片
- (IBAction)sendPhotos:(UIButton *)sender {
    
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];
    picker.maxCount = 3;
    //返回选择的缩略图
    [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
        
        //还原
        [UIView animateWithDuration:0.25 animations:^{
            
            self.mainView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            [self.mainView endEditing:YES];
        }];
        
        for (UIImageView *subView in _photosView.subviews) {
            
            [subView removeFromSuperview];
        }
        
        _photosArray = [NSMutableArray arrayWithArray:thumbnails];
        for (int i = 0; i < _photosArray.count; i++) {
            
            UIImageView *photosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (80+5), 0, 80, 60)];
            photosImageView.image = _photosArray[i];
            [_photosView addSubview:photosImageView];
        }
        
        //  上传图片，拿到media_id
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *cate = @"3";
        
        NSString *urlStr = [NSString stringWithFormat:@"%@media/?access_token=%@&cate=%@",HTML5_URL,token,cate];
        
        [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int i = 0; i < _photosArray.count; i ++) {
                
                UIImage *image = _photosArray[i];
                NSData *imageData = UIImagePNGRepresentation(image);
                [formData appendPartWithFileData:imageData name:@"pic" fileName:[NSString stringWithFormat:@"image%d",i] mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"responseObject = %@",responseObject);
            NSString *ret = responseObject[@"ret"];
            if ([ret isEqualToString:@"0"]) {
                
                NSString *media_ids = responseObject[@"media_ids"];
                
                _mediaId = media_ids;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"error = %@",error);
        }];
    }];
            
    [self presentViewController:picker animated:YES completion:nil];
}

//  提交点评
- (IBAction)submitComments:(id)sender {
    
    [WDMineManager requestGotoCommentWithOid:self.oid star1:[NSString stringWithFormat:@"%ld",(long)_star1] star2:[NSString stringWithFormat:@"%ld",(long)_star2] star3:[NSString stringWithFormat:@"%ld",(long)_star3] message:self.adviceTextView.text media_ids:_mediaId completion:^(NSString *result, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
        }
        else{
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                WDWebViewController *loginVC = [[WDWebViewController alloc] init];
                loginVC.navTitle = @"我的评价";
                
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
                NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/myreviews.html?access_token=%@",HTML5_URL,token];
                loginVC.urlString = urlStr;
                [self.navigationController pushViewController:loginVC animated:YES];
                
                _qualityStarView.starCount = 5;
                _speedStarView.starCount = 5;
                _serviceStarView.starCount = 5;
                
                self.adviceTextView.text = @"";
                self.placeholderLabel.text = @"您的意见很重要，来评价吧！";
                
                for (UIImageView *imageV in self.photosView.subviews) {
                    
                    [imageV removeFromSuperview];
                }
            }];
            
            [alertView addAction:sure];
            [self presentViewController:alertView animated:YES completion:nil];  //用模态的方法显示对话框
        }
    }];
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:_mainView];
    
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
    
    //还原
    [UIView animateWithDuration:0.25 animations:^{
        
        self.mainView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        [self.mainView endEditing:YES];
    }];
    
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里响应return键
        [textView resignFirstResponder];
        
        //还原
        [UIView animateWithDuration:0.25 animations:^{
           
            self.mainView.transform = CGAffineTransformIdentity;
        }];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
//    NSLog(@"textViewDidBeginEditing");
    
    //  平移
    [UIView animateWithDuration:0.25 animations:^{
        
        self.mainView.transform = CGAffineTransformMakeTranslation(0, -100);
    } completion:^(BOOL finished) {
        
        [textView becomeFirstResponder];
    }];
    
}


@end
