//
//  AppDelegate.m
//  WuDou
//
//  Created by huahua on 16/7/6.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "AppDelegate.h"
#import "WDWelcomeViewController.h"
#import "WDTabbarViewController.h"
#import "WDGoodList.h"

//获取具体设备型号
#import <sys/utsname.h>

#import <AlipaySDK/AlipaySDK.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import "WeiboSDK.h"
#import "WDMyOrderViewController.h"

#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>

#import <CoreLocation/CoreLocation.h>

//推送跳转界面
#import "WDNavigationController.h"
#import "WDMyOrderViewController.h"
#import "WDNewsViewController.h"
#import "WDWebViewController.h"
#import "WDBusinessOrderViewController.h"

@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>
{
    CLLocationManager *_manager;
    NSString * _idStr;
    NSString * _tagStr;
}
@end

@implementation AppDelegate

static NSString *appKey = @"164b228483d034947f1efe5e";
static NSString *channel = @"Publish channel";
static BOOL isProduction = FALSE;

- (void)applicationDidBecomeActive:(UIApplication *)application{
    
    NSLog(@"开启定时器");
    //获得队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    //创建一个定时器
    self.time = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置开始时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
    //设置时间间隔
    uint64_t interval = (uint64_t)(5.0* NSEC_PER_SEC);
    //设置定时器
    dispatch_source_set_timer(self.time, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.time, ^{

        //  判断是普通用户还是商户
        [WDMineManager requestShowStoreOrderWithCompletion:^(NSString *isShow, NSString *error) {
            
            if (error) {
                //                SHOW_ALERT(error);
                dispatch_cancel(self.time);
                return;
            }
            if ([isShow isEqualToString:@"0"]) {  //商户
                
                [WDMineManager requestStoreUserhasUnreadNewsWithCompletion:^(NSString *result, NSString *error) {
                    
                    if (error) {
                        //                SHOW_ALERT(error);
                        dispatch_cancel(self.time);
                        return;
                    }
                    
                    NSDictionary *parm = [NSDictionary dictionaryWithObject:result forKey:@"RESULT"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HAVEMSG" object:nil userInfo:parm];
                    
                }];
                
            }
            else{  //普通用户
                
                [WDMineManager requestNormalUserhasUnreadNewsWithCompletion:^(NSString *result, NSString *error) {
                    
                    if (error) {
                        //                SHOW_ALERT(error);
                        dispatch_cancel(self.time);
                        return;
                    }
                    
                    NSDictionary *parm = [NSDictionary dictionaryWithObject:result forKey:@"RESULT"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"HAVEMSG" object:nil userInfo:parm];
                    
                }];
            }
            
        }];
        
    });
    //启动定时器
    dispatch_resume(self.time);
}

- (void)applicationWillResignActive:(UIApplication *)application{
    
    NSLog(@"停止定时器");
    dispatch_cancel(self.time);
}

#pragma mark - 获取具体设备型号
- (NSString *)deviceModelName

{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([deviceModel isEqualToString:@"iPhone3,1"] || [deviceModel isEqualToString:@"iPhone3,2"])                 return @"iPhone 4";
    
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([deviceModel isEqualToString:@"iPhone5,1"] || [deviceModel isEqualToString:@"iPhone5,2"])                 return @"iPhone 5";
    
    if ([deviceModel isEqualToString:@"iPhone5,3"] || [deviceModel isEqualToString:@"iPhone5,4"])                 return @"iPhone 5C";
    
    if ([deviceModel isEqualToString:@"iPhone6,1"] || [deviceModel isEqualToString:@"iPhone6,2"])                 return @"iPhone 5S";
    
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([deviceModel isEqualToString:@"iPhone9,1"] || [deviceModel isEqualToString:@"iPhone9,3"])                 return @"iPhone 7";
    
    if ([deviceModel isEqualToString:@"iPhone9,2"] || [deviceModel isEqualToString:@"iPhone9,4"])                 return @"iPhone 7 Plus";
    
    return deviceModel;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //1.创建Window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //  判断access_token是否存在
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    if (token == nil) {
        
        //设备型号
        NSString *device = [self deviceModelName];
        
        //唯一识别码
        NSString *deviceId = [[UIDevice currentDevice] identifierForVendor].UUIDString;
        
        [WDAppInitManeger requestAppInitWithType:@"1" verson:@"1.0" model:device iMei:deviceId completion:^(WDAppInit *appInit, NSString *error) {
            
            if (error) {
                
                SHOW_ALERT(error)
                return ;
            }
            
        }];
    }
    
    // 判断是否第一次启动app
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *string = @"WuDou";  //键：string
    BOOL result = [userDefault valueForKey:string];  //用userDefault 从字典中取键string 用布尔值接收
    
    if (result) {  //如果字典中有值与其对应，则显示的是首页，，反之没有值则说明是第一次打开该应用程序，显示的是欢迎页面
        
        WDTabbarViewController *tabbar = [[WDTabbarViewController alloc]init];
        self.window.rootViewController = tabbar;
    }else{
        
        //  开启定位
        // 初始化定位管理器
        _manager = [[CLLocationManager alloc] init];
        // 设置代理
        _manager.delegate = self;
        // 设置定位精确度到米
        _manager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        _manager.distanceFilter = kCLDistanceFilterNone;
        if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8))
        {
            // 一个是requestAlwaysAuthorization，一个是requestWhenInUseAuthorization
            [_manager requestAlwaysAuthorization];//这句话ios8以上版本使用。
        }
        // 开始定位
        [_manager startUpdatingLocation];
        
        WDWelcomeViewController *welcome = [[WDWelcomeViewController alloc]init];
        self.window.rootViewController = welcome;
       
    }
    
    // 设置app启动时显示图片的状态
    NSString *isShow = @"1";
    [[NSUserDefaults standardUserDefaults] setObject:isShow forKey:@"SHOWIMAGE"];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString * app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    float appVersion = [app_Version floatValue];
    float appV = [[defaults objectForKey:@"APP-V"]floatValue];
    if (appV == 0)
    {
        [defaults setFloat:appVersion forKey:@"APP-V"];
    }
    else if (appVersion != appV)
    {
        [defaults setFloat:appVersion forKey:@"APP-V"];
        [WDGoodList clearAllDatas];
    }
    
    //第三方登陆
    [ShareSDK registerApp:@"17ffecb31da5c"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformSubTypeWechatTimeline:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeChat:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxecf915ab4f97f107"
                                       appSecret:@"493deba7b5ede0b9c06a7c158ad48fd2"];
                 break;
                 
             case SSDKPlatformTypeSinaWeibo:
                 
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
    //微信支付
    [WXApi registerApp:@"wxecf915ab4f97f107"];
    
    //推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    return YES;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    NSString *locationInfo = [NSString stringWithFormat:@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    
    //  保存位置信息
    [WDAppInitManeger requestUserLocationMsgWithCoordinate:locationInfo completion:^(WDAppInit *appInit, NSString *error) {
        
        if (error) {
            
            SHOW_ALERT(error)
        }
        
        [manager stopUpdatingLocation];
    }];
}

