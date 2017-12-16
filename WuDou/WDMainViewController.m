//
//  WDMainViewController.m
//  WuDou
//
//  Created by huahua on 16/8/4.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDMainViewController.h"
#import "WDLunBoView.h"
#import "WDExtentionCollectionView.h"
#import "WDTejiaCell.h"
#import "WDNearStoreCell.h"
#import "WDGoodChoiceColllectionView.h"
#import "WDLoginViewController.h"
#import "WDSearchViewController.h"
#import "WDRecommendCell.h"
#import "WDGoodsInfoViewController.h"
#import "WDNearDetailsViewController.h"
#import "WDNewsViewController.h"
#import "WDAreaTableViewController.h"
#import "WDScanViewController.h"
#import "WDGoodList.h"
#import "WDWebViewController.h"
#import "WDMoreTejiaViewController.h"
#import "WDScrollView.h"
#import "MJChiBaoZiHeader.h"
#import "WDCountDown.h"
#import "StoreTableViewCell.h"
#import <CoreLocation/CoreLocation.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CDTitleRolling/DCTitleRolling.h"
#import "WDStoreDetailViewController.h"
#define kEdgeLine 5  //行间距
#define kEdgeClown 10  //列间距
#define kScaleSize 0.5  //图片缩放比例
#define kSeparationLineWidth 1  //分隔线宽度

@interface WDMainViewController ()<WDLunBoViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CLLocationManagerDelegate,StoreCellDelegate,CDDRollingDelegate>
{
    UIImageView *_launchImageView;  //启动图片
    WDLunBoView *_lunboView1;  //第一个轮播器
    WDLunBoView *_lunboView2;  //第一个轮播器
    WDLunBoView *_lunboView3;  //第一个轮播器
    WDLunBoView *_recommandLunbo;  //品牌推荐轮播
    WDExtentionCollectionView *_extentionCV;  //分类按钮
    WDGoodChoiceColllectionView *_goodChoiceCV;  //优选商品
    
    UIView *_tejiaView;
    UICollectionView *_tejiaCollectionView;  //今日特价底部商品
    UITableView *_nearStoreTableView;  //附近店铺单元格
    UIView *separationView;
    UIView *_recommendView;  //品牌推荐视图
    UICollectionView *recommendCollectionView;
    UIView *_bottomView;  //底部优选商品视图
    UIView *_publicNewsView;  //公告
    WDScrollView *_publicScroll1;  //上公告轮播
    WDScrollView *_publicScroll2;  //下公告轮播
    WDCountDown *_countDown;
    
    NSMutableArray *_lunboImagesArray;  //轮播器中的所有图片
    NSArray *_extentionImageArray;  //分类按钮图片数组
    NSArray *_extentionTitleArray;  //分类按钮名称数组
//    NSMutableArray *_teJiaImageArray;  //今日特价商品图片数组
    NSMutableArray *_tejiaShopNameArray;  //今日特价商品名称数组
    NSMutableArray *_tejiaShopPriceArray;  //今日特价商品价格数组
    NSMutableArray *_recommendArray;  //品牌推荐图片数组
    
    CGFloat itemHeight;
}

@property (nonatomic, strong)dispatch_source_t time;
@property (nonatomic, strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UIImageView *noticeImgView;
@property(nonatomic,strong)UIImageView *footerImgView,*nearStoreHeadImg;
@property(nonatomic,strong)UIScrollView *nearByMenuScroll;
@property(nonatomic,strong)NSMutableArray *menuList;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIView *footLine;
@property(nonatomic,strong)NSMutableArray *recommendAdList;
@property(nonatomic,strong)NSMutableArray *recommendGoodsList;
@property(nonatomic,strong)DCTitleRolling *titleRollingView;
@end

static NSString *string = @"WDNearStoreCell";
static NSString *teijia = @"teijia";
static NSString *recommend = @"recommend";
@implementation WDMainViewController

- (CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc] init];
        
    }
    return _locationManager;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    //创建一个用于数据库的表
    [WDGoodList creatTable];
    
    //清空数据库所有数据，测试用
//    [WDGoodList clearAllDatas];
    
    //  设置内容尺寸
//    _mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_nearStoreTableView.frame));
    [self createFooterImgView];
    
    //  为了增大导航栏上方小按钮的点击响应区域，在按钮上加一个UIControl
    UIControl *saoMa = [[UIControl alloc]initWithFrame:CGRectMake(5, 22, 40, 40)];
    saoMa.backgroundColor = [UIColor clearColor];
    [saoMa addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:saoMa];
    
    UIControl *chart = [[UIControl alloc]initWithFrame:CGRectMake(self.chatImage.x-10, 22, 40, 40)];
    chart.backgroundColor = [UIColor clearColor];
    [chart addTarget:self action:@selector(chartAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:chart];
    
}

//  扫码  点击方法
- (void)scanCodeAction:(UIControl *)saoMa
{
    NSString * mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied)
    {
        SHOW_ALERT(@"未开启照相功能，请去设置开启应用的照相功能！");
    }
    else
    {
        WDScanViewController * scanVC = [[WDScanViewController alloc] init];
        [self.navigationController pushViewController:scanVC animated:YES];
    }
}

//  聊天  点击方法
- (void)chartAction:(UIControl *)chart{
    
    WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=1&sid=0&pid=0",HTML5_URL,token];
    webVC.requestUrl = urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //  隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    
    [_searchTextField resignFirstResponder];  //首先要收回键盘
    self.topView.backgroundColor = KSYSTEM_COLOR;
    NSString * title;
    if (self.mytitle != nil)
    {
        title = self.mytitle;
        self.loctionLab.text = title;
        // 将当前位置信息（区域）更新保存
        if (self.loctionLab.text && ![self.loctionLab.text isEqualToString:@""]) {
            
            [self dataWithLoction:self.loctionLab.text];
            [self _updateDatas];
        }
    }
}

