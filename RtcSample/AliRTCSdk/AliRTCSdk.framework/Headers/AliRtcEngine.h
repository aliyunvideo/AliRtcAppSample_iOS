/* Copyright (c) 2018, Alibaba Inc.
 * All rights reserved
 */

/* This header file is part of Alibaba RTC engine sdk for
 * Mac system.
 */

#import <UIKit/UIKit.h>

/**
 视频流类型

 - AliRtcVideoTrackNo: No
 - AliRtcVideoTrackCamera: 摄像头
 - AliRtcVideoTrackScreen: 屏幕共享
 - AliRtcVideoTrackBoth: 摄像头+屏幕共享
 */
typedef NS_ENUM(NSUInteger, AliRtcVideoTrack) {
    AliRtcVideoTrackNo     = 0,
    AliRtcVideoTrackCamera = 1,
    AliRtcVideoTrackScreen = 2,
    AliRtcVideoTrackBoth   = 3,
};

/**
 音频流类型

 - AliRtcAudioTrackNo: No
 - AliRtcAudioTrackMic: 麦克风
 */
typedef NS_ENUM(NSUInteger, AliRtcAudioTrack) {
    AliRtcAudioTrackNo   = 0,
    AliRtcAudioTrackMic  = 1,
};

/**
 网路状态

 - AliRtcNetworkQualityGood: 良好
 - AliRtcNetworkQualityPoor: 差
 */
typedef NS_ENUM(NSUInteger, AliRtcNetworkQuality) {
    AliRtcNetworkQualityGood   = 1,
    AliRtcNetworkQualityPoor   = 3,
};

/**
 渲染模式

 - AliRtcRenderModeAuto: 自动模式
 - AliRtcRenderModeStretch: 延伸
 - AliRtcRenderModeFill: 填充
 - AliRtcRenderModeCrop: 裁剪
 */
typedef NS_ENUM(NSUInteger, AliRtcRenderMode) {
    AliRtcRenderModeAuto    = 0,
    AliRtcRenderModeStretch = 1,
    AliRtcRenderModeFill    = 2,
    AliRtcRenderModeCrop    = 3,
};

/**
 Log级别
 */
typedef NS_ENUM(NSUInteger, AliRtcLogLevel) {
    AliRtcLogLevelDump,
    AliRtcLogLevelDebug,
    AliRtcLogLevelVerbose,
    AliRtcLogLevelInfo,
    AliRtcLogLevelWarn,
    AliRtcLogLevelError,
    AliRtcLogLevelFatal,
    AliRtcLogLevelNone,
};

/**
 VideoProfile
 */
typedef NS_ENUM(NSInteger, AliRtcVideoProfile) {
    AliRtcVideoProfile_Default = 0,
    AliRtcVideoProfile_180_320P_15,
    AliRtcVideoProfile_180_320P_30,
    AliRtcVideoProfile_360_640P_15,
    AliRtcVideoProfile_360_640P_30,
    AliRtcVideoProfile_720_1280P_15,
    AliRtcVideoProfile_720_1280P_30,
    AliRtcVideoProfile_Max
};

/**
 VideoSource
 */
typedef NS_ENUM(NSInteger, AliRtcVideoSource) {
    AliRtcVideosourceCameraLargeType = 0,
    AliRtcVideosourceCameraSmallType = 1,
    AliRtcVideosourceScreenShareType = 2,
    AliRtcVideosourceTypeMax,
};

/**
 AudioSource
 */
typedef NS_ENUM(NSInteger, AliRtcAudioSource) {
    AliRtcAudiosourcePub = 0,
    AliRtcAudiosourceSub = 1,
};

/**
 TextureType
 */
typedef NS_ENUM(NSInteger, AliRtcVideoTextureType) {
    AliRtcVideoTextureTypeUnknown = -1,
    AliRtcVideoTextureTypePre = 0,
    AliRtcVideoTextureTypePost = 1,
};



/**
 镜像模式

 - AliRtcRenderMirrorModeOnlyFrontCameraPreviewEnabled: 只有前置摄像头预览镜像，其余不镜像
 - AliRtcRenderMirrorModeAllEnabled: 全部镜像
 - AliRtcRenderMirrorModeAllDisabled: 全部不镜像
 */
typedef NS_ENUM(NSInteger, AliRtcRenderMirrorMode) {
    AliRtcRenderMirrorModeOnlyFrontCameraPreviewEnabled = 0,
    AliRtcRenderMirrorModeAllEnabled = 1,
    AliRtcRenderMirrorModeAllDisabled = 2,
};

