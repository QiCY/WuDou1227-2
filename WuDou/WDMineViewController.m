//
//  WDMineViewController.m
//  WuDou
//
//  Created by huahua on 16/8/5.
//  Copyright ©2016年 os1. All rights reserved.
//  我的账户 

#import "WDMineViewController.h"
#import "WDMainCell.h"
#import "WDMineSettingViewController.h"
#import "WDWebViewController.h"
#import "WDMyOrderViewController.h"
#import "WDNewsViewController.h"
#import "WDCollectTableVController.h"
#import "WDSecondGoodsTableVController.h"
#import "WDAddressTableVController.h"
#import "WDCollectViewController.h"
#import "WDBusinessOrderViewController.h"
#import "WDMyBianmingTableViewController.h"
#import "WDMyJudgementsViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

static NSString *string = @"WDMainCell";

@interface WDMineViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    NSArray *_mainImageViewArray;
    NSArray *_listLabelArray;
    NSArray *_showGotoBtnArray;
    
    UIScrollView * _mineScrolView;
    UITableView * _tableView;
    UIView * _heardView;
    UIView * bigView;
    int _beginY;
    
    UIImageView * heardImage;
    UILabel * nameLabel;
    UILabel * jiFenLabel;
    UIButton * qiandaoBtn;
    
    //分享
    UIView * bigShareView;
    UIView * wirtShareView;
    //分享
    NSMutableDictionary * shareParams;
    
}
@end

@implementation WDMineViewController

-(void)viewWillAppear:(BOOL)animated
{
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    NSLog(@"登录后token = %@",accessToken);
    
    NSString *isWeiXin = [[NSUserDefaults standardUserDefaults] objectForKey:@"WX"];
    if ([isWeiXin isEqualToString:@"weixin"])
    {
        WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
        [WDAppInitManeger saveStrData:@"noweixin" withStr:@"WX"];
    }
    [WDMineManager requestLoginEnabledWithCompletion:^(NSString *resultRet) {
        
        if ([resultRet isEqualToString:@"0"]) {
            
            [self _loadUserMsg];
        }else{
            
            self.loginVC = [[WDLoginViewController alloc]init];
            [self.navigationController pushViewController:self.loginVC animated:YES];
        }
        
    }];
    
    _mineScrolView.delegate = self;
    // 隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    // 显示导航栏
    self.navigationController.navigationBarHidden = NO;
    _mineScrolView.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [WDMineManager requestShowStoreOrderWithCompletion:^(NSString *isShow, NSString *error) {
        
        if (error) {
            
        }else{
            
            self.showOrderState = isShow;
            
            [self _setupArray];
            [_tableView reloadData];
        }
        
    }];
    
    [self setScrollUI];
}

