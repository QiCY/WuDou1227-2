//
//  WDAppInitManeger.m
//  WuDou
//
//  Created by huahua on 16/9/9.
//  Copyright © 2016年 os1. All rights reserved.
//

#import "WDAppInitManeger.h"

@implementation WDAppInitManeger

#pragma mark - 初始化用户令牌
+ (void)requestAppInitWithType:(NSString *)appType verson:(NSString *)verson model:(NSString *)model iMei:(NSString *)imei completion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/Init2?apptype=%@&version=%@&model=%@&imei=%@",API_PORT,appType,verson,model,imei];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token = responseObject[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"APP_ACCESS_TOKEN"];
            NSLog(@"token = %@",token);
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
        
    }];
}

#pragma mark - MD5加密
+(NSString *)md5HexDigest:(NSString*)Des_str
{
    const char *original_str = [Des_str UTF8String];
    //unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    //把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    
    NSMutableString *hash = [NSMutableString string];
    
    for (int i = 0; i < 16; i++)
        
    {
        //x表示十六进制，X  意思是不足两位将用0补齐，如果多余两位则不影响
        [hash appendFormat:@"%02x", result[i]];
        
    }
    
    NSString *mdfiveString = [hash lowercaseString];
    
    
    
    // //NNSLog(@"md5加密输出：Encryption Result = %@",mdfiveString);
    
    return mdfiveString;
    
}

#pragma mark - 保存某个字符
+(void)saveStrData:(NSString *)string withStr:(NSString *)keyStr
{
    
    [[NSUserDefaults standardUserDefaults]setObject:string forKey:keyStr];
    //同步
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - 设置用户令牌用户信息
+ (void)requestUserMsgWithUserName:(NSString *)userName passWord:(NSString *)password completion:(void(^)(WDAppInit *appInit, NSString *error))complete;{
    
//    NSString * MD5Passw = [self md5HexDigest:password];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/SetUsersInfo?username=%@&password=%@&access_token=%@",API_PORT,userName,password,token];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            NSLog(@"登录token = %@",token1);
            
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 设置用户令牌区域信息
+ (void)requestUserAreaMsgWithRegionname:(NSString *)regionname completion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * md5Str = [self md5HexDigest:regionname];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/SetRegionInfo?regionname=%@&access_token=%@",API_PORT,md5Str,token];
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            NSLog(@"更新区域后token = %@",token1);
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 设置用户令牌位置信息
+ (void)requestUserLocationMsgWithCoordinate:(NSString *)coord completion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/SetCoordinate?coordinate=%@&access_token=%@",API_PORT,coord,token];
    
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            NSLog(@"更新位置后token = %@",token1);
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 用户注册
+ (void)requestRegistWithMobile:(NSString *)mobile passWord:(NSString *)password verificationCode:(NSString *)verificationcode completion:(void(^)(WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/Register?access_token=%@&mobile=%@&password=%@&verificationcode=%@",API_PORT,token,mobile,password,verificationcode];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 用户注册获取手机验证码
+ (void)requestRegistVerificationCodeWithMobile:(NSString *)mobile completion:(void(^)(NSString *codeModel, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setDateFormat:@"YYYYMMdd"];
    NSString *DateTime = [formatter stringFromDate:date];
    NSLog(@"%@============年月日=====================",DateTime);
    NSString *sign = [NSString stringWithFormat:@"ttsxin%@%@",mobile,DateTime];
    NSString *md5Str = [self md5HexDigest:sign];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/SendRegistverification2?access_token=%@&mobile=%@&sign=%@",API_PORT,token,mobile,md5Str];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *code = responseObject[@"code"];
            if (complete) {
                
                complete(code,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

#pragma mark - 验证手机号
+ (BOOL)validateNumber:(NSString *)textString
{
    NSString * regex = @"(^1[3|4|5|7|8][0-9]\\d{8}$)";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [numberPre evaluateWithObject:textString];
}

#pragma mark - 找回密码验证码
+ (void)requestForgetPasswordVerificationCodeWithMobile:(NSString *)mobile completion:(void(^)(NSString *codeModel, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/Getbackpasswordverification?access_token=%@&mobile=%@",API_PORT,token,mobile];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *ret = responseObject[@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            NSString *code = responseObject[@"code"];
            if (complete) {
                
                complete(code,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

/** 找回密码*/
+ (void)requestFindPasswordWithMobile:(NSString *)mobile verificationCode:(NSString *)verificationcode newPassword:(NSString *)password completion:(void(^)(NSString *result, WDAppInit *appInit, NSString *error))complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"APP_ACCESS_TOKEN"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@api/auth/ResetPassword?access_token=%@&mobile=%@&newpassword=%@&verificationcode=%@",API_PORT,token,mobile,password,verificationcode];
    
    NSString * encodingString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:encodingString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * ret  = [responseObject objectForKey:@"ret"];
        if ([ret isEqualToString:@"0"]) {
            
            // 保存token
            NSString *token1 = responseObject[@"access_token"];
            [[NSUserDefaults standardUserDefaults] setObject:token1 forKey:@"APP_ACCESS_TOKEN"];
            
            NSString *success = responseObject[@"msg"];
            
            WDAppInit *model = [[WDAppInit alloc]initWithDictionary:responseObject];
            
            if (complete) {
                
                complete(success,model,nil);
            }
            
        }else{
            
            NSString * error = [responseObject objectForKey:@"msg"];
            if (complete)
            {
                complete(nil,nil,error);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"error = %@", error);
    }];
}

@end