/**
 错误码

 - AliRtcErrorCodeNone: 无
 - AliRtcErrorCodeHeartbeatTimeout: 心跳超时
 - AliRtcErrorCodePollingError: 信令错误
 */
typedef NS_ENUM(NSInteger, AliRtcErrorCode) {
    AliRtcErrorCodeNone = 0,
    AliRtcErrorCodeHeartbeatTimeout = 0x0102020C,
    AliRtcErrorCodePollingError = 0x02010105,
};



/**
 OnBye类型

 - AliRtcOnByeChannelDestroy: channel已结束，需要离开会议
 */
typedef NS_ENUM(NSInteger, AliRtcOnByeType) {
    AliRtcOnByeChannelTerminated = 2,
};


@interface AliRtcAuthInfo : NSObject

@property (nonatomic, retain) NSString *channel;
@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *appid;
@property (nonatomic, retain) NSString *nonce;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSArray <NSString *> *gslb;
@property (nonatomic, assign) long long timestamp;

@end


@interface AliRTCRenderView : UIView

@end


@interface AliRenderView : AliRTCRenderView

@end


@interface AliVideoCanvas : NSObject

// 渲染view，不可为nil
@property (nonatomic, strong) AliRenderView *view;

// 默认 AliRtcRenderModeAuto
@property (nonatomic) AliRtcRenderMode renderMode;

// 默认 AliRtcRenderMirrorModeOnlyFrontCameraPreviewEnabled
@property (nonatomic) AliRtcRenderMirrorMode mirrorMode;

@end


@interface AliRtcAudioDataSample : NSObject

@property (nonatomic, assign) long dataPtr;
@property (nonatomic, assign) int numOfSamples;
@property (nonatomic, assign) int bytesPerSample;
@property (nonatomic, assign) int numOfChannels;
@property (nonatomic, assign) int samplesPerSec;

@end


@interface AliRtcVideoDataSample : NSObject

@property (nonatomic, assign) NSInteger format;
@property (nonatomic, assign) long dataPtr;
@property (nonatomic, assign) int strideY;
@property (nonatomic, assign) int strideU;
@property (nonatomic, assign) int strideV;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int rotation;
@property (nonatomic, assign) int stride;
@property (nonatomic, assign) long long timeStamp;

@end


@protocol AliRtcEngineDelegate <NSObject>
@optional

/**
 * @brief 当远端用户上线时会返回这个消息
 * @param uid         User ID。从App server分配的唯一标示符
 * @note This message does not mean the user remains online state
 */
- (void)onRemoteUserOnLineNotify:(NSString *)uid;

/**
 * @brief 当远端用户下线时会返回这个消息
 * @param uid         User ID。从App server分配的唯一标示符
 * @note This message does not mean the user remains offline state
 */
- (void)onRemoteUserOffLineNotify:(NSString *)uid;

/**
 * @brief 当远端用户的流发生变化时，返回这个消息
 * @note 远方用户停止推流，也会发送这个消息
 */
- (void)onRemoteTrackAvailableNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack;

/**
 * @brief 当订阅情况发生变化时，返回这个消息
 */
- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack;

/**
 * @brief 网络质量变化时发出的消息
 * @note 当网络质量发生变化时触发
 */
- (void)onNetworkQualityChanged:(AliRtcNetworkQuality)quality;

/**
 * @brief 被服务器踢出频道的消息
 */
- (void)onBye:(int)code;

/**
 * @brief 如果engine出现warning，通过这个回调通知app
 * @param warn  Warning type
 */
- (void)onOccurWarning:(int)warn;

/**
 * @brief 如果engine出现error，通过这个回调通知app
 * @param error  Error type
 */
- (void)onOccurError:(int)error;

/**
 * @brief 首帧数据发送成功
 * @param audioTrack  发送成功的音频流类型
 * @param videoTrack  发送成功的视频流类型
 */
- (void)onFirstPacketSentWithAudioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack;

/**
  * @brief remote user的第一帧视频帧显示时触发这个消息
  * @param uid   User ID。从App server分配的唯一标示符
  * @param videoTrack 屏幕流或者相机流
  */
- (void)onFirstRemoteVideoFrameDrawn:(NSString *)uid videoTrack:(AliRtcVideoTrack)videoTrack;

/**
 * @brief 订阅的音频数据回调
 * @param audioSource audio source
 * @param audioSample audio sample
 */