/* 加载用户信息 **/
- (void)_loadUserMsg
{
   [WDMineManager requestUserMsgWithInformation:@"" Completion:^(WDUserMsgModel *userMsg, NSString *error) {
      
       if (error) {
           
           SHOW_ALERT(error)
           return ;
       }
       
       WDUserMsgModel *model = userMsg;
       nameLabel.text = model.username;
       jiFenLabel.text = [NSString stringWithFormat:@"积分：%@",model.credits];
       [heardImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
       
       [_tableView reloadData];
   }];
}

/* 初始化数组数据 **/
- (void) _setupArray
{
    if ([self.showOrderState isEqualToString:@"0"]) {  //商户
        
#warning 改动：我的二手品隐藏  @"二手品图标.png",@"我的二手品"
        
//                _mainImageViewArray = @[@[@"全部订单.png",@"shanghu.png",@"消息2.png",@"优惠券.png"],@[@"位置.png",@"评价2.png",@"收藏2.png",@"消息2.png",@"bianming.png",@"分享.png",@"帮助.png"]];
        _mainImageViewArray = @[@[@"myorders.png",@"mine_storeOder.png",@"mymessage.png", @"mydiscount.png"],@[@"myaddress.png",@"mycomment.png",@"myfavorite.png",@"mymessage.png",@"myservices.png",@"myshare.png",@"myhelp.png"]];
                _listLabelArray = @[@[@"全部订单",@"商户订单",@"商户消息",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"我的便民服务",@"分享到朋友圈",@"帮助中心"]];
        
//        _mainImageViewArray = @[@[@"全部订单.png",@"shanghu.png",@"消息2.png",@"优惠券.png"],@[@"位置.png",@"评价2.png",@"收藏2.png",@"消息2.png",@"分享.png",@"帮助.png"]];
//        _listLabelArray = @[@[@"全部订单",@"商户订单",@"商户消息",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"分享到朋友圈",@"帮助中心"]];
        
    }
    if ([self.showOrderState isEqualToString:@"1"]) {  //普通用户
        
                _mainImageViewArray = @[@[@"myorders.png",@"mydiscount.png"],@[@"myaddress.png",@"mycomment.png",@"myfavorite.png",@"mymessage.png",@"myservices.png",@"myshare.png",@"myhelp.png"]];
                _listLabelArray = @[@[@"全部订单",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"我的便民服务",@"分享到朋友圈",@"帮助中心"]];
        
//        _mainImageViewArray = @[@[@"全部订单.png",@"优惠券.png"],@[@"位置.png",@"评价2.png",@"收藏2.png",@"消息2.png",@"分享.png",@"帮助.png"]];
//        _listLabelArray = @[@[@"全部订单",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"分享到朋友圈",@"帮助中心"]];
        
    }
    if([self.showOrderState isEqualToString:@"2"]){  //配送员
        
//        _mainImageViewArray = @[@[@"全部订单.png",@"shanghu.png",@"优惠券.png"],@[@"位置.png",@"评价2.png",@"收藏2.png",@"消息2.png",@"bianming.png",@"分享.png",@"帮助.png"]];
          _mainImageViewArray = @[@[@"myorders.png",@"mine_storeOder.png",@"mydiscount.png"],@[@"myaddress.png",@"mycomment.png",@"myfavorite.png",@"mymessage.png",@"myservices.png",@"myshare.png",@"myhelp.png"]];
        
        _listLabelArray = @[@[@"全部订单",@"配送员订单",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"我的便民服务",@"分享到朋友圈",@"帮助中心"]];
        
//        _mainImageViewArray = @[@[@"全部订单.png",@"shanghu.png",@"消息2.png",@"优惠券.png"],@[@"位置.png",@"评价2.png",@"收藏2.png",@"消息2.png",@"分享.png",@"帮助.png"]];
//        _listLabelArray = @[@[@"全部订单",@"配送员订单",@"配送员消息",@"我的优惠券"],@[@"管理地址",@"我的评价",@"我的收藏",@"我的消息",@"分享到朋友圈",@"帮助中心"]];
        
    }
}

-(void)setScrollUI
{
    _mineScrolView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _mineScrolView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mineScrolView];
    
    NSLog(@"%.2lf",kScreenHeight);
    
    _tableView = [[UITableView alloc]init];
    if (kScreenHeight < 500)
    {
        _mineScrolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 240);
        _tableView.frame = CGRectMake(0, 120, kScreenWidth, kScreenHeight + 40);
    }
    else if(kScreenHeight < 570)
    {
        _mineScrolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 170);
        _tableView.frame = CGRectMake(0, 120, kScreenWidth, kScreenHeight);
    }
    else if(kScreenHeight < 670)
    {
        _mineScrolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + 80);
        _tableView.frame = CGRectMake(0, 120, kScreenWidth, kScreenHeight - 120);
    }
    else
    {
        _mineScrolView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight);
        _tableView.frame = CGRectMake(0, 120, kScreenWidth, kScreenHeight - 180);
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorColor:[UIColor lightGrayColor]];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"WDMainCell" bundle:nil] forCellReuseIdentifier:string];
    [_tableView setScrollEnabled:NO];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_mineScrolView addSubview:_tableView];
    
    [self setHeardUI];
}

