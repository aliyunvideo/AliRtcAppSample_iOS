//
//  AliRequestList.m
//  RTCDemo
//
//  Created by mt on 2017/8/18.
//  Copyright © 2017年 mt. All rights reserved.
//

#import "AliRequestList.h"
#import "AliBaseHttpClient.h"

@implementation AliRequestList

+ (void)userLoginParam:(NSDictionary *)param block:(void (^)(NSDictionary *loginModel, NSError *error))block
{
    [[AliBaseHttpClient client] httpPostWithHost:@"login" param:param block:^(NSDictionary *responseDic, NSError *error){
        if (error)
        {
            if(block)
                block(nil,error);
            return ;
        }
        if(block)
            block(responseDic,error);
    }];
}


@end