- (void)onAudioSampleCallback:(AliRtcAudioSource)audioSource audioSample:(AliRtcAudioDataSample *)audioSample;

/**
 * @brief 订阅的视频数据回调
 * @param uid user id
 * @param videoSource video source
 * @param videoSample video sample
 */
- (void)onVideoSampleCallback:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource videoSample:(AliRtcVideoDataSample *)videoSample;

/**
 * @brief 订阅的视频Texture回调
 * @param uid user id
 * @param videoTextureType video texture type
 * @param context context
 */
- (void)onVideoTextureCreated:(NSString *)uid videoTextureType:(AliRtcVideoTextureType)videoTextureType context:(void *)context;

/**
 * @brief 订阅的视频Texture回调
 * @param uid user id
 * @param videoTextureType video texture type
 * @param textureId texture id
 * @param width width
 * @param height height
 * @param extraData extraData
 */
- (int)onVideoTexture:(NSString *)uid videoTextureType:(AliRtcVideoTextureType)videoTextureType textureId:(int)textureId width:(int)width height:(int)height extraData:(long)extraData ;

/**
 * @brief 订阅的视频Texture回调
 * @param uid user id
 * @param videoTextureType video texture type
 */
- (void)onVideoTextureDestory:(NSString *)uid videoTextureType:(AliRtcVideoTextureType)videoTextureType;

@end


@interface AliRtcEngine : NSObject <AliRtcEngineDelegate>

-(instancetype) init __attribute__((unavailable("use sharedInstance to create the singletone")));

#pragma mark - "Engine的生命周期，工作参数以及频道操作"


/**
 * @brief 初始化
 * @param delegate delegate
 * @param extras extras [可以为空 @""]
 * @return self
 */
+ (instancetype)sharedInstance:(id<AliRtcEngineDelegate>)delegate extras:(NSString *)extras;

/**
 * @brief 销毁
 */
+ (void)destroy;

/**
 * @brief 获取sdk版本号
 * @return SDK版本号
 * @note 在任何时刻都可以调用
 */
+ (NSString *)getSdkVersion;

/**
 * @brief 设置是否自动publish音视频流和subscribe音视频流
 * @param autoPub    YES表示自动推流；NO表示不自动推流
 * @param autoSub    YES表示自动拉流；NO表示不自动拉流
 * @return 0表示Success 非0表示Failure
 * @note 缺省是自动推流和拉流。只可以在joinChannel之前设置
 */
- (int)setAutoPublish:(BOOL)autoPub withAutoSubscribe:(BOOL)autoSub;

/**
 * @brief 设置音频模式还是音视频模式
 * @param audioOnly  YES表示只有音频推流和拉流；NO表示音视频都支持
 * @return 0表示Success 非0表示Failure
 * @note 只可以在joinChannel之前设置
 */
- (int)setAudioOnlyMode:(BOOL)audioOnly;

/**
 * @brief 加入频道
 * @param authInfo    认证信息，从App Server获取。
 * @param userName    任意用于显示的用户名称。不是User ID
 * @param onResult    当joinChannel执行结束后调用这个回调
 * @note 异步接口。是否成功入会，通过onResult判断
 */
- (void)joinChannel:(AliRtcAuthInfo *)authInfo name:(NSString *)userName onResult:(void(^)(NSInteger errCode))onResult;

/**
 * @brief 离开频道
 * @note: 如果当前不在频道内，leaveChannel不会有任何影响。leaveChannel会产生消息通知频道内其他用户
 */
- (void)leaveChannel;

#pragma mark - "设置和操作本地的媒体"

//
// 本地视频预览 (只预览AliVideoTrackCamera，不预览AliVideoTrackScreen)
//

/**
 * @brief 为本地预览设置窗口以及绘制参数
 * @param viewConfig 包含了窗口以及渲染方式
 * @param track      must be AliVideoTrackCamera
 * @return 0表示Success 非0表示Failure
 * @note 支持joinChannel之前和之后切换窗口。如果viewConfig或者viewConfig中的view为nil，则停止渲染
 *       如果在播放过程中需要重新设置render mode，请保持canvas中其他成员变量不变，仅修改
 *       renderMode
 *       如果在播放过程中需要重新设置mirror mode，请保持canvas中其他成员变量不变，仅修改
 *       mirrorMode
 */
- (int)setLocalViewConfig:(AliVideoCanvas *)viewConfig forTrack:(AliRtcVideoTrack)track;