-(void)setHeardUI
{
    _mineScrolView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    _heardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
    _heardView.backgroundColor = KSYSTEM_COLOR;
    [_mineScrolView addSubview:_heardView];
    
    bigView = [[UIView alloc]initWithFrame:CGRectMake(20, 30, kScreenWidth - 20, 90)];
    bigView.backgroundColor = [UIColor clearColor];
    [_heardView addSubview:bigView];
    
    heardImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 60, 60)];
    heardImage.layer.cornerRadius = 30.0;
    heardImage.clipsToBounds = YES;
    [bigView addSubview:heardImage];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 30, kScreenWidth - 110, 20)];
    nameLabel.text = @"";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    [bigView addSubview:nameLabel];
    
    jiFenLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 50, kScreenWidth - 110, 20)];
    jiFenLabel.text = @"";
    jiFenLabel.textColor = [UIColor whiteColor];
    jiFenLabel.textAlignment = NSTextAlignmentLeft;
    jiFenLabel.font = [UIFont systemFontOfSize:15.0];
    [bigView addSubview:jiFenLabel];
    
    //  签到得积分 按钮
    qiandaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, jiFenLabel.y, 80, 20)];
    [qiandaoBtn setTitle:@"签到得积分" forState:UIControlStateNormal];
    [qiandaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    qiandaoBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    qiandaoBtn.backgroundColor = [UIColor clearColor];
    [qiandaoBtn addTarget:self action:@selector(qiandaoAction:) forControlEvents:UIControlEventTouchUpInside];
    [bigView addSubview:qiandaoBtn];
    
    UIImageView * setImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 60, 10, 20, 20)];
    setImage.image = [UIImage imageNamed:@"background_setting"];
    [bigView addSubview:setImage];
    
    UIButton * setBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 75, -5, 50, 50)];
    [setBtn addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [bigView addSubview:setBtn];
}

- (void)qiandaoAction:(UIButton *)btn{
    
    btn.enabled = NO;
    [WDMainRequestManager requestSignInWithCompletion:^(NSString *result, NSString *error) {
        if (error) {

            SHOW_ALERT(error)
            btn.enabled = YES;
        }
        else{

            if ([result isEqualToString:@"今日已签到"]) {

                SHOW_ALERT(result)
                btn.enabled = YES;
            }
            else{

                UIView *jifenView = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x - 55, self.view.center.y - 25, 110, 50)];
                jifenView.backgroundColor = [UIColor grayColor];
                jifenView.alpha = 0.8;

                UIImageView *coinView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];
                coinView.image = [UIImage imageNamed:@"钱币.png"];
                [jifenView addSubview:coinView];

                UILabel *jifenLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 60, 20)];
                jifenLabel.text = @"+10积分";
                jifenLabel.font = [UIFont systemFontOfSize:15];
                jifenLabel.textColor = [UIColor whiteColor];
                [jifenView addSubview:jifenLabel];

                [self.view addSubview:jifenView];

                //  更新用户积分
                [self _loadUserMsg];
                
                //  延时消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    btn.enabled = YES;
                    [jifenView removeFromSuperview];
                });
            }
        }
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    _beginY = offsetY;
    _heardView.frame = CGRectMake(0, _beginY - 10, kScreenWidth, 120 + (-1 * _beginY));
    bigView.frame = CGRectMake(20, 120 + (-1 * _beginY) - 90, kScreenWidth - 20, 90);
    if (offsetY >= 100)
    {
        // 显示导航栏
        self.navigationController.navigationBarHidden = NO;
        
    }
    if (offsetY < 100)
    {
        // 隐藏导航栏
        self.navigationController.navigationBarHidden = YES;
    }
}

