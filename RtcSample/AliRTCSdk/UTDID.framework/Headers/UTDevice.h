// A simplified iOS device ID library
// API is compatible with UTDID library
// Created on 2018-11-12

#import <UIKit/UIKit.h>

@interface UTDevice : NSObject
    
    /**
     * @brief                       获取SDK生成的设备唯一标识.
     *
     * @warning                     调用说明:这个设备唯一标识是持久的,并且格式安全,iOS6以及以下,多应用互通.
     *
     *                              调用顺序:utdid任意时刻都可以调用.
     *
     * @return                      24字节的设备唯一标识.
     */
+(NSString *) utdid;
    
@end