/**
 * @brief 开始本地预览
 * @return 0表示Success 非0表示Failure
 * @note 如果没有设置view，则无法预览。可以在joinChannel之前就开启预览
 *       会自动打开摄像头
 */
- (int)startPreview;

/**
 * @brief 停止本地预览
 * @return 0表示Success 非0表示Failure
 * @note leaveChannel会自动停止本地预览
 *       会自动关闭摄像头 (如果正在publish camera流，则不会关闭摄像头)
 */
- (int)stopPreview;

/**
 * @brief 是否将停止本地视频采集
 * @param mute     YES表示停止视频采集；NO表示恢复正常
 * @param track    需要停止采集的track
 * @return 0表示Success 非0表示Failure
 * @note 发送黑色的视频帧。本地预览也呈现黑色。采集，编码，发送模块仍然工作，
 *       只是视频内容是黑色帧
 */
- (int)muteLocalCamera:(BOOL)mute forTrack:(AliRtcVideoTrack)track;

//
// 推流 (音频/视频)
//

/**
 * @brief 手动推送视频和音频流
 * @param onResult    当publish执行结束后调用这个回调
 * @note 需要推送的流通过API xxxx设置好
 *       如果需要手工配置所有推流和拉流，请关闭autoPub (见- (int)setAutoPublish:(BOOL)autoPub withAutoSubscribe:(BOOL)autoSub)
 *       这个是异步接口。结果通过result返回。返回可能在caller线程，也可能在其他线程调用
 *       如果想停止推送所有流，通过publish实现
 */
- (void)publish:(void (^)(int errCode))onResult;

//
// 编码
//

/**
 * @brief 设置视频track的profile
 * @param profile     预定义的视频profile
 * @param track       需要设置的track
 * @note 可以在join channel之前或者之后设置
 */
- (void)setVideoProfile:(AliRtcVideoProfile)profile forTrack:(AliRtcVideoTrack)track; // not work by now

//
// 话筒
//

/**
 * @brief mute/unmute本地音频采集
 * @param mute  YES表示本地音频采集空帧；NO表示恢复正常
 * @note mute是指采集和发送静音帧。采集和编码模块仍然在工作
 * @return 0表示成功放入队列，-1表示被拒绝
 */
- (int)muteLocalMic:(BOOL)mute;

//
// 扬声器
//


#pragma mark - "操作来自远端的媒体"

/**
 * @brief 为远端的视频设置窗口以及绘制参数
 * @param canvas canvas包含了窗口以及渲染方式
 * @param uid    User ID。从App server分配的唯一标示符
 * @param track  需要设置的track
 * @return 0表示Success 非0表示Failure
 * @note 支持joinChannel之前和之后切换窗口。如果canvas为nil或者view为nil，则停止渲染相应的流
 *       如果在播放过程中需要重新设置render mode，请保持canvas中其他成员变量不变，仅修改
 *       renderMode
 *       如果在播放过程中需要重新设置mirror mode，请保持canvas中其他成员变量不变，仅修改
 *       mirrorMode
 */
- (int)setRemoteViewConfig:(AliVideoCanvas *)canvas uid:(NSString *)uid forTrack:(AliRtcVideoTrack)track;

/**
 * @brief mute/unmute远端的音频track的播放
 * @param uid     User ID。从App server分配的唯一标示符
 * @param mute    YES表示停止播放；NO表示恢复播放
 * @return 0表示Success 非0表示Failure
 * @note 拉流和解码不受影响。支持joinChannel之前和之后设置
 */
- (int)muteRemoteAudioPlaying:(NSString *)uid mute:(BOOL)mute;

/**
 * @brief 手动拉视频和音频流
 * @param uid        User ID。不允许为nil
 * @param onResult   当subscribe执行结束后调用这个回调
 * @note 如果需要手动选择拉取的流，调用configRemoteAudio, configRemoteCameraTrack,
 *       configRemoteScreenTrack来设置。缺省是拉取audio和camera track
 *       如果需要unsub所有的流，先通过configRemoteAudio, configRemoteCameraTrack,
 *       configRemoteScreenTrack来清除设置，然后调用subscribe
 */
- (void)subscribe:(NSString *)uid onResult:(void (^)(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at))onResult;

#pragma mark - "用户管理"

/**
 * @brief 设置是否允许推送camera track
 * @param enable   是否允许
 * @note 需要调用publish才能生效
 *       缺省允许camera track推流
 */
- (void)configLocalCameraPublish:(BOOL)enable;