//  设置  点击方法
- (void)settingAction:(UIControl *)setting{
    
    WDMineSettingViewController *settingVC = [[WDMineSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.showOrderState isEqualToString:@"1"]) {
        
        if (section == 0) {
            
            return 2;
        }
        if (section == 1) {
            
            return 7;
        }
    }
    else if([self.showOrderState isEqualToString:@"0"]){
        
        if (section == 0) {
            
            return 4;
        }
        if (section == 1) {
            
            return 7;
        }
    }else{
        
        if (section == 0) {
            
            return 3;
        }
        if (section == 1) {
            
            return 7;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WDMainCell *cell = [tableView dequeueReusableCellWithIdentifier:string forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *subImageArray = _mainImageViewArray[indexPath.section];
    NSString *imageName = subImageArray[indexPath.row];
    cell.listImageView.image = [UIImage imageNamed:imageName];
    
    NSArray *subInfoArray = _listLabelArray[indexPath.section];
    NSString *info = subInfoArray[indexPath.row];
    cell.listLabel.text = info;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else
    {
        return 20;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //  全部订单
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        WDMyOrderViewController *myOrderVC = [[WDMyOrderViewController alloc] init];
        [self.navigationController pushViewController:myOrderVC animated:YES];
    }
    
    if ([self.showOrderState isEqualToString:@"1"]) { //普通用户
        
        //  我的优惠券
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            WDCollectViewController *myCollectVC = [[WDCollectViewController alloc] init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }
        
    }
    else if([self.showOrderState isEqualToString:@"0"]){  // 商户
    
        //  商户订单
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            WDBusinessOrderViewController *myOrderVC = [[WDBusinessOrderViewController alloc] init];
            NSString *title = _listLabelArray[indexPath.section][indexPath.row];
            myOrderVC.navTitle = title;
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }
        
        //  商户信息
        if (indexPath.section == 0 && indexPath.row == 2) {
            
            WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
            NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=4&sid=0&pid=0",HTML5_URL,token];
            webVC.requestUrl = urlStr;
            [self.navigationController pushViewController:webVC animated:YES];
        }
        //  我的优惠券
        if (indexPath.section == 0 && indexPath.row == 3)
        {
            WDCollectViewController *myCollectVC = [[WDCollectViewController alloc] init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }
        
    }else{
        //  配送员订单
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            WDBusinessOrderViewController *myOrderVC = [[WDBusinessOrderViewController alloc] init];
            NSString *title = _listLabelArray[indexPath.section][indexPath.row];
            myOrderVC.navTitle = title;
            [self.navigationController pushViewController:myOrderVC animated:YES];
        }
        //  我的优惠券
        if (indexPath.section == 0 && indexPath.row == 2)
        {
            WDCollectViewController *myCollectVC = [[WDCollectViewController alloc] init];
            [self.navigationController pushViewController:myCollectVC animated:YES];
        }
            
        
    }
    
    //  我的收货地址
    if (indexPath.section == 1 && indexPath.row == 0) {
        
        WDAddressTableVController *addressVC = [[WDAddressTableVController alloc]init];
        addressVC.sourceType = @"从设置中进入我的地址";
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    //  我的评价
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        WDMyJudgementsViewController *webVC = [[WDMyJudgementsViewController alloc]init];
        webVC.navTitle = _listLabelArray[indexPath.section][indexPath.row];
        webVC.judgeState = @"MyJudgements";
        webVC.cellState = 0;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    //  我的收藏
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        WDCollectTableVController *collectVC = [[WDCollectTableVController alloc]init];
        [self.navigationController pushViewController:collectVC animated:YES];
    }
    //  我的消息
    if (indexPath.section == 1 && indexPath.row == 3) {
        
        WDNewsViewController *webVC = [[WDNewsViewController alloc]init];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=1&sid=0&pid=0",HTML5_URL,token];
        webVC.requestUrl = urlStr;
        [self.navigationController pushViewController:webVC animated:YES];
    }
    //  我的二手品
//    if (indexPath.section == 1 && indexPath.row == 4) {
//        
//        WDSecondGoodsTableVController *secondGoodsVC = [[WDSecondGoodsTableVController alloc]init];
//        secondGoodsVC.navTitle = @"我的二手品";
//        [self.navigationController pushViewController:secondGoodsVC animated:YES];
//    }
    //  我的便民服务
    if (indexPath.section == 1 && indexPath.row == 4) {
        
        WDMyBianmingTableViewController *secondGoodsVC = [[WDMyBianmingTableViewController alloc]init];
        secondGoodsVC.navTitle = @"我的便民服务";
        [self.navigationController pushViewController:secondGoodsVC animated:YES];
    }
    //  分享到朋友圈
    if (indexPath.section == 1 && indexPath.row == 5)
    {
        self.tabBarController.tabBar.hidden = YES;
        self.hidesBottomBarWhenPushed = YES;
        [self shareUI];
    }
    //  帮助中心
    if (indexPath.section == 1 && indexPath.row == 6)
    {
        WDWebViewController *webVC = [[WDWebViewController alloc]init];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
        NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/help.html?access_token=%@",HTML5_URL,token];
        webVC.urlString = urlStr;
        webVC.navTitle = _listLabelArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

//弹出分享
-(void)shareUI
{
    //灰色背景
    bigShareView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bigShareView.backgroundColor = [UIColor blackColor];
    bigShareView.alpha = 0.5;
    UIButton * downBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 120)];
    [downBtn addTarget:self action:@selector(downShare) forControlEvents:UIControlEventTouchUpInside];
    [bigShareView addSubview:downBtn];
    //下面的白色背景
    wirtShareView = [[UIView alloc]init];
    // 显示导航栏
    if (self.navigationController.navigationBarHidden == NO)
    {
        wirtShareView.frame = CGRectMake(0, kScreenHeight - 200 - 64, kScreenWidth, 200);
    }
    else
    {
        wirtShareView.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200);
    }
    wirtShareView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigShareView];
    [self.view addSubview:wirtShareView];
    
    UIImageView * WXImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/4, 40, 50, 50)];
    WXImage.image = [UIImage imageNamed:@"微信-1"];
    [wirtShareView addSubview:WXImage];
    UIButton * wxBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/4, 40, 50, 50)];
    [wxBtn addTarget:self action:@selector(shareClick:)forControlEvents:UIControlEventTouchUpInside];
    wxBtn.tag = 101;
    [wirtShareView addSubview:wxBtn];
    
    UILabel * wxLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/4, 90, 50, 20)];
    wxLabel.text = @"微信好友";
    wxLabel.textAlignment = NSTextAlignmentCenter;
    wxLabel.textColor = [UIColor darkGrayColor];
    wxLabel.font = [UIFont systemFontOfSize:12.0];
    [wirtShareView addSubview:wxLabel];
    
    UIImageView * WXQImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/2 + 50, 40, 50, 50)];
    WXQImage.image = [UIImage imageNamed:@"朋友圈"];
    [wirtShareView addSubview:WXQImage];
    UIButton * WXQBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/2 + 50, 40, 50, 50)];
    [WXQBtn addTarget:self action:@selector(shareClick:)forControlEvents:UIControlEventTouchUpInside];
    WXQBtn.tag = 103;
    [wirtShareView addSubview:WXQBtn];
    UILabel * WXQLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - 150)/2 + 50, 90, 50, 20)];
    WXQLabel.text = @"朋友圈";
    WXQLabel.textAlignment = NSTextAlignmentCenter;
    WXQLabel.textColor = [UIColor darkGrayColor];
    WXQLabel.font = [UIFont systemFontOfSize:12.0];
    [wirtShareView addSubview:WXQLabel];
    
    UIImageView * QQImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - (kScreenWidth - 150)/4) - 50, 40, 50, 50)];
    QQImage.image = [UIImage imageNamed:@"xinlang"];
    [wirtShareView addSubview:QQImage];
    UIButton * QQBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth - (kScreenWidth - 150)/4) - 50, 40, 50, 50)];
    [QQBtn addTarget:self action:@selector(shareClick:)forControlEvents:UIControlEventTouchUpInside];
    QQBtn.tag = 102;
    [wirtShareView addSubview:QQBtn];
    UILabel * QQLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth - (kScreenWidth - 150)/4) - 50, 90, 50, 20)];
    QQLabel.text = @"新浪微博";
    QQLabel.textAlignment = NSTextAlignmentCenter;
    QQLabel.textColor = [UIColor darkGrayColor];
    QQLabel.font = [UIFont systemFontOfSize:12.0];
    [wirtShareView addSubview:QQLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 159, kScreenWidth, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [wirtShareView addSubview:line];
    
    UIButton * quxiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth, 40)];
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [quxiaoBtn addTarget:self action:@selector(downShare) forControlEvents:UIControlEventTouchUpInside];
    [wirtShareView addSubview:quxiaoBtn];
}
//选择分享的按钮
-(void)shareClick:(UIButton *)btn
{
    //1、创建分享参数（必要）
    shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"创建美好健康的新生活，从天天蔬心开始"
                                     images:[UIImage imageNamed:@"icon.png"]
                                        url:[NSURL URLWithString:@"http://download.ttsxin.com/"]
                                      title:@"天天蔬心"
                                       type:SSDKContentTypeAuto];
    if (btn.tag == 101)
    {
        [shareParams SSDKSetupWeChatParamsByText:@"创建美好健康的新生活，从天天蔬心开始"
                                           title:@"天天蔬心"
                                             url:[NSURL URLWithString:@"http://download.ttsxin.com/"]
                                      thumbImage:nil
                                           image:[UIImage imageNamed:@"icon.png"]
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeAuto
                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        [self getShareWith:SSDKPlatformSubTypeWechatSession];

    }
    if (btn.tag == 103)
    {
        [shareParams SSDKSetupWeChatParamsByText:@"创建美好健康的新生活，从天天蔬心开始"
                                           title:@"天天蔬心"
                                             url:[NSURL URLWithString:@"http://download.ttsxin.com/"]
                                      thumbImage:nil
                                           image:[UIImage imageNamed:@"icon.png"]
                                    musicFileURL:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil
                                            type:SSDKContentTypeAuto
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        
        [self getShareWith:SSDKPlatformSubTypeWechatTimeline];
        
    }
    if (btn.tag == 102)
    {
//        [shareParams SSDKSetupShareParamsByText:@"创建美好健康的新生活，从物兜开始"
//                                         images:[UIImage imageNamed:@"icon.png"]
//                                            url:[NSURL URLWithString:@"http://wudoll.com/app/"]
//                                          title:@"物兜到家"
//                                           type:SSDKContentTypeAuto];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:@"创建美好健康的新生活，从天天蔬心开始"
                                                   title:@"天天蔬心"
                                                   image:[UIImage imageNamed:@"icon.png"]
                                                     url:[NSURL URLWithString:@"http://download.ttsxin.com/"]
                                                latitude:0
                                               longitude:0
                                                objectID:nil
                                                    type:SSDKContentTypeAuto];
//                             SSDKSetupWeChatParamsByText:@"创建美好健康的新生活，从物兜开始"
//                                           title:@"物兜到家"
//                                             url:[NSURL URLWithString:@"http://wudoll.com/app/"]
//                                      thumbImage:nil
//                                           image:[UIImage imageNamed:@"icon.png"]
//                                    musicFileURL:nil
//                                         extInfo:nil
//                                        fileData:nil
//                                    emoticonData:nil
//                                            type:SSDKContentTypeAuto
//                              forPlatformSubType:SSDKPlatformSubTypeWechatSession];
        
        [self getShareWith:SSDKPlatformTypeSinaWeibo];
    }
}


-(void)getShareWith:(SSDKPlatformType)platformType
{
    //分享
    [ShareSDK share:platformType
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 [self downShare];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
     }];
}

-(void)downShare
{
    self.tabBarController.tabBar.hidden = NO;
    self.hidesBottomBarWhenPushed = NO;
    [wirtShareView removeFromSuperview];
    [bigShareView removeFromSuperview];
}



@end
