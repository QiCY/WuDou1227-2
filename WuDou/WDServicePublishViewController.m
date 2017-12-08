//
//  WDServicePublishViewController.m
//  WuDou
//
//  Created by huahua on 16/10/21.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDServicePublishViewController.h"
#import "SGImagePickerController.h"
#import "WDSecondGoodsTableVController.h"

@interface WDServicePublishViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    UIButton *_upLoadBtn;  //上传图片按钮
    
    UIButton *_leftBtn;
    UIButton *_rightBtn;
    BOOL _isSelect;
    CGFloat _keyboardhight;  //键盘高度
    UITableView *_orderTabelView;  //下拉地区列表
    UITableView *_categoryTableView;  //类别下拉列表
    
    NSString *_sate;
    NSString *_cateId;
    NSMutableArray *_photosArray;
    
    NSString *_mediaId;
    CGFloat _orderListMaxY;
}
@property(nonatomic,strong)NSMutableArray *areaListsArr;
@property(nonatomic,strong)NSMutableArray *categoryListsArr;

@end

@implementation WDServicePublishViewController

- (NSMutableArray *)areaListsArr{
    
    if (!_areaListsArr) {
        
        _areaListsArr = [NSMutableArray array];
    }
    
    return _areaListsArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的便民服务";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    _serviceTitle.delegate = self;
    _serviceRegion.delegate = self;
    _categoryTextField.delegate = self;
    _serviceMobile.delegate = self;
    _serviceContents.delegate = self;
    _serviceMarks.delegate = self;
    
    _mainScrollView.delegate = self;
    
    _sate = @"1";
    _orderListMaxY = 180;
    [self _createUpLoadImageButton];
    
    [self _setupSelectedImageView];
    
    //   添加监听方法，UIKeyboardWillShowNotification这是系统为我们提供的监听关键字，也就是在将要调出键盘的时候可以监听到
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //  添加通知，当textView开始输入的时候隐藏 placeholderLabel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification  object:self.serviceMarks];
}

//  自定义导航栏返回按钮
- (void)_setupNavigation{
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 15, 20);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
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
    
    _servicePlaceholder.hidden = _serviceMarks.hasText;
}

//  移除通知
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:UITextViewTextDidChangeNotification];
}

/** 创建上传图片按钮*/
- (void)_createUpLoadImageButton{
    
    _upLoadBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_servicePicsView.frame), CGRectGetMinY(_servicePicsView.frame), _servicePicsView.bounds.size.width, _servicePicsView.bounds.size.height)];
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
        
        for (UIImageView *subView in self.servicePicsView.subviews) {
            
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
            [self.servicePicsView addSubview:photosImageView];
        }
        [_upLoadBtn setTitle:@"" forState:UIControlStateNormal];
        
        //  上传图片，拿到media_id
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *cate = @"2";
        
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
    
    _leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, _serviceCompany.frame.origin.y-15, 40, 40)];
    _leftBtn.backgroundColor = [UIColor clearColor];
    _serviceCompany.backgroundColor = KSYSTEM_COLOR;
    [_leftBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftBtn];
    
    _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(_servicePersonal.frame)-15, _servicePersonal.frame.origin.y-15, 40, 40)];
    _rightBtn.backgroundColor = [UIColor clearColor];
    [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightBtn];
    
}

- (void)rightBtnAction:(UIButton *)right
{
    if (_isSelect)
    {
        _serviceCompany.backgroundColor = KSYSTEM_COLOR;
        _sate = @"1";
        _servicePersonal.backgroundColor = [UIColor clearColor];
    }
    else
    {
        _servicePersonal.backgroundColor = KSYSTEM_COLOR;
        _sate = @"2";
        _serviceCompany.backgroundColor = [UIColor clearColor];
    }
    
    NSLog(@"_sate = %@",_sate);
    _isSelect =! _isSelect;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    CGFloat bottomH = kScreenHeight - CGRectGetMaxY(_servicePublishBtn.frame) - 64;
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
    
    if (tableView == _orderTabelView) {
        
        return self.areaListsArr.count;
    }else{
        
        return self.categoryListsArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"areaOrderCell"];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"areaOrderCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (tableView == _orderTabelView) {
        
        WDAreaModel *model = self.areaListsArr[indexPath.row];
        cell.textLabel.text = model.name;
    }
    if (tableView == _categoryTableView) {
        
        WDAreaModel *model = self.categoryListsArr[indexPath.row];
        cell.textLabel.text = model.name;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _orderTabelView) {
        
        WDAreaModel *model = self.areaListsArr[indexPath.row];
        self.serviceRegion.text = model.name;
        [tableView removeFromSuperview];
        self.serviceAreaBtn.enabled = YES;
    }
    if (tableView == _categoryTableView) {
        
        WDAreaModel *model = self.categoryListsArr[indexPath.row];
        self.categoryTextField.text = model.name;
        _cateId = model.code;
        [tableView removeFromSuperview];
        self.categoryBtn.enabled = YES;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _mainScrollView) {
        
        [_orderTabelView removeFromSuperview];
        [_categoryTableView removeFromSuperview];
        self.serviceAreaBtn.enabled = YES;
        
        CGFloat offSetY = scrollView.contentOffset.y;
        _upLoadBtn.y = 70 - offSetY;
        _orderListMaxY = 180 - offSetY;
        _leftBtn.y = 305 - offSetY;
        _rightBtn.y = 305 - offSetY;
    }
}

