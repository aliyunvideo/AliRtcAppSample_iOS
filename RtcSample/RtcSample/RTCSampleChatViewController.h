//
//  RTCSampleChatViewController.h
//  RtcSample
//
//  Created by daijian on 2019/2/27.
//  Copyright © 2019年 tiantian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliRTCSdk/AliRTCSdk.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCSampleChatViewController : UIViewController

/**
 @brief 频道号
 */
@property(nonatomic, copy) NSString *channelName;

/**
 @brief 音频采集开关
 */
@property(nonatomic, assign) BOOL audioCapture;

/**
 @brief 音频播放开关
 */
@property(nonatomic, assign) BOOL audioPlayer;

@end

NS_ASSUME_NONNULL_END

@interface RTCRemoterUserView : UICollectionViewCell

/**
 @brief 用户流视图
 
 @param view renderview
 */
- (void)updateUserRenderview:(AliRenderView *)view;

/**
 @brief Switch点击事件回调
 */
@property(nonatomic,copy) void(^switchblock)(BOOL);

/**
 @brief mediaInfo获取媒体流信息点击事件回调
 */
@property(nonatomic,copy) void(^mediaInfoblock)();

/**
 @brief 灰色底View
 */
@property (nonatomic,strong) UIView *view;

/**
 @brief 视频(屏幕)镜像开关
 */
@property (nonatomic,strong) UISwitch *CameraMirrorSwitch;

/**
 @brief 视频(屏幕)镜像描述
 */
@property (nonatomic,strong) UILabel *CameraMirrorLabel;

- (void)onCameraMirrorClicked:(UISwitch *)switchView;

- (void)getMediaInfoClicked:(UIButton *)button;

@end
