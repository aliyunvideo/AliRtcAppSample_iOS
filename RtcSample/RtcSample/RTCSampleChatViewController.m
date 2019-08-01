//
//  RTCSampleChatViewController.m
//  RtcSample
//
//  Created by daijian on 2019/2/27.
//  Copyright © 2019年 tiantian. All rights reserved.
//

#import "RTCSampleChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "RTCSampleUserAuthrization.h"
#import "UIViewController+RTCSampleAlert.h"
#import "RTCSampleRemoteUserManager.h"
#import "RTCSampleRemoteUserModel.h"

@interface RTCSampleChatViewController ()<AliRtcEngineDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


/**
 @brief 开始推流界面
 */
@property(nonatomic, strong) UIButton      *startButton;


/**
 @brief SDK实例
 */
@property (nonatomic, strong) AliRtcEngine *engine;


/**
 @brief 远端用户管理
 */
@property(nonatomic, strong) RTCSampleRemoteUserManager *remoteUserManager;


/**
 @brief 远端用户视图
 */
@property(nonatomic, strong) UICollectionView *remoteUserView;


/**
 @brief 是否入会
 */
@property(nonatomic, assign) BOOL isJoinChannel;

@end

@implementation RTCSampleChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航栏名称等基本设置
    [self baseSetting];
    
    //初始化SDK内容
    [self initializeSDK];
    
    //开启本地预览
    [self startPreview];
    
    //添加页面控件
    [self addSubviews];
    
}


#pragma mark - baseSetting
/**
 @brief 基础设置
 */
- (void)baseSetting{
    self.title = @"视频通话";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - initializeSDK
/**
 @brief 初始化SDK
 */
- (void)initializeSDK{
    // 创建SDK实例，注册delegate，extras可以为空
    _engine = [AliRtcEngine sharedInstance:self extras:@""];
    
}

- (void)startPreview{
    // 设置本地预览视频
    AliVideoCanvas *canvas   = [[AliVideoCanvas alloc] init];
    AliRenderView *viewLocal = [[AliRenderView alloc] init];
    viewLocal.frame = self.view.bounds;
    canvas.view = viewLocal;
    canvas.renderMode = AliRtcRenderModeAuto;
    [self.view addSubview:viewLocal];
    [self.engine setLocalViewConfig:canvas forTrack:AliRtcVideoTrackCamera];
    
    // 开启本地预览
    [self.engine startPreview];
}

#pragma mark - action

/**
 @brief 登陆服务器，并开始推流
 */
- (void)startPreview:(UIButton *)sender {
    
    sender.enabled = NO;
    //设置自动(手动)模式
    [self.engine setAutoPublish:YES withAutoSubscribe:YES];
    
    if (self.audioCapture) {
        [self.engine startAudioCapture];  //开启音频采集
    }else{
        [self.engine stopAudioCapture];   //关闭音频采集
    }
    
    if (self.audioPlayer) {
        [self.engine startAudioPlayer];  //开启音频播放
    }else{   //关闭音频采集
        [self.engine stopAudioPlayer];   //关闭音频播放
    }
    
    //随机生成用户名，仅是demo展示使用
    NSString *userName = [NSString stringWithFormat:@"iOSUser%u",arc4random()%1234];
    
    //AliRtcAuthInfo:各项参数均需要客户App Server(客户的server端) 通过OpenAPI来获取，然后App Server下发至客户端，客户端将各项参数赋值后，即可joinChannel
    AliRtcAuthInfo *authInfo = [RTCSampleUserAuthrization getPassportFromAppServer:self.channelName userName:userName];
    
    //加入频道
    
    [self.engine enableSpeakerphone:YES];

    
    [self.engine joinChannel:authInfo name:userName onResult:^(NSInteger errCode) {
        //加入频道回调处理
        NSLog(@"joinChannel result: %d", (int)errCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errCode != 0) {
                sender.enabled = YES;
            }
            _isJoinChannel = YES;
        });
    }];
    
    //防止屏幕锁定
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

/**
 @brief 离开频道
 */