/** 选择区域后更新数据*/
- (void)_updateDatas{
    
    [WDMainRequestManager requestMainDatasWithCompletion:^(NSMutableArray *array, NSString *countDown, NSString *error) {
        
        if (error) {
           
            return ;
        }
        
        NSLog(@"%s",__func__);
        if (self.allModelArr.count != 0) {
            
            [self.allModelArr removeAllObjects];
        }
        self.allModelArr = array;
        
        self.allAdverArr = self.allModelArr[0];
        
        self.oneLunArr = self.allAdverArr[0];
        NSMutableArray *imageArray1 = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.oneLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray1 addObject:imageUrl];
        }
        if (imageArray1.count == 0) {
            
            _lunboView1.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _lunboView1.imageURLStringsGroup = imageArray1;
        }
        
        self.threeLunArr = self.allAdverArr[2];
        NSMutableArray *imageArray3 = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.threeLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray3 addObject:imageUrl];
        }
        if (imageArray3.count == 0) {
            
            _lunboView3.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _lunboView3.imageURLStringsGroup = imageArray3;
        }
        
        self.fourLunArr = self.allAdverArr[3];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.fourLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray addObject:imageUrl];
        }
        
        CGFloat allSeconds = [countDown floatValue];
        CGFloat allDays = allSeconds/24.0/60.0/60.0;
        _countDown.day = allDays;
        _countDown.hour = (allDays - _countDown.day)*24;
        _countDown.minute = ((allDays - _countDown.day)*24 - _countDown.hour)*60;
        _countDown.second = (((allDays - _countDown.day)*24 - _countDown.hour)*60 - _countDown.minute)*60;
        
        _recommendArray = imageArray;
        [recommendCollectionView reloadData];
        
        self.teJiaArr = self.allModelArr[1];
        [_tejiaCollectionView reloadData];
        
        // 热点
        self.allNewsArr = self.allModelArr[4];
        self.newsArr = [NSMutableArray array];
        if (self.allNewsArr.count != 0) {  //有热点
             NSMutableArray *titleList = [[NSMutableArray alloc] init];
            for (WDNewsModel *model in self.allNewsArr) {
                NSString *title = model.title;
                [titleList addObject:title];
            }
            NSMutableArray *titleList1 = [[NSMutableArray alloc] init];
            for (int i = titleList.count-1;i>=0;i--) {
                WDNewsModel *model = titleList[i];
                [titleList1 addObject:model];
            }
             [self.newsArr addObject:titleList];
            [self.newsArr addObject:titleList1];
            [self createDcTitleView:self.newsArr];
        }else{
            [self createDcTitleView:@[@[@"暂无热点"],@[@"暂无热点"]]];
        }
//            _publicScroll1.titleArray = self.newsArr;
//            _publicScroll1.titleFont = 14.0;
//
//            NSString *lastTitle = [self.newsArr lastObject];
//            [self.newsArr removeLastObject];
//            [self.newsArr insertObject:lastTitle atIndex:0];
//            _publicScroll2.titleArray = self.newsArr;
//            _publicScroll2.titleFont = 14.0;
//        }
//        else{
//
//            for (UIView *subV in _publicNewsView.subviews) {
//
//                [subV removeFromSuperview];
//            }
//        }
        NSDictionary *recommendData = self.allModelArr.lastObject;
        self.recommendGoodsList = recommendData[@"goodsList"];
        
        
        [self refreshContentView];
        _goodChoiceCV.goodsData = self.allModelArr.lastObject;
        [_goodChoiceCV reloadData];
//        _goodChoiceCV.datasArray = self.allModelArr[3];
//        [_goodChoiceCV reloadData];
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuList = [[NSMutableArray alloc] init];
    self.nearStoreArr = [[NSMutableArray alloc] init];
    self.recommendAdList = [NSMutableArray new];
    self.recommendGoodsList = [NSMutableArray new];
//    sleep(1.0);
    
    NSString *string = @"WuDou";  //注意这里的键名一定要与AppDelegate类中的键名相同
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@1 forKey:string];  //设置键值为1，此时AppDelegate类中的result就有值了
    [userDefaults synchronize];  //同步数据
    
    NSString *isshow = [[NSUserDefaults standardUserDefaults] objectForKey:@"SHOWIMAGE"];
    if ([isshow isEqualToString:@"1"]) {
        
//        [self _createLaunchImage];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SHOWIMAGE"];
    }
    else{
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD show];
        
    }
    self.view.backgroundColor = kViewControllerBackgroundColor;
    
    [self _getModelData];
    
    //搭建UI界面
    [self setUI];
    
    [self.searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(haveReceiveMsg:) name:@"HAVEMSG" object:nil];
    
}


/** 创建启动图片*/
- (void)_createLaunchImage{
    
    _launchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _launchImageView.image = [UIImage imageNamed:@"LaunchImage_750x1334"];
    self.tabBarController.tabBar.hidden = YES;
    
    [self.view addSubview:_launchImageView];
}

/** 监听通知的方法：改变图标状态*/
- (void)haveReceiveMsg:(NSNotification *)noti{
    
    NSString *result = noti.userInfo[@"RESULT"];
    if ([result isEqualToString:@"1"]) {

        [self.msgImageView setImage:[UIImage imageNamed:@"xiaoxi11"]];
        
    }else{
        
        [self.msgImageView setImage:[UIImage imageNamed:@"消息图标-1"]];
    }
}

/** 移除通知*/
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HAVEMSG" object:nil];
}

// 设置状态栏样式为高亮（白色）
- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