/**
 * @brief 查询是否允许推送camera track
 * @return YES: 允许；NO: 禁止
 */
- (BOOL)isLocalCameraPublishEnabled;

/**
 * @brief 设置是否允许推送audio
 * @param enable   是否允许
 * @note 需要调用publish才能生效
 *       缺省允许音频推流
 */
- (void)configLocalAudioPublish:(BOOL)enable;

/**
 * @brief 查询是否允许推送audio track
 * @return YES: 允许；NO: 禁止
 */
- (BOOL)isLocalAudioPublishEnabled;

/**
 * @brief 是否允许推送次要视频流
 * @param enabled    YES表示需要推送次流；NO表示不推送次流
 * @param track      must be AliVideoTrackCamera
 * @return 0表示Success 非0表示Failure
 * @note 需要调用publish才能生效
 *。     缺省enable。目前只支持camera track，不支持screen track
 */
- (int)configLocalSimulcast:(BOOL)enabled forTrack:(AliRtcVideoTrack)track;

/**
 * @brief 查询是否允许推送simulcast (camera track)
 * @return YES: 允许；NO: 禁止
 */
- (BOOL)isLocalSimulcastEnabled;

/**
 * @brief 设置是否拉取音频流
 * @param uid     User ID。从App server分配的唯一标示符。如果设置为nil，则表示
 *                对当前已知的用户进行通配
 * @param enable  YES: 拉取; NO: 不拉取
 * @note 可以在joinChannel之前或者之后设置。如果已经订阅该用户的流，需要调用subscribe:(NSString *)uid onResult:才生效
 */
- (void)configRemoteAudio:(NSString *)uid enable:(BOOL)enable;

/**
 * @brief 设置是否拉取camera视频流
 * @param uid     User ID。从App server分配的唯一标示符。如果设置为nil，则表示
 *                对当前已知的用户进行通配
 * @param master  是否优先拉取大流
 * @param enable  YES: 拉取; NO: 不拉取
 * @note 可以在joinChannel之前或者之后设置。如果已经订阅该用户的流，需要调用subscribe:(NSString *)uid onResult:才生效
 */
- (void)configRemoteCameraTrack:(NSString *)uid preferMaster:(BOOL)master enable:(BOOL)enable;

/**
 * @brief 设置是否拉取screen视频流
 * @param uid     User ID。从App server分配的唯一标示符。如果设置为nil，则表示
 *                对当前已知的用户进行通配
 * @param enable  YES: 拉取; NO: 不拉取
 * @note 可以在joinChannel之前或者之后设置。如果已经订阅该用户的流，需要调用subscribe:(NSString *)uid onResult:才生效
 */
- (void)configRemoteScreenTrack:(NSString *)uid enable:(BOOL)enable;

// 订阅情况查询，见- (NSDictionary *)getUserInfo:(NSString *)uid

/**
 * @brief 获取远端在线用户列表
 * @return 用户列表，保存的是用户ID
 */
- (NSArray<NSString *> *)getOnlineRemoteUsers;

/**
 * @brief 判断用户是否在线
 * @param uid     User ID。从App server分配的唯一标示符。不可为nil
 * @return YES表示在线，NO表示不在线
 */
- (BOOL)isUserOnline:(NSString *)uid;

#pragma mark - "设备管理"

/**
 * @brief 听筒还是耳机
 * @param enable   YES:听筒模式；NO:耳机模式
 * @return 0表示Success 非0表示Failure
 * @note 只有手机有这个api
 */
 - (int)enableSpeakerphone:(BOOL)enable;
/**
 * @brief 切换前后摄像头
 * @return 0表示Success 非0表示Failure
 * @note 只有iOS和android提供这个接口
 */
- (int)switchCamera;

/**
 * @brief 设置摄像头参数
 * @param zoom   zoom的级别
 * @param flash  是否允许闪光灯
 * @param autoFocus 是否自动对焦
 * @return 0表示Success 非0表示Failure
 * @note 在将来版本中统一通过setParameters设置
 */
 - (int)setCameraZoom:(float)zoom flash:(BOOL)flash autoFocus:(BOOL)autoFocus;

/**
 * @brief 开启音频采集
 * @note 此接口可以控制提前打开音频采集，如果不设置，则SDK会在合适的时机在打开音频采集
 */
- (void)startAudioCapture;

/**
 * @brief 关闭音频采集
 * @note 此接口可以控制关闭音频采集，与startAudioCapture对应
 */
- (void)stopAudioCapture;