- (void)leaveChannel:(UIButton *)sender {
    [self leaveChannel];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private

/**
 @brief 离开频需要取消本地预览、离开频道、销毁SDK
 */
- (void)leaveChannel {
    
    [self.remoteUserManager removeAllUser];
    
    //停止本地预览
    [self.engine stopPreview];
    
    if (_isJoinChannel) {
        //离开频道
        [self.engine leaveChannel];
    }

    [self.remoteUserView removeFromSuperview];
    
    //销毁SDK实例
    [AliRtcEngine destroy];
    
    self.engine = nil;
}

#pragma mark - uicollectionview delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.remoteUserManager allOnlineUsers].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RTCRemoterUserView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    RTCSampleRemoteUserModel *model =  [self.remoteUserManager allOnlineUsers][indexPath.row];
    AliRenderView *view = model.view;
    [cell updateUserRenderview:view];
    
    //记录UID
    NSString *uid = model.uid;
    //视频流类型
    AliRtcVideoTrack track = model.track;
    if (track == AliRtcVideoTrackScreen) {  //默认为视频镜像,如果是屏幕则替换屏幕镜像
        cell.CameraMirrorLabel.text = @"屏幕镜像";
    }
    
    cell.switchblock = ^(BOOL isOn) {
        [self switchClick:isOn track:track uid:uid];
    };
    
    cell.mediaInfoblock = ^{
        [self mediaInfoClick:track uid:uid];
    };
    
    return cell;
}

//远端用户镜像按钮点击事件
- (void)switchClick:(BOOL)isOn track:(AliRtcVideoTrack)track uid:(NSString *)uid {
    AliVideoCanvas *canvas = [[AliVideoCanvas alloc] init];
    canvas.renderMode = AliRtcRenderModeFill;
    if (track == AliRtcVideoTrackCamera) {
        canvas.view = (AliRenderView *)[self.remoteUserManager cameraView:uid];
    }
    else if (track == AliRtcVideoTrackScreen) {
        canvas.view = (AliRenderView *)[self.remoteUserManager screenView:uid];
    }
    
    if (isOn) {
        canvas.mirrorMode = AliRtcRenderMirrorModeAllEnabled;
    }else{
        canvas.mirrorMode = AliRtcRenderMirrorModeAllDisabled;
    }
    [self.engine setRemoteViewConfig:canvas uid:uid forTrack:track];
}

//获取当前的媒体流信息
- (void)mediaInfoClick:(AliRtcVideoTrack)track uid:(NSString *)uid {
    NSString *mediaInfoCamera = [self.engine getMediaInfoWithUserId:uid videoTrack:track keys:@[@"Height",@"Width",@"FPS",@"LossRate"]];
    UIAlertController *alertVc  = [UIAlertController alertControllerWithTitle:@"媒体流信息" message:mediaInfoCamera preferredStyle:UIAlertControllerStyleAlert];
    //弹出视图,使用UIViewController的方法
    [self presentViewController:alertVc animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //隔一会就消失
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
    }];
}

#pragma mark - alirtcengine delegate

- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    
    //收到远端订阅回调
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remoteUserManager updateRemoteUser:uid forTrack:videoTrack];
        if (videoTrack == AliRtcVideoTrackCamera) {
            AliVideoCanvas *canvas = [[AliVideoCanvas alloc] init];
            canvas.renderMode = AliRtcRenderModeAuto;
            canvas.view = [self.remoteUserManager cameraView:uid];
            [self.engine setRemoteViewConfig:canvas uid:uid forTrack:AliRtcVideoTrackCamera];
        }else if (videoTrack == AliRtcVideoTrackScreen) {
            AliVideoCanvas *canvas2 = [[AliVideoCanvas alloc] init];
            canvas2.renderMode = AliRtcRenderModeAuto;
            canvas2.view = [self.remoteUserManager screenView:uid];
            [self.engine setRemoteViewConfig:canvas2 uid:uid forTrack:AliRtcVideoTrackScreen];
        }else if (videoTrack == AliRtcVideoTrackBoth) {
            
            AliVideoCanvas *canvas = [[AliVideoCanvas alloc] init];
            canvas.renderMode = AliRtcRenderModeAuto;
            canvas.view = [self.remoteUserManager cameraView:uid];
            [self.engine setRemoteViewConfig:canvas uid:uid forTrack:AliRtcVideoTrackCamera];
            
            AliVideoCanvas *canvas2 = [[AliVideoCanvas alloc] init];
            canvas2.renderMode = AliRtcRenderModeAuto;
            canvas2.view = [self.remoteUserManager screenView:uid];
            [self.engine setRemoteViewConfig:canvas2 uid:uid forTrack:AliRtcVideoTrackScreen];
        }
        [self.remoteUserView reloadData];
    });
}

