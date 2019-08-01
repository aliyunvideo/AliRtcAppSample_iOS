#import <UIKit/UIKit.h>
#import <AliRTCSdk/AliRTCSdk.h>

// 用户 APP Server 登录信息
static NSString *AppServer   =  @"";   //服务器app server地址

@interface RTCSampleUserAuthrization : NSObject


/**
 @brief 这是app厂商实现app server查询的示例代码

 @param channelName 频道名称
 @param name 用户名
 @return AliRtcAuthInfo 实例信息
 */
+ (AliRtcAuthInfo *)getPassportFromAppServer:(NSString *)channelName userName:(NSString *)name;

@end
