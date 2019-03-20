#import "RTCSampleUserAuthrization.h"
#import "AliRequestList.h"

@interface RTCSampleUserAuthrization()

@end

@implementation RTCSampleUserAuthrization

+ (AliRtcAuthInfo *)getPassportFromAppServer:(NSString *)channelName userName:(NSString *)name{
    
    [[NSUserDefaults standardUserDefaults] setObject:AppServer forKey:@"HostUrl"];
    
    NSDictionary *param = @{@"user":name,
                            @"room":channelName,
                            @"passwd":@"12345678"};
    
    __block AliRtcAuthInfo * info = [[AliRtcAuthInfo alloc]init];;
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    [AliRequestList userLoginParam:param block:^(NSDictionary *joinModel, NSError *err){
        if (err) {
            NSLog(@"Failed to get token from your App Server. Please check your network and server status.");
        }
        else{
            NSMutableDictionary *loginDic = [[NSMutableDictionary alloc]init];
            NSDictionary *dataDic = joinModel[@"data"];
            NSArray *keysArray = [dataDic allKeys];
            for (NSUInteger i = 0; i < keysArray.count; i++) {
                NSString *key = keysArray[i];
                NSString *value = dataDic[key];
                [loginDic setObject:value forKey:key];
            }
            
            info.channel   = channelName;
            info.appid     = loginDic[@"appid"];
            info.nonce     = loginDic[@"nonce"];
            info.user_id   = loginDic[@"userid"];
            info.token     = loginDic[@"token"];
            info.timestamp = [loginDic[@"timestamp"] longLongValue];
            info.gslb      = loginDic[@"gslb"];
        }
        dispatch_semaphore_signal(sema);
    }];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    return info;
}

@end