/** 解析数据*/
- (void)_getModelData{

    //  判断用户是否打开定位功能
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //更新定位点，刷新当前的位置信息
            [self _setLoction];
        }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
         SHOW_ALERT(@"未开启位置权限！请去“设置”中开启定位功能。")
    }
    
    
    NSLog(@"refresh content data ---------------------------------");
    [WDMainRequestManager requestMainDatasWithCompletion:^(NSMutableArray *array,NSString *countDown, NSString *error) {
        
        if (error) {
            
            // 拿到当前的下拉刷新控件，结束刷新状态
            [_mainScrollView.mj_header endRefreshing];
            return ;
        }
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [_mainScrollView.mj_header endRefreshing];
        
        self.allModelArr = array;
        
        self.allAdverArr = self.allModelArr[0];
        
        self.oneLunArr = self.allAdverArr[0];
        NSMutableArray *imageArray1 = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.oneLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray1 addObject:imageUrl];
        }
        if (imageArray1.count == 0) {
            
            _lunboView1.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _lunboView1.imageURLStringsGroup = imageArray1;
        }
        
        self.threeLunArr = self.allAdverArr[2];
        NSMutableArray *imageArray3 = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.threeLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray3 addObject:imageUrl];
        }
        if (imageArray3.count == 0) {
            
            _lunboView3.imageURLStringsGroup = [NSMutableArray arrayWithObject:@"http://pic.baa.bitautotech.com/img/V2img4.baa.bitautotech.com/space/2011/03/04/b1c2da5e-52a6-4d9c-a67c-682a17fb8cb0_735_0_max_jpg.jpg"];
        }else{
            
            _lunboView3.imageURLStringsGroup = imageArray3;
        }
        
        self.fourLunArr = self.allAdverArr[3];
        NSMutableArray *imageArray = [[NSMutableArray alloc]init];
        for (WDAdvertisementModel *model in self.fourLunArr) {
            
            NSString *imageUrl = model.img;
            [imageArray addObject:imageUrl];
        }
        
        CGFloat allSeconds = [countDown floatValue];
        CGFloat allDays = allSeconds/24.0/60.0/60.0;
        _countDown.day = allDays;
        _countDown.hour = (allDays - _countDown.day)*24;
        _countDown.minute = ((allDays - _countDown.day)*24 - _countDown.hour)*60;
        _countDown.second = (((allDays - _countDown.day)*24 - _countDown.hour)*60 - _countDown.minute)*60;
        
        _recommendArray = imageArray;
        [recommendCollectionView reloadData];

        self.teJiaArr = self.allModelArr[1];
        [_tejiaCollectionView reloadData];
        
        // 热点
        self.allNewsArr = self.allModelArr[4];
        self.newsArr = [NSMutableArray array];
        if (self.allNewsArr.count != 0) {  //有热点
             NSMutableArray *titleList = [[NSMutableArray alloc] init];
            for (WDNewsModel *model in self.allNewsArr) {
               
                NSString *title = model.title;
                [titleList addObject:title];
                
            }
         
            NSMutableArray *titleList1 = [[NSMutableArray alloc] init];
            for (int i = (titleList.count-1);i>=0;i--) {
                WDNewsModel *model = titleList[i];
                [titleList1 addObject:model];
            }
            [self.newsArr addObject:titleList];
            [self.newsArr addObject:titleList1];
            [self createDcTitleView:self.newsArr];
        }else{
            [self createDcTitleView:@[@"暂无热点"]];
        }
//            _publicScroll1.titleArray = self.newsArr;
//            _publicScroll1.titleFont = 14.0;
//
//            NSString *lastTitle = [self.newsArr lastObject];
//            [self.newsArr removeLastObject];
//            [self.newsArr insertObject:lastTitle atIndex:0];
//            _publicScroll2.titleArray = self.newsArr;
//            _publicScroll2.titleFont = 14.0;
//        }
//        else{
//
//            for (UIView *subV in _publicNewsView.subviews) {
//
//                [subV removeFromSuperview];
//            }
//        }
//        self.nearStoreArr = self.allModelArr[2];
        
       

        NSDictionary *recommendData = self.allModelArr.lastObject;
        self.recommendGoodsList = recommendData[@"goodsList"];
         [self refreshContentView];
        _goodChoiceCV.goodsData = self.allModelArr.lastObject;
        [_goodChoiceCV reloadData];
        if (_launchImageView) {
            
            sleep(1.0);
            [_launchImageView removeFromSuperview];
             self.tabBarController.tabBar.hidden = NO;
        }
        else{
            
            [SVProgressHUD dismiss];
        }
        
    }];
    
}
- (CGFloat)getGoodsChoiceViewHeight:(NSMutableArray *)goodsList{
    CGFloat h = 0;
    for (int i = 0; i<goodsList.count; i++) {
        NSArray *list = goodsList[i];
        int row = (int)list.count/3;
        int colom = list.count%3;
        if (colom>0) {
            row = row+1;
        }
        h= h + row*181.5+kScreenWidth/8*3;
    }
    return h;
}

