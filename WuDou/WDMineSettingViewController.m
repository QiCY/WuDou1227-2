//
//  WDMineSettingViewController.m
//  WuDou
//
//  Created by huahua on 16/8/6.
//  Copyright © 2016年 os1. All rights reserved.
//  我的账户 -- 设置

#import "WDMineSettingViewController.h"
#import "WDMineSettingCell.h"
#import "WDChoiceView.h"
#import "WDFixPasswordViewController.h"
#import "WDTabbarViewController.h"
#import "WDLoginViewController.h"
#import "WDWebViewController.h"
#import "JPUSHService.h"

@interface WDMineSettingViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray *_leftLabelArray;
    NSArray *_rightLabelArray;
    NSArray *_showBtnArray;
    NSString *_mediaId;
}
@property(nonatomic,strong)WDUserMsgModel *model;

@end

static NSString *string = @"WDMineSettingCell";
@implementation WDMineSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的设置";
    //  设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:17], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _setupNavigation];
    
    [self _setupArrays];
    
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    
    [_settingTableView registerNib:[UINib nibWithNibName:@"WDMineSettingCell" bundle:nil] forCellReuseIdentifier:string];
    
    [self _caculater];
    [self _loadUserMsg];
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

/* 加载用户信息 **/
- (void)_loadUserMsg
{
    [WDMineManager requestUserMsgWithInformation:@"2" Completion:^(WDUserMsgModel *userMsg, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
            return ;
        }
        
        self.model = userMsg;
        [self.headerView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar]];
        
        [_settingTableView reloadData];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (_settingTableView != nil) {
        
        [_settingTableView reloadData];  //刷新单元格，让清除缓存之后再次加载的数据显示出来
    }
}

/* 初始化数组数据 **/
- (void)_setupArrays{
    
    _leftLabelArray = @[@"用户名",@"登录密码",@"清除缓存",@"关于我们"];
    _showBtnArray = @[@0,@1,@1,@1];
}

/* 缓存 **/
- (float)_caculater{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //  SDWebImage图片缓存
    NSString *sdPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default/com.hackemist.SDWebImageCache.default"];
    NSArray *sdArray = [manager contentsOfDirectoryAtPath:sdPath error:nil];
    float mb1 = [self calculateFiles:sdArray withPath:sdPath];
    
    //  网页加载图片缓存
    NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/com.WuDou/fsCachedData"];
    NSArray *webArray = [manager contentsOfDirectoryAtPath:webPath error:nil];
    float mb2 = [self calculateFiles:webArray withPath:webPath];
    
    float allMb = mb1 + mb2;  //  总的缓存数
    
    return allMb;
}

/** 计算缓存数据*/
- (float)calculateFiles:(NSArray *)array withPath:(NSString *)path{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    float a = 0;  //  初始化一个数用来接收所有的缓存
    
    for (NSString *itemName in array) {
        
        NSString *itemPath = [path stringByAppendingPathComponent:itemName];  //拼接文件路径，在path后面直接拼接路径名itemPath
        
        NSDictionary *dic = [manager attributesOfItemAtPath:itemPath error:nil];  //获取该文件夹里的相关信息，我们要的是字典中的 NSFileSize 值
        
        a += [dic[@"NSFileSize"] floatValue];
    }
    
    float mb = a/1024/1024;  //将输出的单位B转换为Mb
    return mb;
}


//  退出登录
- (IBAction)logout:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"退出当前账户？" preferredStyle:UIAlertControllerStyleAlert];
    
    //用模态的方法显示对话框
    [self presentViewController:alert animated:YES completion:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [WDMineManager requestExitLoginWithCompletion:^(WDAppInit *appInit, NSString *error) {
           
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            UIWindow * window = [[UIApplication sharedApplication].delegate window];
            WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
            window.rootViewController = tabbar;
            
            [JPUSHService setAlias:@"" callbackSelector:@selector(getPush) object:nil];
        }];        
       
    }];
    [alert addAction:sure];

}
-(void)getPush
{
    
}

/** 修改用户头像*/
- (IBAction)changeHeaderImage:(UIButton *)sender {
    
    NSLog(@"修改用户头像");
    
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"选择照片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // 取消
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       
    }];
    [alertView addAction:cancelBtn];
    
    // 拍照
    UIAlertAction *photoBtn = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // 判断摄像头是否可用
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] || [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {
            
            // 跳转到相机界面
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }else{
            SHOW_ALERT(@"当前相机设备不可用！")
        }
        
        
    }];
    [alertView addAction:photoBtn];
    
    // 打开相册
    UIAlertAction *albumBtn = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    [alertView addAction:albumBtn];
    
    [self presentViewController:alertView animated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WDMineSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:string forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        cell.rightLabel.text = self.model.username;
    }
    
    if (indexPath.row == 1) {
        
        cell.rightLabel.text = @"修改密码";
    }
    if (indexPath.row == 2) {
        
        cell.rightLabel.text = [NSString stringWithFormat:@"%.1fMb",[self _caculater]];
        
    }
    if (indexPath.row == 3) {
        
        cell.rightLabel.text = nil;
    }
    
    cell.contentView.backgroundColor = kViewControllerBackgroundColor;
    cell.leftLabel.text = _leftLabelArray[indexPath.row];
    cell.showBtnImageViewEnabled = [_showBtnArray[indexPath.row] integerValue];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"修改用户名" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertV.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alertV show];
    }
    
    if (indexPath.row == 1) {
        
        WDFixPasswordViewController *fixPasswordVC = [[WDFixPasswordViewController alloc] init];
        
        [self.navigationController pushViewController:fixPasswordVC animated:YES];
    }
    
    if (indexPath.row == 2) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"真的要清除吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:cancel];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSFileManager *manager = [NSFileManager defaultManager];
            
            NSString *sdPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/default/com.hackemist.SDWebImageCache.default"];
            NSString *webPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/osclass1.WuDou/fsCachedData"];
            
            [manager removeItemAtPath:sdPath error:nil];
            [manager removeItemAtPath:webPath error:nil];  //删除文件，清除缓存
            
            [tableView reloadData];  //刷新单元格，从而刷新数据，让其变为0
            
        }];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];  //用模态的方法显示对话框
    }
    
    if (indexPath.row == 3) {
        
        WDWebViewController *webVC = [[WDWebViewController alloc]init];
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        webVC.urlString = [NSString stringWithFormat:@"%@wapapp/about.html?access_token=%@",HTML5_URL,token];
        webVC.navTitle = @"关于我们";
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        
        //得到输入框
        UITextField *tf = [alertView textFieldAtIndex:0];
        self.model.username = tf.text;
        [_settingTableView reloadData];
        
        // 上传到服务器
        [WDMineManager requestChangeUserNameWithName:tf.text completion:^(WDAppInit *appInit, NSString *error) {
           
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
            NSLog(@"修改用户名成功！");
        }];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headerView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //  上传图片，拿到media_id
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *cate = @"4";
    
    NSString *urlStr = [NSString stringWithFormat:@"%@media/?access_token=%@&cate=%@",HTML5_URL,token,cate];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"image" mimeType:@"image/jpeg"];
    
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *media_ids = responseObject[@"media_ids"];
            
            _mediaId = media_ids;
            
            // 修改用户头像
            [WDMineManager requestChangeUserHeaderImageWithMediaIds:_mediaId completion:^(NSString *result, NSString *error) {
               
                if (error) {
                    
                    SHOW_ALERT(error)
                    return ;
                }
                
                SHOW_ALERT(result)
                
            }];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@",error);
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