#pragma mark - UIButton Action
/** 下拉区域列表*/
- (IBAction)serviceOrderListClick:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    if (_categoryTableView) {
        
        self.categoryBtn.enabled = YES;
        [_categoryTableView removeFromSuperview];
    }
    
    [WDMainRequestManager requestLoadAreaWithCompletion:^(NSMutableArray *dataArray, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        self.areaListsArr = dataArray;
        
        CGFloat tableH;
        CGFloat height = kScreenHeight - CGRectGetMaxY(self.serviceRegion.frame) - 60 - 64;
        CGFloat tatalH = 44*self.areaListsArr.count;
        
        if (height > tatalH) {
            
            tableH = tatalH;
        }else{
            
            tableH = height;
        }
        
        _orderTabelView = [[UITableView alloc] initWithFrame:CGRectMake(self.serviceRegion.x, _orderListMaxY, self.serviceRegion.width, tableH) style:UITableViewStylePlain];
        _orderTabelView.layer.borderWidth = 1;
        _orderTabelView.layer.borderColor = kViewControllerBackgroundColor.CGColor;
        _orderTabelView.delegate = self;
        _orderTabelView.dataSource = self;
        [self.view addSubview:_orderTabelView];
    }];
}

/** 分类列表*/
- (IBAction)categoryBtnClick:(UIButton *)sender {
    
    sender.enabled = NO;
    
    [self.view endEditing:YES];
    
    if (_orderTabelView) {
        
        self.serviceAreaBtn.enabled = YES;
        [_orderTabelView removeFromSuperview];
    }
    
    [WDMainRequestManager requestLoadCategoryListWithCompletion:^(NSMutableArray *dataArray, NSString *error) {
        
        if (error) {
            SHOW_ALERT(error)
            return ;
        }
        self.categoryListsArr = dataArray;
        
        CGFloat tableH;
        CGFloat height = kScreenHeight - CGRectGetMaxY(self.categoryTextField.frame) - 60 - 64;
        CGFloat tatalH = 44*self.categoryListsArr.count;
        
        if (height > tatalH) {
            
            tableH = tatalH;
        }else{
            
            tableH = height;
        }
        
        _categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.categoryTextField.x, _orderListMaxY+50, self.categoryTextField.width, tableH) style:UITableViewStylePlain];
        _categoryTableView.layer.borderWidth = 1;
        _categoryTableView.layer.borderColor = kViewControllerBackgroundColor.CGColor;
        _categoryTableView.delegate = self;
        _categoryTableView.dataSource = self;
        [self.view addSubview:_categoryTableView];
    }];
    
}

/** 发布按钮*/
- (IBAction)servicePublishBtnClick:(UIButton *)sender {
    
    [WDMainRequestManager requestPublishMyServerWithName:self.serviceTitle.text region:self.serviceRegion.text sate:_sate cateId:_cateId contacts:self.serviceContents.text mobile:self.serviceMobile.text media_ids:_mediaId content:self.serviceMarks.text completion:^(NSString *result, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
        }
        else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:result preferredStyle:UIAlertControllerStyleAlert];
            
            //  确定
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                WDSecondGoodsTableVController *secondVC = [[WDSecondGoodsTableVController alloc] init];
                secondVC.navTitle = @"我的便民服务";
                [self.navigationController pushViewController:secondVC animated:YES];
                
                _serviceCompany.backgroundColor = KSYSTEM_COLOR;
                _servicePersonal.backgroundColor = [UIColor clearColor];
                _serviceTitle.text = @"";
                _serviceRegion.text = @"";
                _categoryTextField.text = @"";
                _serviceContents.text = @"";
                _serviceMobile.text = @"";
                _serviceMarks.text = @"";
                _servicePlaceholder.text = @"详细介绍";
                
                for (UIImageView *imageV in self.servicePicsView.subviews) {
                    
                    [imageV removeFromSuperview];
                }
                [_upLoadBtn setTitle:@"选择图片上传" forState:UIControlStateNormal];
            }];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
        }
    }];
    
}

@end