-(void)refreshContentView{
    _tejiaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_publicNewsView.frame), kScreenWidth, 195)];
    
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(_lunboView3.frame), kScreenWidth,   [self getGoodsChoiceViewHeight:self.recommendGoodsList]+5);
    _goodChoiceCV.frame = CGRectMake(0, 0, kScreenWidth, [self getGoodsChoiceViewHeight:self.recommendGoodsList]);
    NSLog(@"_goodVc height is %f",_goodChoiceCV.frame.size.height);
    _recommendView.frame = CGRectMake(0, CGRectGetMaxY(_bottomView.frame), kScreenWidth, itemHeight+40);
    _nearStoreHeadImg.frame = CGRectMake(0, CGRectGetMaxY(_recommendView.frame), kScreenWidth, kScreenWidth/8*3);
    _nearStoreTableView.frame = CGRectMake(0, CGRectGetMaxY(_nearStoreHeadImg.frame), kScreenWidth, self.nearStoreArr.count * 80+40);
    [self getMenuTypeList];

  
}
- (void)getMenuTypeList{
    [WDMainRequestManager requestNearByShopMenuCompletion:^(NSMutableArray *array, NSString *error) {
        
        if (self.menuList.count == 0) {
            [self.menuList addObjectsFromArray:array];
            [self setNearByShopMenu:self.menuList];
           
        }
         [self getStoreMenu:@"1"];
    }];
}
-(void)getStoreMenu:(NSString *)type{
    [WDMainRequestManager requestNearByShopMenuWithType:type completion:^(NSMutableArray *array, NSMutableArray *typeArray, NSString *error) {
        self.nearStoreArr = array;
//        [self updateNearStoreTableViewHeight:array];
        CGFloat h;
        for (WDNearbyStoreModel *model in array) {
            CGFloat rowH = [self getRowHeightWithData:model];
            h = h + rowH ;
        }
        _nearStoreTableView.frame = CGRectMake(0, _nearStoreTableView.frame.origin.y, kScreenWidth, h+40);
        //  设置内容尺寸
        [_nearStoreTableView reloadData];
        _mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_nearStoreTableView.frame));
    }];
}
-(void)updateNearStoreTableViewHeight:(NSMutableArray *)dataList{
    CGFloat h;
    for (WDNearbyStoreModel *model in dataList) {
        CGFloat rowH = [self getRowHeightWithData:model];
        h = h + rowH ;
    }
    _nearStoreTableView.frame = CGRectMake(0, _nearStoreTableView.frame.origin.y, kScreenWidth, h+40);
    //  设置内容尺寸
    [_nearStoreTableView reloadData];
    _mainScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(_nearStoreTableView.frame));
}
-(void)setNearByShopMenu:(NSMutableArray *)typelist{
    CGFloat width = kScreenWidth/5;
    for (int i = 0; i<typelist.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, 40)];
        button.tag = i;
        if (i==0) {
            button.selected = YES;
            _selectBtn = button;
        }
        [_nearByMenuScroll addSubview:button];
        _nearByMenuScroll.contentSize = CGSizeMake(typelist.count*width>kScreenWidth?typelist.count*100:kScreenWidth, 40);
        [button setTitle:typelist[i][@"name"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:KSYSTEM_COLOR forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        CGFloat textwidth = [self sizeWithText:_selectBtn.titleLabel.text font:_selectBtn.titleLabel.font];
        self.footLine.frame = CGRectMake((width- textwidth)/2, 33, textwidth, 2);
        [_selectBtn addSubview:self.footLine];
        [button addTarget:self action:@selector(nearByBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, _menuList.count*width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [_nearByMenuScroll addSubview:line];
}
-(void)nearByBtnClicked:(UIButton *)sender{
    [_footLine removeFromSuperview];
    _selectBtn.selected = !_selectBtn.selected;
    _selectBtn = sender;
    _selectBtn.selected = !_selectBtn.selected;
    NSString *type = _menuList[sender.tag][@"id"];
    [self getStoreMenu:type];
    CGFloat textwidth = [self sizeWithText:_selectBtn.titleLabel.text font:_selectBtn.titleLabel.font];
    CGFloat width = kScreenWidth/5;
    self.footLine.frame = CGRectMake((width- textwidth)/2, 33, textwidth, 2);
    [_selectBtn addSubview:self.footLine];
}
/** 搭建UI界面*/
- (void)setUI {
    
//    [self _setUpTestDatas];
    
    _searchTextField.delegate = self;
    
    //  创建第一个轮播器
    [self _createFirstLunboView];
//   创建banner图下
    [self createNoticeView];
    //  创建分类按钮
    [self _createExtentionBtn];
    
    //  创建第二个轮播器
//    [self _createSecondLunboView];
    
    //  创建公告
    [self _createPublicNews];
    
    //  创建今日特价视图
    [self _createTodayTejiaView];
    
    //  创建第三个轮播器
    [self _createThirdLunboView];
    
    //  创建优选商品视图
    [self _createGoodChoiceView];
    
    //  品牌推荐视图
    [self _createRecommandView];
    
    
    
    //  创建 附近店铺 视图
    [self _createNearStoreView];

    //  设置下拉刷新控件
    [self _setMJRefresh];
    
}

//设置定位点
- (void)_setLoction
{
    // 初始化定位管理器
//    self.locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精确度到米
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // 设置过滤器为无
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8))
    {
        // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
        [self.locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

//根据位置，刷新数据
-(void)dataWithLoction:(NSString *)loctionName
{
    [WDAppInitManeger requestUserAreaMsgWithRegionname:loctionName completion:^(WDAppInit *appInit, NSString *error)
    {
        if (error) {
            
            SHOW_ALERT(error)
        }
    }];
}
//根据经纬度，刷新数据
- (void)dataWithLatitudeAndLongitude:(NSString *)location{
    
    [WDAppInitManeger requestUserLocationMsgWithCoordinate:location completion:^(WDAppInit *appInit, NSString *error) {
       
        if (error) {
            
            SHOW_ALERT(error)
        }
        
    }];
}

//定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSString *locationInfo = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    //将经度显示到label上
    NSString * longitudeStr = [NSString stringWithFormat:@"%lf", newLocation.coordinate.longitude];
    //将纬度现实到label上
    NSString * latitudeStr = [NSString stringWithFormat:@"%lf", newLocation.coordinate.latitude];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    NSLog(@"%@   %@", longitudeStr,latitudeStr);
    NSString * tudeStr = [NSString stringWithFormat:@"%@/%@",longitudeStr,latitudeStr];
    [WDAppInitManeger saveStrData:tudeStr withStr:@"locTude"];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0)
        {
            CLPlacemark *placemark = [array objectAtIndex:0];
            //获得区号
            NSString * namestr = placemark.subLocality;
            //获取城市
            NSLog(@"所有信息 = %@-%@-%@-%@",placemark.thoroughfare, placemark.subThoroughfare, placemark.locality, placemark.subLocality);
            NSString *city = namestr;
            if (!city)
            {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.subLocality;
            }
            NSLog(@"city--- = %@", city);
            
            self.loctionLab.text = city;
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
        
        // 将当前位置信息（区域）更新保存
        if (self.loctionLab.text && ![self.loctionLab.text isEqualToString:@""])
        {
//            [self dataWithLoction:self.loctionLab.text];
            [self dataWithLatitudeAndLongitude:locationInfo];
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}
// 设置下拉刷新控件 /
- (void)_setMJRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJChiBaoZiHeader *header = [MJChiBaoZiHeader headerWithRefreshingTarget:self refreshingAction:@selector(_getModelData)];
    
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    
    // 马上进入刷新状态
//    [header beginRefreshing];
    
    // 设置header
    _mainScrollView.mj_header = header;
}

- (void)loadNewData{
    
    if (_allModelArr.count > 0) {
        
        [_allModelArr removeAllObjects];
        
        [self _getModelData];
        
        //更新定位点，刷新当前的位置信息
        [self _setLoction];
        
        //刷新所选区域的位置信息
//        if (self.loctionLab.text != nil)
//        {
//            // 将当前位置信息（区域）更新保存
//            if (self.loctionLab.text && ![self.loctionLab.text isEqualToString:@""]) {
//                
//                [self dataWithLoction:self.loctionLab.text];
//            }
//        }
    }
    // 拿到当前的下拉刷新控件，结束刷新状态
    [_mainScrollView.mj_header endRefreshing];
}


//  初始化测试数据
- (void)_setUpTestDatas
{
    
    NSString * image = @"noproduct.png";
    NSArray *testLunboArray = @[image];
    _lunboImagesArray = [NSMutableArray arrayWithArray:testLunboArray];
    
}

/* 创建第一个轮播器 **/
- (void)_createFirstLunboView
{
    CGFloat lunboH = kScreenWidth/8*3;
    _lunboView1 = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, 0, kScreenWidth, lunboH) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct"]];
//    _lunboView1.imageURLStringsGroup = _lunboImagesArray;
    _lunboView1.autoScrollTimeInterval = 3.5f;
    _lunboView1.pageControlBottomOffset = -12;
    _lunboView1.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    _lunboView1.currentPageDotColor = KSYSTEM_COLOR;
    _lunboView1.pageDotColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_lunboView1];
    
}

-(void)createNoticeView{
    _noticeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_lunboView1.frame), kScreenWidth, 27)];
    _noticeImgView.image = [UIImage imageNamed:@"banner图下"];
    [_mainScrollView addSubview:_noticeImgView];
}
/* 创建分类按钮 **/
- (void)_createExtentionBtn{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kScreenWidth/5.0-kEdgeClown, 80);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, kEdgeClown, 0, kEdgeClown);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;  //水平布局
    
    _extentionCV = [[WDExtentionCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_noticeImgView.frame)+5, kScreenWidth, 90) collectionViewLayout:flowLayout];
