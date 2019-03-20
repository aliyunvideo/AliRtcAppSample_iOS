//
//  RTCSampleChatViewController.m
//  RtcSample
//
//  Created by daijian on 2019/2/27.
//  Copyright © 2019年 tiantian. All rights reserved.
//

#import "RTCSampleChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AliRTCSdk/AliRTCSdk.h>
#import "RTCSampleUserAuthrization.h"
#import "UIViewController+RTCSampleAlert.h"

@interface RTCSampleChatViewController ()<AliRtcEngineDelegate>


/**
 @brief 开始推流界面
 */
@property(nonatomic, strong) UIButton      *startButton;


/**
 @brief SDK实例
 */
@property (nonatomic, strong) AliRtcEngine *engine;


/**
 @brief 远端流canvas
 */
@property (nonatomic, strong) AliVideoCanvas *remoteCanvas;

@end

@implementation RTCSampleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"1v1视频演示";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加页面控件
    [self addSubviews];
    
    // 创建SDK实例，注册delegate，extras可以为空
    _engine = [AliRtcEngine sharedInstance:self extras:@""];
    
    CGRect rc = [UIScreen mainScreen].bounds;
    rc.size.height /= 2;
    rc.size.height -= 5;
    
    // 设置本地预览视频
    AliVideoCanvas *canvas   = [[AliVideoCanvas alloc] init];
    AliRenderView *viewLocal = [[AliRenderView alloc] initWithFrame:rc];
    canvas.view = viewLocal;
    [self.view insertSubview:viewLocal belowSubview:_startButton];
    [self.engine setLocalViewConfig:canvas forTrack:AliRtcVideoTrackCamera];
   
    _remoteCanvas = [[AliVideoCanvas alloc] init];
    
    //开启本地预览
    [self.engine startPreview];
    
}

#pragma mark - action

/**
 @brief 离开频道
 */
- (void)leaveChannel:(UIButton *)sender {
    [self stopPreView];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 @brief 登陆服务器，并开始推流
 */
- (void)startPreview:(UIButton *)sender {
    
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    if(sender.selected) {
        
        //设置自动(手动)模式
        [self.engine setAutoPublish:YES withAutoSubscribe:YES];
        
        //随机生成用户名，仅是demo展示使用
        NSString *userName = [NSString stringWithFormat:@"iOSUser%u",arc4random()%1234];
        
        //AliRtcAuthInfo:各项参数均需要客户App Server(客户的server端) 通过OpenAPI来获取，然后App Server下发至客户端，客户端将各项参数赋值后，即可joinChannel
        AliRtcAuthInfo *authInfo = [RTCSampleUserAuthrization getPassportFromAppServer:self.channelName userName:userName];
        
        //加入频道
        [self.engine joinChannel:authInfo name:userName onResult:^(NSInteger errCode) {
            //加入频道回调处理
            NSLog(@"joinChannel result: %d", (int)errCode);
        }];
        
        //防止屏幕锁定
        [UIApplication sharedApplication].idleTimerDisabled = YES;
    }
}

#pragma mark - private


/**
 @brief 离开频需要取消本地预览、离开频道、销毁SDK
 */
- (void)stopPreView {
    
    //停止本地预览
    [self.engine stopPreview];
    
    //离开频道
    [self.engine leaveChannel];
    
    //销毁SDK实例
    [AliRtcEngine destroy];
}

#pragma mark - alirtcengine delegate

- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    
    //收到远端订阅回调
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger tag = 12345;
        UIView *renderView = [self.view viewWithTag:tag];
        if (renderView) {
            [renderView removeFromSuperview];
        }
        //设置远端流界面
        CGRect rc = [UIScreen mainScreen].bounds;
        rc.origin.y = rc.size.height/2+5;
        rc.size.height = rc.size.height/2-5;
        AliRenderView *viewRemote = [[AliRenderView alloc] initWithFrame:rc];
        [viewRemote setBackgroundColor:[UIColor blackColor]];
        viewRemote.tag = tag;
        _remoteCanvas.view = viewRemote;
        [self.view insertSubview:viewRemote belowSubview:_startButton];
        
        if(videoTrack == AliRtcVideoTrackCamera) {
            [self.engine setRemoteViewConfig:_remoteCanvas uid:uid forTrack:AliRtcVideoTrackCamera];
        } else if(videoTrack == AliRtcVideoTrackScreen || videoTrack == AliRtcVideoTrackBoth) {
            [self.engine setRemoteViewConfig:_remoteCanvas uid:uid forTrack:AliRtcVideoTrackScreen];
        }
    });
}

- (void)onOccurError:(int)error {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error == AliRtcErrorCodeHeartbeatTimeout || error == AliRtcErrorCodePollingError) {
            [strongSelf showAlertWithMessage:@"网络超时,请退出房间" handler:^(UIAlertAction * _Nonnull action) {
                [strongSelf leaveChannel:nil];
            }];
        }
    });
}

#pragma mark - add subviews

- (void)addSubviews {
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.frame = CGRectMake(0, 0, 60, 40);
    [exitButton setTitle:@"退出" forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [exitButton addTarget:self action:@selector(leaveChannel:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:exitButton];
    
    CGRect rcScreen = [UIScreen mainScreen].bounds;
    CGRect rc = rcScreen;
    rc.size = CGSizeMake(60, 60);
    rc.origin.y = rcScreen.size.height - 100;
    rc.origin.x = self.view.center.x - rc.size.width/2;
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = rc;
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[UIColor orangeColor]];
    _startButton.layer.cornerRadius = rc.size.width/2;
    _startButton.layer.masksToBounds = YES;
    [_startButton addTarget:self action:@selector(startPreview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
}

@end
