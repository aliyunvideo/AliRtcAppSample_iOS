//
//  AliRequestList.h
//  RTCDemo
//
//  Created by mt on 2017/8/18.
//  Copyright © 2017年 mt. All rights reserved.
//


#import "AliBaseHttpClient.h"

@interface AliRequestList : NSObject

/**
 @brief 用户登陆

 @param param 登陆参数
 @param block 登陆结果回调
 */
+ (void)userLoginParam:(NSDictionary *)param block:(void (^)(NSDictionary *loginModel, NSError *error))block;

@end