//    _extentionImageArray = @[@"果蔬图标.png",@"水果图标.png",@"粮油图标.png",@"超市图标.png",@"fenlei.png",@"吃货图标.png",@"家具图标.png",@"积分图标.png",@"全民图标.png",@"便民图标.png"];
//    _extentionTitleArray = @[@"蔬菜",@"精品水果",@"粮油调味",@"超市生鲜",@"分类",@"吃喝天地",@"居家生活",@"积分商城",@"二手专区",@"便民服务"];
    _extentionImageArray = @[@"果蔬图标.png",@"水果图标.png",@"粮油图标.png",@"超市图标.png",@"积分商城.png"];
    _extentionTitleArray = @[@"蔬菜",@"精品水果",@"粮油调味",@"超市便利",@"积分商城"];
    _extentionCV.dataImageArray = _extentionImageArray;
    _extentionCV.dataTitleArray = _extentionTitleArray;
    _extentionCV.superVC = self;
    _extentionCV.scrollEnabled = NO;
    [_mainScrollView addSubview:_extentionCV];
}
#pragma mark - <CDDRollingDelegate>
- (void)dc_RollingViewSelectWithActionAtIndex:(NSInteger)index
{
    NSLog(@"点击了第%zd头条滚动条",index);
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    WDNewsModel *model = self.allNewsArr[index];
    NSLog(@"1----%@-----%@",model.newsid,model.title);
    WDWebViewController *webV = [[WDWebViewController alloc] init];
    webV.navTitle = @"蔬心热点";
    webV.urlString = [NSString stringWithFormat:@"%@wapapp/hotnews.html?access_token=%@&newsid=%@",HTML5_URL,token,model.newsid];
    [self.navigationController pushViewController:webV animated:YES];
}

- (void)createDcTitleView:(NSArray *)dataArray{
    if (_titleRollingView) {
        [_titleRollingView removeFromSuperview];
    }
    
    _titleRollingView = [[DCTitleRolling alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) WithTitleData:^(CDDRollingGroupStyle *rollingGroupStyle, NSString *__autoreleasing *leftImage, NSArray *__autoreleasing *rolTitles, NSArray *__autoreleasing *rolTags, NSArray *__autoreleasing *rightImages, NSString *__autoreleasing *rightbuttonTitle, NSInteger *interval, float *rollingTime, NSInteger *titleFont, UIColor *__autoreleasing *titleColor, BOOL *isShowTagBorder) {
        
        *rollingTime = 0.2;
        *rightImages = @[];
        //        *rightImages = @[@"jshop_sign_layer_not",@"jshop_sign_layer_ok",@"jshop_sign_layer_not"];
        *rollingGroupStyle  = CDDRollingTwoGroup;
//        *rolTags = dataArray;
        *rolTitles = dataArray;
        *leftImage = @"redian";
        *interval = 4.0;
        *titleFont = 14;
        *titleColor = [UIColor blackColor];
        *isShowTagBorder = YES; //是否展示tag边框
        
    }];
    _titleRollingView.delegate = self;
    [_titleRollingView dc_beginRolling];
    _titleRollingView.backgroundColor = [UIColor whiteColor];
    [_publicNewsView addSubview:_titleRollingView];
    
    // 竖直分隔线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(80, 5, 1, 50)];
    line.backgroundColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
    [_publicNewsView addSubview:line];
}
/** 创建公告*/
- (void)_createPublicNews{
    
    _publicNewsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_extentionCV.frame), kScreenWidth, 60)];
    _publicNewsView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_publicNewsView];
    
    // 分隔线
//    [self _horizontalLineWithMaxY:0 superV:_publicNewsView];
    /*
    // 左边的图标
    UIImageView *logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 50, 50)];
    logoImg.image = [UIImage imageNamed:@"redian.jpg"];
    [_publicNewsView addSubview:logoImg];
    
    
    
    // 右边滚动的公告
    // 上公告
    _publicScroll1 = [[WDScrollView alloc] initWithFrame:CGRectMake(80, 5, kScreenWidth - 50, 25)];

    _publicScroll1.titleColor = [UIColor blackColor];
    _publicScroll1.BGColor = [UIColor whiteColor];
    [_publicScroll1 clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        WDNewsModel *model = self.allNewsArr[index-100];
        NSLog(@"1----%@-----%@",model.newsid,titleString);
        WDWebViewController *webV = [[WDWebViewController alloc] init];
        webV.navTitle = @"蔬心热点";
        webV.urlString = [NSString stringWithFormat:@"%@wapapp/hotnews.html?access_token=%@&newsid=%@",HTML5_URL,token,model.newsid];
        [self.navigationController pushViewController:webV animated:YES];
    }];
    [_publicNewsView addSubview:_publicScroll1];
    
    // 下公告
    _publicScroll2 = [[WDScrollView alloc] initWithFrame:CGRectMake(80, 30, kScreenWidth - 50, 25)];
    
    _publicScroll2.titleColor = [UIColor blackColor];
    _publicScroll2.BGColor = [UIColor whiteColor];
    [_publicScroll2 clickTitleLabel:^(NSInteger index,NSString *titleString) {
        
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSMutableArray *idArray = [NSMutableArray array];
        for (WDNewsModel *model in self.allNewsArr) {
            
            NSString *newsId = model.newsid;
            [idArray addObject:newsId];
        }
        NSString *lastId = [idArray lastObject];
        [idArray removeLastObject];
        [idArray insertObject:lastId atIndex:0];
        
        NSString *newsid = idArray[index-100];
        NSLog(@"2----%@-----%@",newsid,titleString);
        WDWebViewController *webV = [[WDWebViewController alloc] init];
        webV.navTitle = @"蔬心热点";
        webV.urlString = [NSString stringWithFormat:@"%@wapapp/hotnews.html?access_token=%@&newsid=%@",HTML5_URL,token,newsid];
        [self.navigationController pushViewController:webV animated:YES];
    }];
    [_publicNewsView addSubview:_publicScroll2];
     */
}