//支付宝回调
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            
            WDMyOrderViewController *orderVC = [[WDMyOrderViewController alloc]init];
            orderVC.istype = 1;
            self.window.rootViewController = orderVC;
        }];
    }
    return YES;
}

//微信回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    /*! @brief 处理微信通过URL启动App时传递的数据
     *
     * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
     * @param url 微信启动第三方应用时传递过来的URL
     * @param delegate  WXApiDelegate对象，用来接收微信触发的消息。
     * @return 成功返回YES，失败返回NO。
     */
    return [WXApi handleOpenURL:url delegate:self];
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{
    [WDAppInitManeger saveStrData:@"weixin" withStr:@"WX"];
    WDTabbarViewController * tabbar = [[WDTabbarViewController alloc]init];
    tabbar.selectedIndex = 3;
    self.window.rootViewController = tabbar;
    //支付返回结果，实际支付结果需要去微信服务器端查询
    NSString *strMsg = [NSString stringWithFormat:@"支付结果"];
    switch (resp.errCode) {
        case WXSuccess:
            strMsg = @"支付结果：成功！";
            NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            break;
        default:
            strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
            NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
            break;
    }
}

//推送回调
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

-(void)getPush
{
    NSLog(@"推送");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    [self showAlertWith:userInfo];
    //    [rootViewController addNotificationCount];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [JPUSHService handleRemoteNotification:userInfo];
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    [self showAlertWith:userInfo];
    
    //    if ([[UIDevice currentDevice].systemVersion floatValue]<10.0 || application.applicationState>0) {
    //        [rootViewController addNotificationCount];
    //    }
    //
    completionHandler(UIBackgroundFetchResultNewData);
}
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 前台收到远程通知:%@",userInfo);
        
    }
    else {
        // 判断为本地通知
        NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        [JPUSHService handleRemoteNotification:userInfo];
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        [self showAlertWith:userInfo];
        //        [rootViewController addNotificationCount];
        
    }
    else
    {
        // 判断为本地通知
        NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler();  // 系统要求执行这个方法
}

