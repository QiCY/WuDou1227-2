//
//  WDSecondPublishViewController.m
//  WuDou
//
//  Created by huahua on 16/10/20.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDSecondPublishViewController.h"
#import "SGImagePickerController.h"
#import "WDSecondGoodsTableVController.h"

@interface WDSecondPublishViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
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
    CGFloat _orderListMaxY;
}
@property(nonatomic,strong)NSMutableArray *areaListsArr;

@end

@implementation WDSecondPublishViewController

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
    
    _secondTitle.delegate = self;
    _secondPrice.delegate = self;
    _secondArea.delegate = self;
    _secondMobile.delegate = self;
    _secondContents.delegate = self;
    _secondMarks.delegate = self;
    
    _mainScrollView.delegate = self;
    
    [self _createUpLoadImageButton];
    
    [self _setupSelectedImageView];
    
    _sate = @"1";
    _orderListMaxY = 230;
    
    //   添加监听方法，UIKeyboardWillShowNotification这是系统为我们提供的监听关键字，也就是在将要调出键盘的时候可以监听到
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //  添加通知，当textView开始输入的时候隐藏 placeholderLabel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:self.secondMarks];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    [btn setImageEdgeInsets:UIEdgeInsetsMake(4, 3, 4,3)];
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

//  通知的方法
- (void)textDidChange{
    
    _myplaceholder.hidden = _secondMarks.hasText;
}

//  移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}


/** 创建上传图片按钮*/
- (void)_createUpLoadImageButton{
    
    _upLoadBtn = [[UIButton alloc]initWithFrame:self.secondPicsView.frame];
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
        
        for (UIImageView *subView in self.secondPicsView.subviews) {
            
            [subView removeFromSuperview];
        }
        
        if (thumbnails.count == 0) {
            
            [_upLoadBtn setTitle:@"选择图片上传" forState:UIControlStateNormal];
        }
        else{
        
        _photosArray = [NSMutableArray arrayWithArray:thumbnails];
        for (int i = 0; i < _photosArray.count; i++) {
            
            UIImageView *photosImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * (80+5), 0, 80, 60)];
            photosImageView.image = _photosArray[i];
            [self.secondPicsView addSubview:photosImageView];
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
    }
}];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

/** 设置选中小圆圈图片的状态*/
- (void)_setupSelectedImageView{
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _secondCompany.frame.origin.y-15, 40, 40)];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    _secondCompany.backgroundColor = KSYSTEM_COLOR;
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_secondPonsonal.frame)-15, _secondPonsonal.frame.origin.y-15, 40, 40)];
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
}

- (void)rightBtnAction:(UIButton *)right
{
    if (_isSelect)
    {
        _secondCompany.backgroundColor = KSYSTEM_COLOR;
        _sate = @"1";
        _secondPonsonal.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _secondPonsonal.backgroundColor = KSYSTEM_COLOR;
        _sate = @"2";
        _secondCompany.backgroundColor = [UIColor clearColor];
    }
    
    _isSelect =! _isSelect;
}

/** 发布按钮*/
- (IBAction)publishSecondBtnClick:(UIButton *)sender {
    
    [WDMainRequestManager requestPublishMySecondGoodsWithName:self.secondTitle.text region:self.secondArea.text money:self.secondPrice.text sate:_sate contacts:self.secondContents.text mobile:self.secondMobile.text media_ids:_mediaId content:self.secondMarks.text completion:^(NSString *result, NSString *error) {
        
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
                
                _secondCompany.backgroundColor = KSYSTEM_COLOR;
                _secondPonsonal.backgroundColor = [UIColor clearColor];
                _secondTitle.text = @"";
                _secondArea.text = @"";
                _secondPrice.text = @"";
                _secondContents.text = @"";
                _secondMobile.text = @"";
                _secondMarks.text = @"";
                _myplaceholder.text = @"详细介绍";
                
                for (UIImageView *imageV in self.secondPicsView.subviews) {
                    
                    [imageV removeFromSuperview];
                }
                [_upLoadBtn setTitle:@"选择图片上传" forState:UIControlStateNormal];
            }];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
        }
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGFloat bottomH = kScreenHeight - CGRectGetMaxY(_secondPublishBtn.frame) - 64;
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
    self.secondArea.text = model.name;
    [tableView removeFromSuperview];
    self.secondAreaBtn.enabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _mainScrollView) {
        
        [_orderTabelView removeFromSuperview];
        self.secondAreaBtn.enabled = YES;
        
        CGFloat offSetY = scrollView.contentOffset.y;
        _upLoadBtn.y = 70 - offSetY;
        _orderListMaxY = 230 - offSetY;
        _leftBtn.y = 350 - offSetY;
        _rightBtn.y = 350 - offSetY;
    }
}

#pragma mark - buttonClick
/** 下拉选择地址*/
- (IBAction)areaOrderListClick:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    [WDMainRequestManager requestLoadAreaWithCompletion:^(NSMutableArray *dataArray, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        
        self.areaListsArr = dataArray;
        
        CGFloat tableH;
        CGFloat height = kScreenHeight - CGRectGetMaxY(self.secondArea.frame) - 60 - 64;
        CGFloat tatalH = 44*self.areaListsArr.count;
        
        if (height > tatalH) {
            
            tableH = tatalH;
        }else{
            
            tableH = height;
        }
        
        _orderTabelView = [[UITableView alloc] initWithFrame:CGRectMake(self.secondArea.x, _orderListMaxY, self.secondArea.width, tableH) style:UITableViewStylePlain];
        _orderTabelView.delegate = self;
        _orderTabelView.dataSource = self;
        [self.view addSubview:_orderTabelView];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.contentView endEditing:YES];
}

@end