/* 创建第二个轮播器 **/
- (void)_createSecondLunboView{
    
    _lunboView2 = [WDLunBoView lunBoViewWithFrame:CGRectMake(kEdgeClown, CGRectGetMaxY(_publicNewsView.frame) + 5, kScreenWidth-kEdgeClown*2, 100) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
//    _lunboView2.imageURLStringsGroup = _lunboImagesArray;
    _lunboView2.autoScrollTimeInterval = 2.0f;
    _lunboView2.showPageControl = YES;
    _lunboView2.pageControlBottomOffset = -15;
    _lunboView2.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    _lunboView2.currentPageDotColor = [UIColor redColor];
    _lunboView2.pageDotColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_lunboView2];
    
}

/** 创建topView */
- (void)_createTopViewWithFrame:(CGRect)rect superV:(UIView *)view leftImage:(NSString *)imgName rightTitle:(NSString *)title{
    
    UIView *topView = [[UIView alloc] initWithFrame:rect];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-100)*0.5, -2, 30, 30)];
    leftImage.image = [UIImage imageNamed:imgName];
    [topView addSubview:leftImage];
    
    UILabel *rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftImage.frame), 8, 100 - 30, 20)];
    rightTitle.text = title;
    rightTitle.textColor = KSYSTEM_COLOR;
    rightTitle.font = [UIFont systemFontOfSize:16.0];
    [topView addSubview:rightTitle];
    if ([title isEqualToString:@"品牌推荐"]) {
        leftImage.frame = CGRectMake((kScreenWidth - 180)/2, 3, 180, 22);
        leftImage.image = [UIImage imageNamed:@"品牌推荐"];
        rightTitle.hidden = YES;
    }
    [view addSubview:topView];
}

/* 创建今日特价视图 **/
- (void)_createTodayTejiaView
{
    _tejiaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_publicNewsView.frame)+5, kScreenWidth, 205)];
    _tejiaView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_tejiaView];
    
    //  顶部“今日特价”
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, kScreenWidth - 60, 30)];
    topView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 4, 85, 22)];
    leftImage.image = [UIImage imageNamed:@"本周特价.png"];
    [topView addSubview:leftImage];
    
    UILabel *rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 70, 20)];
    rightTitle.text = @"本周特价";
    rightTitle.textColor = KSYSTEM_COLOR;
    rightTitle.font = [UIFont systemFontOfSize:16.0];
//    [topView addSubview:rightTitle];
    
    //  中间倒计时
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 40, 30)];
    titleLabel.text = @"剩余";
    titleLabel.textColor = KSYSTEM_COLOR;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    [topView addSubview:titleLabel];
    
    _countDown = [[WDCountDown alloc] initWithFrame:CGRectMake(150, 0, topView.width - 150, 30)];
    _countDown.font = [UIFont systemFontOfSize:15.0];
    _countDown.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:_countDown];
    
    [_tejiaView addSubview:topView];
    
    //  右边 “更多” 按钮
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 10, 60, 20)];
    [moreBtn setTitle:@"更多>>" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    moreBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//    moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [moreBtn setTitleColor:KSYSTEM_COLOR forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(seeMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_tejiaView addSubview:moreBtn];
    
    //  底部特价商品
    CGFloat itemWidth = kScreenWidth / 3.0;  //每一个商品的宽度
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    flow.itemSize = CGSizeMake(itemWidth, 165);
    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;  //横行滑动
    
    _tejiaCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 165) collectionViewLayout:flow];
    _tejiaCollectionView.delegate = self;
    _tejiaCollectionView.dataSource = self;
    _tejiaCollectionView.tag = 101;  //通过设定tag值来区分多个CollectionView的代理
    _tejiaCollectionView.showsHorizontalScrollIndicator = NO;
    _tejiaCollectionView.contentSize = CGSizeMake(itemWidth * self.teJiaArr.count, 165);
    _tejiaCollectionView.backgroundColor = [UIColor whiteColor];
    [_tejiaCollectionView registerNib:[UINib nibWithNibName:@"WDTejiaCell" bundle:nil] forCellWithReuseIdentifier:teijia];
    [_tejiaView addSubview:_tejiaCollectionView];
   
    //  横行分隔线
    [self _horizontalLineWithMaxY:40 superV:_tejiaView];
}

/** 水平分隔线*/
- (void)_horizontalLineWithMaxY:(CGFloat)maxY superV:(UIView *)superV{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, kScreenWidth, 1)];
//    line.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    line.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:250/255.0 alpha:1];
    [superV addSubview:line];
}

/** 查看更多*/
- (void)seeMoreBtn:(UIButton *)btn{
    
    WDMoreTejiaViewController *moreVC = [[WDMoreTejiaViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

/* 创建第三个轮播器 **/
- (void)_createThirdLunboView{
    
    _lunboView3 = [WDLunBoView lunBoViewWithFrame:CGRectMake(0, CGRectGetMaxY(_tejiaView.frame), kScreenWidth, kScreenWidth/3) delegate:self placeholderImage:[UIImage imageNamed:@"noproduct.png"]];
//    _lunboView3.imageURLStringsGroup = _lunboImagesArray;
    _lunboView3.autoScrollTimeInterval = 3.5f;
    _lunboView3.showPageControl = YES;
    _lunboView3.pageControlBottomOffset = -15;
    _lunboView3.pageControlAliment = WDLunBoViewPageContolAlimentCenter;
    _lunboView3.currentPageDotColor = KSYSTEM_COLOR;
    _lunboView3.pageDotColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_lunboView3];
}

/* 创建品牌推荐视图 **/
- (void)_createRecommandView{
    
    _recommendView = [[UIView alloc] initWithFrame:CGRectZero];
    _recommendView.backgroundColor = [UIColor whiteColor];
    
    //  品牌推荐按钮
    [self _createTopViewWithFrame:CGRectMake(0, 0, kScreenWidth, 30) superV:_recommendView leftImage:@"品牌推荐图标.png" rightTitle:@"品牌推荐"];
    
    // 水平分隔线
    [self _horizontalLineWithMaxY:40 superV:_recommendView];
    
    CGFloat itemWidth = (kScreenWidth-40) / 4.0;
    itemHeight = itemWidth / 1.5;
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc]init];
    fl.itemSize = CGSizeMake(itemWidth, itemHeight);
    fl.scrollDirection = UICollectionViewScrollDirectionVertical;
    fl.minimumLineSpacing = kEdgeLine;
    fl.minimumInteritemSpacing = kEdgeClown*0.5;
    fl.sectionInset = UIEdgeInsetsMake(0, kEdgeClown*0.5, 0, kEdgeClown*0.5);
    
    recommendCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 41, kScreenWidth, itemHeight+10) collectionViewLayout:fl];
    recommendCollectionView.showsHorizontalScrollIndicator = NO;
    recommendCollectionView.delegate = self;
    recommendCollectionView.dataSource = self;
    recommendCollectionView.tag = 202;
    recommendCollectionView.backgroundColor = [UIColor whiteColor];
    [recommendCollectionView registerNib:[UINib nibWithNibName:@"WDRecommendCell" bundle:nil] forCellWithReuseIdentifier:recommend];
    [_recommendView addSubview:recommendCollectionView];
    _recommendView.frame = CGRectMake(0, CGRectGetMaxY(_bottomView.frame), kScreenWidth, itemHeight+50);
    
    [_mainScrollView addSubview:_recommendView];
}

