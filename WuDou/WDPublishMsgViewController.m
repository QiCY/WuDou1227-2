//
//  WDPublishMsgViewController.m
//  WuDou
//
//  Created by huahua on 16/8/18.
//  Copyright © 2016年 os1. All rights reserved.
//  发布信息 - 我的二手品

#import "WDPublishMsgViewController.h"
#import "SGImagePickerController.h"
#import "WDSecondGoodsTableVController.h"

@interface WDPublishMsgViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_upLoadBtn;  //上传图片按钮
    
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    BOOL _isSelect;
    CGFloat _keyboardhight;
    UITableView *_orderTabelView;  //下拉地区列表
    
    NSString *_sate;
    NSMutableArray *_photosArray;
    
    NSString *_mediaId;
}

@property(nonatomic,strong)NSMutableArray *areaListsArr;

@end

@implementation WDPublishMsgViewController

- (NSMutableArray *)areaListsArr{
    
    if (!_areaListsArr) {
        
        _areaListsArr = [NSMutableArray array];
    }
    
    return _areaListsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的二手品";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    _titleTextField.delegate = self;
    _priceTextField.delegate = self;
    _areaTextField.delegate = self;
    _friendsTextField.delegate = self;
    _phoneTextField.delegate = self;
    
    _mainScrollView.delegate = self;
    
    [self _createUpLoadImageButton];
    
    [self _setupSelectedImageView];
    
    //   添加监听方法，UIKeyboardWillShowNotification这是系统为我们提供的监听关键字，也就是在将要调出键盘的时候可以监听到
    _infosTextView.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
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

//   监听方法
-(void)keyBoardShow:(NSNotification *)notification{
    
    NSDictionary *dic = notification.userInfo;
    CGRect height = [dic[UIKeyboardFrameBeginUserInfoKey] CGRectValue]; //从字典中取出键盘点高度
    _keyboardhight = height.size.height;
    
}

/** 创建上传图片按钮*/
- (void)_createUpLoadImageButton{
    
    _upLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_fengmianImageView.frame), CGRectGetMinY(_fengmianImageView.frame), _fengmianImageView.bounds.size.width, _fengmianImageView.bounds.size.height)];
    [_upLoadBtn setTitle:@"选择图片上传" forState:UIControlStateNormal];
    [_upLoadBtn setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateNormal];
    _upLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_upLoadBtn addTarget:self action:@selector(upLoadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_upLoadBtn];
}


- (void)upLoadImage:(UIButton *)btn{
    
    SGImagePickerController *picker = [[SGImagePickerController alloc] init];
    picker.maxCount = 3;
    //返回选择的缩略图
    [picker setDidFinishSelectThumbnails:^(NSArray *thumbnails) {
        
        for (UIImageView *subView in self.fengmianImageView.subviews) {
            
            [subView removeFromSuperview];
        }
        
        _photosArray = [NSMutableArray arrayWithArray:thumbnails];
        for (int i = 0; i < _photosArray.count; i++) {
            
            UIImageView *photosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (80+5), 0, 80, 60)];
//            photosImageView.contentMode = UIViewContentModeScaleAspectFit;
            photosImageView.image = _photosArray[i];
            [self.fengmianImageView addSubview:photosImageView];
        }
        [_upLoadBtn setTitle:@"" forState:UIControlStateNormal];
        
        //  上传图片，拿到media_id
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *cate = @"1";
        
        NSString *urlStr = [NSString stringWithFormat:@"%@media/?access_token=%@&cate=%@",HTML5_URL,token,cate];
        
        [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (int i = 0; i < _photosArray.count; i ++) {
                
                UIImage *image = _photosArray[i];
                NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
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

/** 设置选中小圆圈图片的状态*/
- (void)_setupSelectedImageView{
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _normalImageView1.frame.origin.y-15, 40, 40)];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    _normalImageView1.backgroundColor = KSYSTEM_COLOR;
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_normalImageView2.frame)-15, _normalImageView2.frame.origin.y-15, 40, 40)];
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
}

- (void)rightBtnAction:(UIButton *)right
{
    if (_isSelect)
    {
        _normalImageView1.backgroundColor = KSYSTEM_COLOR;
        _sate = @"1";
        _normalImageView2.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _normalImageView2.backgroundColor = KSYSTEM_COLOR;
        _sate = @"2";
        _normalImageView1.backgroundColor = [UIColor clearColor];
    }

     _isSelect =! _isSelect;
}

