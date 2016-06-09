//
//  WXPayTools.h
//  WXChatPay
// 个人习惯,集成SDK的时候一般会搞一个工具类管理
//  Created by gaigai on 16/6/10.
//  Copyright © 2016年 gaigai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXPayTools : NSObject


/**
 *  微信支付的基类
 */

/**
*  单利(demo中的单利写的不够严谨请勿参考)
*
*  @return 实例对象
*/
+ (instancetype)shareWXPayTools;


/**
 *  注册微信
 */
+ (void)registWXApi;

/**
 *  微信支付
 *
 *  @param prepayid 预支付订单
 */
+ (void)WXPay:(NSString *)prepayid;

/**
 *  跳转处理
 *
 *  @param url 返回的url
 */
- (BOOL)WXApihandleOpenURL:(NSURL *)url;



@end