/**
 * @brief 开启音频播放
 * @note 此接口可以控制提前打开音频播放，如果不设置，则SDK会在合适的时机在打开音频播放
 */
- (void)startAudioPlayer;

/**
 * @brief 关闭音频播放
 * @note 此接口可以控制关闭音频播放，与stopAudioPlayer对应
 */
- (void)stopAudioPlayer;

#pragma mark - "其他"


/**
 获取当前的媒体流信息

 @param userId 需要查询的userId，self请赋值空字符串""
 @param videoTrack 需要查询的媒体流类型
 @param keys 查询key值数组
 @return key-value的json格式字符串
 */
- (NSString *)getMediaInfoWithUserId:(NSString *)userId videoTrack:(AliRtcVideoTrack)videoTrack keys:(NSArray<NSString *> *)keys;

/**
 * @brief 设置log
 * @param logLevel  Log级别
 */
- (void)setLogLevel:(AliRtcLogLevel)logLevel;

/**
 * @brief 检查camera是否打开
 * @return YES表示摄像头已打开；NO表示摄像头没有打开
 */
- (BOOL)isCameraOn;

/**
 * @brief 检查当前是否在频道中
 * @return YES表示加入了频道；NO表示不在频道中
 */
- (BOOL)isInCall;

/**
 * @brief 查询是否自动publish
 * @return YES表示自动Publish  NO表示非自动
 */
- (BOOL)isAutoPublish;

/**
 * @brief 查询是否自动subscribe
 * @return YES表示自动Subscribe  NO表示非自动
 */
- (BOOL)isAutoSubscribe;

/**
 * @brief 查询是否audio only
 * @return YES表示audio Only  NO表示非audio Only
 */
- (BOOL)isAudioOnly;

/**
 * @brief 查询远端用户的各种状态
 * @param uid        User ID。从App server分配的唯一标示符
 * @note Key: userID, isOnline, sessionID, callID, displayName
 *            hasAudio, hasCameraMaster, hasCameraSlave, hasScreenSharing
 *            requestAudio, requestCameraMaster, requestCameraSlave, requestScreenSharing, preferCameraMaster
 *            subScribedAudio, subScribedCameraMaster, subScribedCamearSlave, subScribedScreenSharing
 *            hasCameraView, hasScreenView
 *            muteAudioPlaying
 */
- (NSDictionary *)getUserInfo:(NSString *)uid;

/**
 * @brief 设置H5兼容模式
 * @param comp    YES: 兼容H5; NO: 传统模式，不兼容H5
 * @note 只支持在sdk实例创建之前设置。如果在sdk创建之后改这个设置会引起互通问题。缺省不兼容H5
 */
+ (void)setH5CompatibleMode:(BOOL)comp;

/**
 * @brief 检查当前是否兼容H5
 * @return YES: 兼容H5; NO: 不兼容H5
 */
+ (BOOL)getH5CompatibleMode;

/**
 * @brief 订阅音频数据
 * @param audioSource audio source
 */
- (void)subscribeAudioData:(AliRtcAudioSource)audioSource;

/**
 * @brief 取消订阅音频数据
 * @param audioSource audio source
 */
- (void)unSubscribeAudioData:(AliRtcAudioSource)audioSource;

/**
 * @brief 订阅视频RGB数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)subscribeVideoRGBData:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource;

/**
 * @brief 取消订阅视频RGB数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)unSubscribeVideoRGBData:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource;

/**
 * @brief 订阅视频YUV数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)subscribeVideoYUVData:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource;

/**
 * @brief 取消订阅视频YUV数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)unSubscribeVideoYUVData:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource;
/*
 * @brief 订阅视频数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)subscribeVideoData:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource;

/**
 * @brief 订阅视频纹理数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)subscribeVideoTexture:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource videoTextureType:(AliRtcVideoTextureType)videoTextureType;

/**
 * @brief 取消订阅视频纹理数据
 * @param uid user id
 * @param videoSource video source
 */
- (void)unSubscribeVideoTexture:(NSString *)uid videoSource:(AliRtcVideoSource)videoSource videoTextureType:(AliRtcVideoTextureType)videoTextureType;

/**
 * @brief 允许后台采集
 */
- (void)enableBackGroundRecording:(BOOL)enable;

/**
 * @brief 是否在后台采集
 */
- (BOOL)isBackGroundRecording;

/**
 * @brief 设置customId
 */
- (int)setCustomId:(NSString *)customId;

@end