//  发布按钮
- (IBAction)publish:(UIButton *)sender {
    
    [WDMainRequestManager requestPublishMySecondGoodsWithName:self.titleTextField.text region:self.areaTextField.text money:self.priceTextField.text sate:_sate contacts:self.friendsTextField.text mobile:self.phoneTextField.text media_ids:_mediaId content:self.infosTextView.text completion:^(NSString *result, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
            
            //  确定
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                WDSecondGoodsTableVController *secondVC = [[WDSecondGoodsTableVController alloc] init];
                secondVC.navTitle = @"我的二手品";
                [self.navigationController pushViewController:secondVC animated:YES];
                
                _normalImageView1.backgroundColor = KSYSTEM_COLOR;
                _normalImageView2.backgroundColor = [UIColor clearColor];
                _titleTextField.text = @"";
                _areaTextField.text = @"";
                _priceTextField.text = @"";
                _friendsTextField.text = @"";
                _phoneTextField.text = @"";
                _infosTextView.text = @"";
                for (UIImageView *imageV in self.fengmianImageView.subviews) {
                    
                    [imageV removeFromSuperview];
                }
                
            }];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
        }
        
    }];
}


#pragma mark - UIImagePickerControllerDelegate

// 选取完成时调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
//    UIImage *image = info[UIImagePickerControllerOriginalImage];  //从info字典中取出键值是 UIImagePickerControllerOriginalImage（源图像）的image对象的值
    
    //  移除button
//    [_upLoadBtn removeFromSuperview];
//    [_upLoadBtn setTitle:@"" forState:UIControlStateNormal];
    
//    UIImage *image1 = info[UIImagePickerControllerEditedImage];  //当设置了允许编辑之后，再打印info，相比于之前没有设置的，字典中多了一个 UIImagePickerControllerEditedImage 键值，这个表示的是编辑完成之后的图片
    
//    _fengmianImageView.image = image1;  // 将选取的图片赋给_imageView
    
//    [picker dismissViewControllerAnimated:YES completion:nil];  //选取完图片后dismiss到原来的界面
    
//    UIImageWriteToSavedPhotosAlbum(image1, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);  //将图片保存到相册中
    
/*info：
     UIImagePickerControllerMediaType = "public.image"; 表示媒体类型为图片(image)类型，默认值
     UIImagePickerControllerMediaType = "public.movie"; 表示媒体类型为视频(movie)类型
 */
    
}
//  点击图库中cancel按钮时调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    NSLog(@"点击了cancel");
    
//    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGFloat bottomH = kScreenHeight - CGRectGetMaxY(_publishButton.frame) - 64;
    //  平移
    [UIView animateWithDuration:0.35 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -_keyboardhight + 50 + bottomH);
    }];
    
  
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [textView resignFirstResponder]; //收回键盘
        
        [UIView animateWithDuration:0.35 animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    
        return NO;
    }
    
    return YES;
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.areaListsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaOrderCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"areaOrderCell"];
        
    }
    WDAreaModel *model = self.areaListsArr[indexPath.row];
    
    cell.textLabel.text = model.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDAreaModel *model = self.areaListsArr[indexPath.row];
    self.areaTextField.text = model.name;
    [tableView removeFromSuperview];
    self.areaButton.enabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _mainScrollView) {
        
        [_orderTabelView removeFromSuperview];
        self.areaButton.enabled = YES;
        
        CGFloat offSetY = scrollView.contentOffset.y;
        _upLoadBtn.y = 102 - offSetY;
//        NSLog(@"%.2lf",_upLoadBtn.y);
    }
}

#pragma mark - buttonClick
/** 下拉选择地址*/
- (IBAction)areaBtnClick:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    [WDMainRequestManager requestLoadAreaWithCompletion:^(NSMutableArray *dataArray, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        self.areaListsArr = dataArray;
        
        CGFloat tableH;
        CGFloat height = kScreenHeight - CGRectGetMaxY(self.areaView.frame) - 60 - 64;
        CGFloat tatalH = 44*self.areaListsArr.count;
        
        if (height > tatalH) {
            
            tableH = tatalH;
        }else{
            
            tableH = height;
        }
        
        _orderTabelView = [[UITableView alloc] initWithFrame:CGRectMake(self.areaView.x, CGRectGetMaxY(self.areaView.frame), self.areaView.width, tableH) style:UITableViewStylePlain];
        _orderTabelView.delegate = self;
        _orderTabelView.dataSource = self;
        [self.view addSubview:_orderTabelView];
    }];
    
}

- (IBAction)removJianPan:(UIButton *)sender {
    
    [_orderTabelView removeFromSuperview];
    self.areaButton.enabled = YES;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.35 animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}
@end