/* 创建优选商品视图 **/
- (void)_createGoodChoiceView
{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lunboView3.frame), kScreenWidth, 180*3+135)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_mainScrollView addSubview:_bottomView];
    
    
    //  底部 商品信息
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth-1.5)/3.0, 180);
    layout.minimumLineSpacing = 0.75;
    layout.minimumInteritemSpacing = 0.75;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;  //水平布局
    layout.headerReferenceSize = CGSizeMake(kScreenWidth, kScreenWidth/8*3);
    
    _goodChoiceCV = [[WDGoodChoiceColllectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 180 * 3+140) collectionViewLayout:layout];
    _goodChoiceCV.scrollEnabled = NO;
    _goodChoiceCV.goodsInfoVC = self;
    [_bottomView addSubview:_goodChoiceCV];
    
    //  分隔线
//    [self _horizontalLineWithMaxY:40 superV:_bottomView];
}

/* 创建附近店铺视图 **/
- (void)_createNearStoreView{
    
    UIImageView *nearStoreHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_recommendView.frame), kScreenWidth, kScreenWidth/8*3)];
    nearStoreHeadImg.image = [UIImage imageNamed:@"recommend_theme"];
    [_mainScrollView addSubview:nearStoreHeadImg];
    _nearStoreHeadImg = nearStoreHeadImg;
    
    
    
    
    //  附近店铺 单元格
    _nearStoreTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nearStoreHeadImg.frame), kScreenWidth, 10*90) style:UITableViewStylePlain];
    _nearStoreTableView.delegate = self;
    _nearStoreTableView.dataSource = self;
    [_nearStoreTableView setSectionHeaderHeight:40];
    _nearStoreTableView.separatorInset = UIEdgeInsetsZero;
    _nearStoreTableView.scrollEnabled = NO;  //禁止滑动
    _nearStoreTableView.showsVerticalScrollIndicator = NO;
    _nearStoreTableView.showsHorizontalScrollIndicator = NO;
    [_mainScrollView addSubview:_nearStoreTableView];

}

-(void)createFooterImgView{
    if (!_footerImgView) {
        _footerImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - 150)/2, CGRectGetMaxY(_mainScrollView.frame)-40, 150, 20)];
        _footerImgView.image = [UIImage imageNamed:@"底部文字"];
        [self.view  addSubview:_footerImgView];
        [self.view insertSubview:_footerImgView belowSubview:_mainScrollView];
    }
    
}
/* 等比例缩放图片 **/
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
    
}