- (void)onRemoteUserOnLineNotify:(NSString *)uid {
    
}

- (void)onRemoteUserOffLineNotify:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.remoteUserManager remoteUserOffLine:uid];
        [self.remoteUserView reloadData];
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

- (void)onBye:(int)code {
    if (code == AliRtcOnByeChannelTerminated) {
        // channel结束
    }
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
    rc.size   = CGSizeMake(60, 60);
    rc.origin.y  = rcScreen.size.height - 100;
    rc.origin.x  = self.view.center.x - rc.size.width/2;
    _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _startButton.frame = rc;
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton setBackgroundColor:[UIColor orangeColor]];
    _startButton.layer.cornerRadius  = rc.size.width/2;
    _startButton.layer.masksToBounds = YES;
    [_startButton addTarget:self action:@selector(startPreview:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];
    
    rc.origin.x = 10;
    rc.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height+20+44;
    rc.size = CGSizeMake(self.view.frame.size.width-20, 280);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(140, 280);
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.remoteUserView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.remoteUserView.frame = rc;
    self.remoteUserView.backgroundColor = [UIColor clearColor];
    self.remoteUserView.delegate   = self;
    self.remoteUserView.dataSource = self;
    self.remoteUserView.showsHorizontalScrollIndicator = NO;
    [self.remoteUserView registerClass:[RTCRemoterUserView class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.remoteUserView];
    
    _remoteUserManager = [RTCSampleRemoteUserManager shareManager];
    
}

@end

@implementation RTCRemoterUserView
{
    AliRenderView *viewRemote;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //设置远端流界面
        CGRect rc  = CGRectMake(0, 0, 140, 200);
        viewRemote = [[AliRenderView alloc] initWithFrame:rc];
        self.backgroundColor = [UIColor clearColor];
        
        CGRect viewrc  = CGRectMake(0, 200, 140, 80);
        _view = [[UIView alloc] initWithFrame:viewrc];
        _view.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.view];
        
        rc.origin.x = 8;
        rc.size = CGSizeMake(70, 40);
        _CameraMirrorLabel = [[UILabel alloc] initWithFrame:rc];
        self.CameraMirrorLabel.text = @"视频镜像";  //默认
        self.CameraMirrorLabel.textAlignment = 0;
        self.CameraMirrorLabel.font = [UIFont systemFontOfSize:17];
        self.CameraMirrorLabel.textColor = [UIColor whiteColor];
        self.CameraMirrorLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:self.CameraMirrorLabel];
        
        rc.origin.x = 81;
        rc.origin.y = 4.5;
        rc.size = CGSizeMake(51, 31);
        _CameraMirrorSwitch = [[UISwitch alloc] initWithFrame:rc];
        _CameraMirrorSwitch.transform = CGAffineTransformMakeScale(0.8,0.8);
        [self.CameraMirrorSwitch addTarget:self action:@selector(onCameraMirrorClicked:)  forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.CameraMirrorSwitch];
        
        rc.origin.x = 0;
        rc.origin.y = 40;
        rc.size = CGSizeMake(140, 40);
        UIButton *mediaInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mediaInfoButton.frame = rc;
        [mediaInfoButton setTitle:@"显示媒体流信息" forState:0];
        [mediaInfoButton setTitleColor:[UIColor whiteColor] forState:0];
        mediaInfoButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [mediaInfoButton addTarget:self action:@selector(getMediaInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:mediaInfoButton];
    }
    return self;
}

- (void)updateUserRenderview:(AliRenderView *)view {
    view.backgroundColor = [UIColor clearColor];
    view.frame = viewRemote.frame;
    viewRemote = view;
    [self addSubview:viewRemote];
}

- (void)onCameraMirrorClicked:(UISwitch *)switchView{
    if (self.switchblock) {
        self.switchblock(switchView.on);
    }
}

- (void)getMediaInfoClicked:(UIButton *)button{
    if (self.mediaInfoblock) {
        self.mediaInfoblock();
    }
}

@end
