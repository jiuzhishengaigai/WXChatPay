//
//  WXPayTools.m
//  WXChatPay
//
//  Created by gaigai on 16/6/10.
//  Copyright © 2016年 gaigai. All rights reserved.
//

#import "WXPayTools.h"
#import "WXApi.h"
#import <CommonCrypto/CommonCrypto.h>

#define appID @""            // appId
#define WXpartnerId @""      // 商户账号
#define apiKey @""           // appKey

@interface WXPayTools ()<WXApiDelegate>



@end

@implementation WXPayTools

 static id _instance = nil;

+ (instancetype)shareWXPayTools{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
    
}


/**
 *  注册微信
 */
+ (void)registWXApi{
    
    [WXApi registerApp:appID];
}



/**
 *  微信支付
 *
 *  @param prepayid 预支付订单
 */
+ (void)WXPay:(NSString *)prepayid{
    
    
    // 检查微信是否已被用户安装
    if ([WXApi isWXAppInstalled]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未安装微信" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    // 获取当前时间
    time_t now;
    time(&now);
    // 时间戳
    NSString *timestamp = [NSString stringWithFormat:@"%ld", now];
    // 随机字符串
    NSString *nonceStr = [[WXPayTools md5:timestamp] uppercaseString];
    
    NSDictionary *para = @{
                           @"appid" : appID,
                           @"noncestr" : nonceStr,
                           @"package" : @"Sign=WXPay",
                           @"partnerid" : WXpartnerId,
                           @"prepayid" : prepayid,
                           @"timestamp" : timestamp
                           };
    
    NSMutableString *contentString = [NSMutableString string];
    NSArray *keys = [para allKeys];
    // 按字母排序
    NSArray *sortedArry = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 拼接字符串
    for (NSString *categoryId  in sortedArry) {
        if (![[para objectForKey:categoryId] isEqualToString:@""] && ![categoryId isEqualToString:@"sign"] && ![categoryId isEqualToString:@"key"]) {
            [contentString appendFormat:@"%@=%@&", categoryId, para[categoryId]];
        }
    }
    // 添加key字段
    [contentString appendFormat:@"key=%@", apiKey];
    // 加密生成字符串
    NSString *sign = [WXPayTools md5:contentString];
    
    PayReq *req = [[PayReq alloc] init];
    
    req.partnerId = WXpartnerId;
    req.prepayId = prepayid;
    req.nonceStr = nonceStr;
    req.timeStamp =  timestamp.intValue;
    req.package = @"Sign=WXPay";
    
    req.sign = sign;  // 签名
    
    [WXApi sendReq:req];
    
}

/**
 *  跳转处理
 *
 *  @param url 返回的url
 */
- (BOOL)WXApihandleOpenURL:(NSURL *)url{
    
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp{
    
    // 支付成功后,返回你的app会调用该方法,可以在这里做相应的处理
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = nil;
        
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

    
}


/**
 *  md5加密
 *
 *  @param input 需要加密的字符串
 *
 *  @return 加密后生成的字符串
 */
+ (NSString *) md5: (NSString *) input {
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  [NSString stringWithString: output];
}


/**
 *  随机字符串
 *
 *  @return 生成一个32位的字母大小的随机字符串
 */
+ (NSString *)randomNum{
 
    NSString *timeStamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    timeStamp = [WXPayTools md5:timeStamp];
    
    return [timeStamp uppercaseString];
}






@end