-(void)showAlertWith:(NSDictionary *)userInfo
{
    NSDictionary * apsDic = [userInfo objectForKey:@"aps"];
    NSString * alertStr = [apsDic objectForKey:@"alert"];
    _idStr = [userInfo objectForKey:@"id"];
    _tagStr = [userInfo objectForKey:@"tag"];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                     message:alertStr
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"查看",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 取到tabbarcontroller
        WDTabbarViewController * tabBarController = (WDTabbarViewController *)self.window.rootViewController;
        // 取到navigationcontroller
        UINavigationController * nav = tabBarController.selectedViewController;
        //取到nav控制器当前显示的控制器
        UIViewController * baseVC = (UIViewController *)nav.visibleViewController;
        
        if ([_tagStr isEqualToString:@"1"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDMyOrderViewController class]])
            {
                WDMyOrderViewController * myOrderVC = (WDMyOrderViewController *)baseVC;
                [myOrderVC _loadDatas];
                return;
            }
            // 否则，跳转到我的消息
            WDMyOrderViewController * myOrderVC = [[WDMyOrderViewController alloc] init];
            [nav pushViewController:myOrderVC animated:YES];
        }
        if ([_tagStr isEqualToString:@"2"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDNewsViewController class]])
            {
                WDNewsViewController * webVC = (WDNewsViewController *)baseVC;
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
                NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=1&sid=0&pid=0",HTML5_URL,token];
                webVC.requestUrl = urlStr;
                [webVC viewDidLoad];
                return;
            }
            // 否则，跳转到我的消息
            WDNewsViewController * webVC = [[WDNewsViewController alloc]init];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
            NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=1&sid=0&pid=0",HTML5_URL,token];
            webVC.requestUrl = urlStr;
            [nav pushViewController:webVC animated:YES];
        }
        if ([_tagStr isEqualToString:@"3"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDWebViewController class]])
            {
                WDWebViewController *webV = (WDWebViewController *)baseVC;
                webV.navTitle = @"蔬心热点";
                webV.urlString = [NSString stringWithFormat:@"%@wapapp/hotnews.html",HTML5_URL];
                [webV viewDidLoad];
                return;
            }
            // 否则，跳转到我的消息
            WDWebViewController *webV = [[WDWebViewController alloc] init];
            webV.navTitle = @"蔬心热点";
            webV.urlString = [NSString stringWithFormat:@"%@wapapp/hotnews.html",HTML5_URL];
            [nav pushViewController:webV animated:YES];

        }
        if ([_tagStr isEqualToString:@"4"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDBusinessOrderViewController class]])
            {
                WDBusinessOrderViewController * businessOrderVC = (WDBusinessOrderViewController *)baseVC;
                [businessOrderVC _loadDatas];
                return;
            }
            WDBusinessOrderViewController * businessOrderVC = [[WDBusinessOrderViewController alloc] init];
            businessOrderVC.navTitle = @"商户订单";
            [nav pushViewController:businessOrderVC animated:YES];
        }
        if ([_tagStr isEqualToString:@"5"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDNewsViewController class]])
            {
                WDNewsViewController * webVC = (WDNewsViewController *)baseVC;
                NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
                NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=4&sid=0&pid=0",HTML5_URL,token];
                webVC.requestUrl = urlStr;
                [webVC viewDidLoad];
                return;
            }
            // 否则，跳转到我的消息
            WDNewsViewController * webVC = [[WDNewsViewController alloc]init];
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
            NSString *urlStr = [NSString stringWithFormat:@"%@wapapp/message.html?access_token=%@&type=4&sid=0&pid=0",HTML5_URL,token];
            webVC.requestUrl = urlStr;
            [nav pushViewController:webVC animated:YES];
        }
        if ([_tagStr isEqualToString:@"6"])
        {
            //如果是当前控制器是我的消息控制器的话，刷新数据即可
            if([baseVC isKindOfClass:[WDBusinessOrderViewController class]])
            {
                WDBusinessOrderViewController * businessOrderVC = (WDBusinessOrderViewController *)baseVC;
                [businessOrderVC _loadDatas];
                return;
            }
            WDBusinessOrderViewController * businessOrderVC = [[WDBusinessOrderViewController alloc] init];
            businessOrderVC.navTitle = @"配送订单";
            [nav pushViewController:businessOrderVC animated:YES];
        }
    }
}




@end