#pragma mark - WDLunBoViewDelegate
- (void)cycleScrollView:(WDLunBoView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (cycleScrollView == _lunboView1) {
        
        WDAdvertisementModel *model1 = self.oneLunArr[index];
        
        NSString *type1 = model1.urltype;
        if ([type1 isEqualToString:@"1"]) {
            
//            WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
            WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
            nearVC.type = 1;
            NSString *storeId = model1.url;
            
            nearVC.storeId = storeId;
            [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
            [self.navigationController pushViewController:nearVC animated:YES];
        }else{
            
            WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
            NSString *goodID = model1.url;
            infosVC.goodsID = goodID;
            [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
            infosVC.goodsImage = model1.img;
            [self.navigationController pushViewController:infosVC animated:YES];
        }
        
    }
    if (cycleScrollView == _lunboView2) {
        
        WDAdvertisementModel *model2 = self.twoLunArr[index];
        
        NSString *type2 = model2.urltype;
        if ([type2 isEqualToString:@"1"]) {
            
//            WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
            WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
            nearVC.type = 1;
            NSString *storeId = model2.url;
            nearVC.storeId = storeId;
            [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
            [self.navigationController pushViewController:nearVC animated:YES];
        }else{
            
            WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
            NSString *goodID = model2.url;
            infosVC.goodsID = goodID;
            [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
            infosVC.goodsImage = model2.img;
            [self.navigationController pushViewController:infosVC animated:YES];
        }
        
    }
    if (cycleScrollView == _lunboView3) {
        
        WDAdvertisementModel *model3 = self.threeLunArr[index];
        
        NSString *type3 = model3.urltype;
        if ([type3 isEqualToString:@"1"]) {
            WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
            nearVC.type = 1;
//            WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
            NSString *storeId = model3.url;
            nearVC.storeId = storeId;
            [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
            [self.navigationController pushViewController:nearVC animated:YES];
        }else{
            
            WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
            NSString *goodID = model3.url;
            infosVC.goodsID = goodID;
            [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
            infosVC.goodsImage = model3.img;
            [self.navigationController pushViewController:infosVC animated:YES];
       }
    }
    if (cycleScrollView == _recommandLunbo) {
        
        WDAdvertisementModel *model4 = self.fourLunArr[index];
        
        NSString *type3 = model4.urltype;
        if ([type3 isEqualToString:@"1"]) {
            WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
            nearVC.type = 1;
//            WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
            NSString *storeId = model4.url;
            nearVC.storeId = storeId;
            [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
            [self.navigationController pushViewController:nearVC animated:YES];
        }else{
            
            WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
            NSString *goodID = model4.url;
            infosVC.goodsID = goodID;
            [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
            infosVC.goodsImage = model4.img;
            [self.navigationController pushViewController:infosVC animated:YES];
        }

    }
}

#pragma mark - UITableViewDelegate
-(void)cardDidSelect:(NSDictionary *)data{
    WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
    NSString *goodID = data[@"pid"];
    infosVC.goodsID = goodID;
    [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
    infosVC.goodsImage = [NSString stringWithFormat:@"%@%@",IMAGE_URL,data[@"img"]];
    [self.navigationController pushViewController:infosVC animated:YES];
}
- (void)openOrCloseDiscountView:(id)data
{
    [self updateNearStoreTableViewHeight:self.nearStoreArr];
//    [_nearStoreTableView reloadData];
}
- (UIView *)footLine{
    if (!_footLine) {
        _footLine = [[UIView alloc] init];
        _footLine.backgroundColor = KSYSTEM_COLOR;
    }
    return _footLine;
}
- (CGFloat)sizeWithText:(NSString *)text font:(UIFont *)font
{
    NSDictionary *attrs = @{NSFontAttributeName:font};
    return [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}
- (CGFloat)getRowHeightWithData:(WDNearbyStoreModel *)data{
    NSArray *disList = [data.discounttitle componentsSeparatedByString:@","];
    NSArray *goodsList = data.storesproducts[@"subdata"];
    CGFloat h = 90;
    if (disList.count>0) {
        if (disList.count>2 && data.isCloseDis) {
            h+=20*2;
        }else{
            h+=20*disList.count;
        }
        
    }
    if (goodsList.count>0) {
        h+=100;
    }
    return h;
}
// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.nearStoreArr.count == 0)
    {
        return 0;
    }
    return self.nearStoreArr.count;
}

// 单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    StoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[StoreTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.delegate = self;
    WDNearbyStoreModel * nearStore = self.nearStoreArr[indexPath.row];
    [cell setCellData:nearStore];
//    cell.showPingtaieEnabled = YES;  //设置 平台专送 图标隐藏
//    if (self.nearStoreArr.count > 0)
//    {
//        WDNearbyStoreModel * nearStore = self.nearStoreArr[indexPath.row];
//        [cell.storeImageView sd_setImageWithURL:[NSURL URLWithString:nearStore.img]];
//        cell.storeName.text = nearStore.name;
//        cell.qisongPrice.text = [NSString stringWithFormat:@"¥%@",nearStore.startvalue];
//        cell.peisongPrice.text = [NSString stringWithFormat:@"¥%@",nearStore.startfee];
//        cell.distanceLabel.text = nearStore.distance;
//        cell.sellCount.text = [NSString stringWithFormat:@"月售%@份",nearStore.monthlysales];
//        if ([nearStore.isown isEqualToString:@"1"])
//        {
//            cell.pingtaiImageView.hidden = NO;
//        }
//        else
//        {
//            cell.pingtaiImageView.hidden = YES;
//        }
//    }
//
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WDNearbyStoreModel *model = self.nearStoreArr[indexPath.row];
    return [self getRowHeightWithData:model];
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    WDNearDetailsViewController *detailsVC = [[WDNearDetailsViewController alloc] init];
    WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
    nearVC.type = 1;
    WDStoreInfosModel * nearStore = self.nearStoreArr[indexPath.row];
    nearVC.storeId = nearStore.storeid;
    [WDAppInitManeger saveStrData:nearStore.storeid withStr:@"shopID"];
    [self.navigationController pushViewController:nearVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (_nearStoreTableView == tableView) {
        if (!_nearByMenuScroll) {
             _nearByMenuScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
            _nearByMenuScroll.showsHorizontalScrollIndicator= NO;
        }
        
        return _nearByMenuScroll;
    }else{
        return nil;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (tableView == _nearStoreTableView) {
//        return 40;
//    }
//    return 0;
//}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
//    WDSearchViewController *searchVC = [[WDSearchViewController alloc]init];
//    [self.navigationController pushViewController:searchVC animated:YES];
//    [self presentViewController:searchVC animated:YES completion:nil];
    
    return YES;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView.tag == 101) {
        
        return self.teJiaArr.count;
    }
    else if (collectionView.tag == 202) {
        
        return _recommendArray.count;
        
    }else{
        
        return 0;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 101) {
        
        WDTejiaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:teijia forIndexPath:indexPath];
        
//        cell.imageName = _teJiaImageArray[indexPath.row];
//        NSLog(@"%ld --- %@",_teJiaImageArray.count,_teJiaImageArray);
//        cell.tejiaModel = self.teJiaArr[indexPath.row];
        WDSpecialPriceModel *model = self.teJiaArr[indexPath.row];
        [cell.shopImageView sd_setImageWithURL:[NSURL URLWithString:model.img]];
        cell.shopsPrice.text = [NSString stringWithFormat:@"￥%@",model.shopprice];
        
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle],NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",model.marketprice] attributes:attribtDic];
        
        
        cell.lineView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:240/255.0 alpha:1];
        
        // 赋值
        cell.marketPrice.attributedText = attribtStr;
        cell.shopsName.text = model.name;
        
        return cell;
        
    }else if(collectionView.tag == 202){
        
        WDRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recommend forIndexPath:indexPath];
        
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_recommendArray[indexPath.item]]];
        
        return cell;
        
    }else
        
        return nil;
    
}

//  点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 101) {
        
        WDSpecialPriceModel * teJiaGood = self.teJiaArr[indexPath.row];
//        NSLog(@"今日特价跳转页面");
        NSString * goodID = teJiaGood.pid;
        [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
        WDGoodsInfoViewController *goodsInfoVC = [[WDGoodsInfoViewController alloc]init];
        goodsInfoVC.goodsImage = teJiaGood.img;
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }
    if (collectionView.tag == 202) {
        
        WDAdvertisementModel *model4 = self.fourLunArr[indexPath.row];
        NSString *type = model4.urltype;
        if ([type isEqualToString:@"1"]) {
            WDStoreDetailViewController *nearVC = [[WDStoreDetailViewController alloc]init];
            nearVC.type = 1;
//            WDNearDetailsViewController *nearVC = [[WDNearDetailsViewController alloc]init];
            NSString *storeId = model4.url;
            nearVC.storeId = storeId;
            [WDAppInitManeger saveStrData:storeId withStr:@"shopID"];
            [self.navigationController pushViewController:nearVC animated:YES];
        }else{
            
            WDGoodsInfoViewController *infosVC = [[WDGoodsInfoViewController alloc]init];
            NSString *goodID = model4.url;
            infosVC.goodsID = goodID;
            [WDAppInitManeger saveStrData:goodID withStr:@"goodID"];
            infosVC.goodsImage = model4.img;
            [self.navigationController pushViewController:infosVC animated:YES];
        }
    }
}

//  定位按钮
- (IBAction)locationClick:(UIButton *)sender {
    
    WDAreaTableViewController *locationVC = [[WDAreaTableViewController alloc]init];
    locationVC.loctionVC = self;
    [self.navigationController pushViewController:locationVC animated:YES];
}

- (IBAction)searchBtnClick:(UIButton *)sender
{
    WDSearchViewController *searchVC = [[WDSearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];

}



@end
