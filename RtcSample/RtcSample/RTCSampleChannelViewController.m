#import "RTCSampleChannelViewController.h"
#import <AliRTCSdk/AliRTCSdk.h>
#import "RTCSampleChatViewController.h"
#import "UIViewController+RTCSampleAlert.m"

@interface RTCSampleChannelViewController () <UITextFieldDelegate>

/**
 @brief 频道号textfiled
 */
@property(nonatomic, strong) UITextField *tfChannel;


/**
 @brief 加入频道button
 */
@property(nonatomic, strong) UIButton    *btnJoin;


/**
 @brief 显示SDK版本号label
 */
@property(nonatomic, strong) UILabel     *SDKVersionLabel;

/**
 @brief 音频采集开关
 */
@property(nonatomic, strong) UISwitch *audioCaptureSwitch;

/**
 @brief 音频播放开关
 */
@property(nonatomic, strong) UISwitch *audioPlayerSwitch;

@end

@implementation RTCSampleChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //导航栏名称等基本设置
    [self baseSetting];
    
    //添加页面控件
    [self addSubviews];
    
    //添加手势
    [self addGesture];
    
}

#pragma mark - baseSetting
/**
 @brief 基础设置
 */
- (void)baseSetting{
    self.title = @"AliRTCSample";
    self.view.backgroundColor  = [UIColor whiteColor];
}

#pragma mark - addGesture
/**
 @brief 添加手势
 */
- (void)addGesture{
    //点击屏幕->回收键盘
    UITapGestureRecognizer *endEditeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endTextFeldEdite:)];
    [self.view addGestureRecognizer:endEditeTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - action

- (void)onBtnJoin:(id)sender {
    
    [self.view endEditing:YES];
    NSString *channelName = [_tfChannel.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (0 == channelName.length) {
        [self showAlertWithMessage:@"频道不能为空" handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        return;
    }
    if (![self legalChannel]) {
        [self showAlertWithMessage:@"频道号只能是数字,长度在3-12之间" handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        return;
    }
    RTCSampleChatViewController *chatVC = [[RTCSampleChatViewController alloc] init];
    chatVC.channelName = _tfChannel.text;
    chatVC.audioCapture = self.audioCaptureSwitch.on;
    chatVC.audioPlayer = self.audioPlayerSwitch.on;
    [self.navigationController pushViewController:chatVC animated:YES];
    self.tfChannel.text = @"";
}

//回收键盘
- (void)endTextFeldEdite:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

#pragma mark - private

- (BOOL)legalChannel {
    NSString *pattern = @"^[0-9]{3,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:_tfChannel.text];
    return isMatch;
}

#pragma mark - add subviews

- (void)addSubviews {
    CGRect rcScreen = [UIScreen mainScreen].bounds;
    CGRect rc = rcScreen;
    
    // channel name
    rc.origin.x = rcScreen.size.width/2-130;
    rc.origin.y = self.view.center.y-100;
    rc.size.width  = 260;
    rc.size.height = 40;
    _tfChannel = [[UITextField alloc] initWithFrame:rc];
    _tfChannel.backgroundColor = [UIColor whiteColor];
    _tfChannel.clearButtonMode = UITextFieldViewModeAlways;
    _tfChannel.borderStyle = UITextBorderStyleRoundedRect;
    _tfChannel.placeholder = @"请输入频道号(3-12位数字)";
    _tfChannel.keyboardType  = UIKeyboardTypeNumberPad;
    _tfChannel.returnKeyType = UIReturnKeyGo;
    _tfChannel.delegate = self;
    [self.view addSubview:_tfChannel];
    
    // join button
    rc.origin.x = _tfChannel.center.x - 50;
    rc.origin.y = _tfChannel.center.y + 60;
    rc.size  = CGSizeMake(100, 40);
    _btnJoin = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnJoin.frame = rc;
    _btnJoin.layer.backgroundColor = [UIColor grayColor].CGColor;
    _btnJoin.layer.borderWidth   = 0.5f;
    _btnJoin.layer.cornerRadius  = 5;
    _btnJoin.layer.masksToBounds = YES;
    [_btnJoin setBackgroundColor:[UIColor whiteColor]];
    [_btnJoin setTitle:@"确定" forState:UIControlStateNormal];
    [_btnJoin setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btnJoin addTarget:self action:@selector(onBtnJoin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnJoin];
    
    //sdk version label
    rc.origin.x = 0;
    rc.origin.y = self.view.frame.size.height-40;
    rc.size = CGSizeMake(rcScreen.size.width, 40);
    _SDKVersionLabel = [[UILabel alloc] initWithFrame:rc];
    _SDKVersionLabel.text = [AliRtcEngine getSdkVersion];
    _SDKVersionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_SDKVersionLabel];
    
    rc.origin.x = 20;
    rc.origin.y = 104.5;
    rc.size = CGSizeMake(51, 31);
    self.audioCaptureSwitch = [[UISwitch alloc] initWithFrame:rc];
    self.audioCaptureSwitch.transform = CGAffineTransformMakeScale(0.8,0.8);
    [self.view addSubview:self.audioCaptureSwitch];
    
    rc.origin.x = 72;
    rc.origin.y = 100;
    rc.size = CGSizeMake(70, 40);
    UILabel *audioCaptureLabel = [[UILabel alloc] initWithFrame:rc];
    audioCaptureLabel.text = @"音频采集";
    audioCaptureLabel.font = [UIFont systemFontOfSize:17];
    audioCaptureLabel.textColor = [UIColor blackColor];
    audioCaptureLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:audioCaptureLabel];
    
    rc.origin.x = 20;
    rc.origin.y = 144.5;
    rc.size = CGSizeMake(51, 31);
    self.audioPlayerSwitch = [[UISwitch alloc] initWithFrame:rc];
    self.audioPlayerSwitch.transform = CGAffineTransformMakeScale(0.8,0.8);
    [self.view addSubview:self.audioPlayerSwitch];
    
    rc.origin.x = 72;
    rc.origin.y = 140;
    rc.size = CGSizeMake(70, 40);
    UILabel *audioPlayerLabel = [[UILabel alloc] initWithFrame:rc];
    audioPlayerLabel.text = @"音频播放";
    audioPlayerLabel.font = [UIFont systemFontOfSize:17];
    audioPlayerLabel.textColor = [UIColor blackColor];
    audioPlayerLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:audioPlayerLabel];
}

@end
