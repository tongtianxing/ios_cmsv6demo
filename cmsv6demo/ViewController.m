//
//  ViewController.m
//  cmsv6demo
//
//  Created by Apple on 13-10-1.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "iToast.h"
#import "TTXTalkback.h"
#import "TTXPlaybackSearch.h"
#import "TTXPlaybackVideoController.h"
#import "AFNetworking.h"
#import "PlaybackViewController.h"
#import "VehicleInfoModel.h"
#import "EquipmentInfoModel.h"
#import "DeviceSearchView.h"
#import "Singleton.h"
#import "TTXAccountManager.h"
#import "TTXRealVideoView.h"
#import "TTXSDKPrepare.h"
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    NSString *currentServer;
    NSString *currentIdno;
    VehicleInfoModel *currentVehicle;
    
    BOOL ischange;
    
    BOOL isLogin;
    
    NSString *loginServer;

    NSString *jsession;
    
    NSArray *deviceList;
    
    UITableView *displayList;
    
}
@property (nonatomic ,strong)UITextField *server;
@property (nonatomic ,strong)UITextField *deviceIdno;
@property (nonatomic ,strong)UITextField *port;

@property (nonatomic , strong)UITextField *account;
@property (nonatomic , strong)UITextField *password;


@property (nonatomic , strong)TTXRealVideoView *video1;
@property (nonatomic , strong)TTXRealVideoView *video2;

@property (nonatomic , strong)TTXTalkback *talkback;


@property (nonatomic , strong)UIButton *sound1;
@property (nonatomic , strong)UIButton *sound2;
@property (nonatomic , strong)UIButton *start;
@property (nonatomic , strong)UIButton *stop;

@property (nonatomic , strong)UIButton *record;

@property (nonatomic , strong)UIButton *statTalk;
@property (nonatomic , strong)UIButton *stopTalk;

@property (nonatomic , strong)UIButton *startMt;
@property (nonatomic , strong)UIButton *stopMt;

@property (nonatomic , strong)UIButton *lDisk;
@property (nonatomic , strong)UIButton *lServer;

@property (nonatomic , strong)UIButton *login;

@property (nonatomic , strong)UIButton *playback;

@property (nonatomic , strong)UIButton *device;
@end

@implementation ViewController


#define XCTAssertTrue(expression, format...) \
_XCTPrimitiveAssertTrue(expression, ## format)

#define _XCTPrimitiveAssertTrue(expression, format...) \
({ \
@try { \
BOOL _evaluatedExpression = !!(expression); \
if (!_evaluatedExpression) { \
_XCTRegisterFailure(_XCTFailureDescription(_XCTAssertion_True, 0, @#expression),format); \
} \
} \
@catch (id exception) { \
_XCTRegisterFailure(_XCTFailureDescription(_XCTAssertion_True, 1, @#expression, [exception reason]),format); \
}\
})


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createUI
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LoginInfo" ofType:@"plist"];
    NSDictionary *loginInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *accountInfo = loginInfo[@"Account"];
    NSString *passwordInfo = loginInfo[@"Password"];
    NSString *serverInfo = loginInfo[@"Server"];
    NSString *portInfo = loginInfo[@"Port"];
    
    
    UILabel *label1 = [UILabel new];
    label1.text = @"account:";
    [self.view addSubview:label1];
    CGSize labelSzie = [label1 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    labelSzie = [label1 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.mas_offset(64);
        make.width.mas_offset(labelSzie.width+1);
        make.height.mas_offset(labelSzie.height);
    }];
    
    _account = [UITextField new];
    _account.borderStyle =  UITextBorderStyleRoundedRect;
    [_account setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_account setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    if (accountInfo) {
        _account.text = accountInfo;
    }else{
    _account.text = @"admin";
    }
    [self.view addSubview:_account];
//    [_account addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label1.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(label1.mas_top);
        make.height.equalTo(label1.mas_height);
    }];
    
    UILabel *label11 = [UILabel new];
    label11.text = @"password:";
    [self.view addSubview:label11];
    labelSzie = [label11 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [label11 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.equalTo(label1.mas_bottom).offset(10);
        make.width.mas_offset(labelSzie.width+1);
        make.height.mas_offset(labelSzie.height);
    }];
    _password = [UITextField new];
    _password.borderStyle =  UITextBorderStyleRoundedRect;
    if (passwordInfo) {
        _password.text = passwordInfo;
    }else{
    _password.text = @"admin";
    }
    _password.secureTextEntry = true;
    [self.view addSubview:_password];
//    [_password addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label11.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(label11.mas_top);
        make.height.equalTo(label11.mas_height);
    }];
    
    
    
    
    
    UILabel *label = [UILabel new];
    label.text = @"server:";
    [self.view addSubview:label];
   labelSzie = [label sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.equalTo(label11.mas_bottom).offset(10);
        make.width.mas_offset(labelSzie.width+1);
        make.height.mas_offset(labelSzie.height);
    }];
    UILabel *label3 = [UILabel new];
    label3.text = @"port:";
    [self.view addSubview:label3];
    labelSzie = [label3 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_left);
        make.top.equalTo(label.mas_bottom).offset(5);
        make.width.mas_offset(labelSzie.width+1);
        make.height.mas_offset(labelSzie.height);
    }];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"device Idno:";
    [self.view addSubview:label2];
    labelSzie = [label2 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_left);
        make.top.equalTo(label3.mas_bottom).offset(5);
        make.width.mas_offset(labelSzie.width+1);
        make.height.mas_offset(labelSzie.height);
    }];
    
    _server = [UITextField new];
    _server.borderStyle =  UITextBorderStyleRoundedRect;
    
    if (serverInfo) {
        _server.text = serverInfo;
    }else{
    _server.text = @"192.168.1.60";
    }
    
    [self.view addSubview:_server];
//    [_server addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [_server mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(label.mas_top);
        make.height.equalTo(label.mas_height);
    }];
    
    _port = [UITextField new];
    _port.borderStyle =  UITextBorderStyleRoundedRect;
    if (portInfo) {
        _port.text = portInfo;
    }else{
    _port.text = @"8080";
    }
    [self.view addSubview:_port];
    [_port mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label3.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(label3.mas_top);
        make.height.equalTo(label3.mas_height);
    }];
    
    
    _deviceIdno = [UITextField new];
    _deviceIdno.borderStyle = UITextBorderStyleRoundedRect;
    _deviceIdno.text = @"";
    [self.view addSubview:_deviceIdno];
    _deviceIdno.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTextField:)];
    [_deviceIdno addGestureRecognizer:tap];
    [_deviceIdno mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label2.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(label2.mas_top);
        make.height.equalTo(label2.mas_height);
    }];

    _login  = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.layer.borderWidth = 1;
    [_login setTitle:@"login" forState:UIControlStateNormal];
    [_login setTitle:@"logout" forState:UIControlStateSelected];
    [_login setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [_login addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//  CGSize  btnSize = [_login.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_login];
    [_login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_deviceIdno.mas_bottom).offset(4);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
    }];
    
    displayList = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    displayList.delegate = self;
    displayList.dataSource = self;
    displayList.hidden = true;
    [self.view addSubview:displayList];
    [displayList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_deviceIdno.mas_left);
        make.top.equalTo(_deviceIdno.mas_bottom);
        make.width.equalTo(_deviceIdno.mas_width);
        make.height.mas_offset(150);
    }];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[TTXSDKPrepare prepare] initializationSDK];
    
    
    self.title = @"cmsv6demo";
    [self createUI];
    [self creatUI2Btn];
    
    _talkback = [[TTXTalkback alloc]init];
    CGFloat wh = (MainScreenWidth - 15) / 2;
    _video1 = [[TTXRealVideoView alloc]init];
    _video1.frame = CGRectMake(5, 230, wh, wh);
    [self.view addSubview:_video1];
    _video2 = [[TTXRealVideoView alloc]init];
    _video2.frame = CGRectMake(5+wh+5, 230, wh, wh);
    [self.view addSubview:_video2];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapout)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];

}

-(void)dealloc
{
    
}
-(void)tapout
{
    [_server resignFirstResponder];
    [_password resignFirstResponder];
    [_server resignFirstResponder];
    [_port resignFirstResponder];
    displayList.hidden = true;
    

}
-(void)creatUI2Btn
{
     CGFloat wh = (MainScreenWidth - 15) / 2;
    _sound1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _sound1.layer.borderWidth = 1;
    [_sound1 setTitle:@"sound1" forState:UIControlStateNormal];
    CGSize soundSize =  [_sound1.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_sound1];
    [_sound1 addTarget:self action:@selector(soundClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sound1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((230+wh+5));
        make.left.mas_equalTo(5);
        make.width.mas_equalTo((soundSize.width+5));
        make.height.mas_equalTo(soundSize.height);
    }];
    
    _sound2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _sound2.layer.borderWidth = 1;
    [_sound2 setTitle:@"sound2" forState:UIControlStateNormal];
    [self.view addSubview:_sound2];
    [_sound2 addTarget:self action:@selector(soundClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sound2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sound1);
        make.left.equalTo(_sound1.mas_right).offset(10);
        make.width.mas_equalTo((soundSize.width+5));
        make.height.mas_equalTo(soundSize.height);
    }];
    
    _start = [UIButton buttonWithType:UIButtonTypeSystem];
    _start.layer.borderWidth = 1;
    [_start setTitle:@"start" forState:UIControlStateNormal];
    [self.view addSubview:_start];
    [_start addTarget:self action:@selector(startAndStop:) forControlEvents:UIControlEventTouchUpInside];
    [_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sound1.mas_bottom).offset(10);
        make.left.equalTo(_sound1.mas_left);
        make.width.mas_equalTo((soundSize.width+5));
        make.height.mas_equalTo(soundSize.height);
    }];
    
    _stop = [UIButton buttonWithType:UIButtonTypeSystem];
    _stop.layer.borderWidth = 1;
    [_stop setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:_stop];
    [_stop addTarget:self action:@selector(startAndStop:) forControlEvents:UIControlEventTouchUpInside];
    [_stop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sound2.mas_bottom).offset(10);
        make.left.equalTo(_sound2.mas_left);
        make.width.mas_equalTo((soundSize.width+5));
        make.height.mas_equalTo(soundSize.height);
    }];
    
    _record = [UIButton buttonWithType:UIButtonTypeSystem];
    _record.layer.borderWidth = 1;
    [_record setTitle:@"record" forState:UIControlStateNormal];
    [self.view addSubview:_record];
    [_record addTarget:self action:@selector(recordClick:) forControlEvents:UIControlEventTouchUpInside];
    [_record mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stop.mas_top);
        make.left.equalTo(_stop.mas_right).offset(10);
        make.width.mas_equalTo((soundSize.width+5));
        make.height.mas_equalTo(soundSize.height);
    }];
    
    UILabel *talkback = [UILabel new];
    talkback.text = @"talkback";
    CGSize labelSize = [talkback sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:talkback];
    [talkback mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_start.mas_bottom).offset(10);
        make.left.equalTo(_start.mas_left);
        make.width.mas_equalTo(labelSize.width+1);
        make.height.mas_equalTo(labelSize.height);
    }];
    
    _statTalk = [UIButton buttonWithType:UIButtonTypeSystem];
    _statTalk.layer.borderWidth = 1;
    [_statTalk setTitle:@"start talkback" forState:UIControlStateNormal];
    CGSize stbSize = [_statTalk.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_statTalk];
    [_statTalk addTarget:self action:@selector(talkbackClick:) forControlEvents:UIControlEventTouchUpInside];
    [_statTalk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(talkback.mas_top);
        make.left.equalTo(talkback.mas_right).offset(10);
        make.width.mas_equalTo((stbSize.width+1));
        make.height.mas_equalTo(stbSize.height);
    }];

    _stopTalk = [UIButton buttonWithType:UIButtonTypeSystem];
    _stopTalk.layer.borderWidth = 1;
    [_stopTalk setTitle:@"stop Talkback" forState:UIControlStateNormal];
    [self.view addSubview:_stopTalk];
    [_stopTalk addTarget:self action:@selector(talkbackClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stopTalk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(talkback.mas_top);
        make.left.equalTo(_statTalk.mas_right).offset(10);
        make.width.mas_equalTo((stbSize.width+1));
        make.height.mas_equalTo(stbSize.height);
    }];
    
    UILabel *monitor = [UILabel new];
    monitor.text = @"monitor";
     labelSize = [monitor sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:monitor];
    [monitor mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(talkback.mas_bottom).offset(10);
        make.left.equalTo(talkback.mas_left);
        make.width.mas_equalTo(labelSize.width+1);
        make.height.mas_equalTo(labelSize.height);
    }];
    
    _startMt = [UIButton buttonWithType:UIButtonTypeSystem];
    _startMt.layer.borderWidth = 1;
    [_startMt setTitle:@"startMt" forState:UIControlStateNormal];
      CGSize smtSize = [_startMt.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_startMt];
    [_startMt addTarget:self action:@selector(monitorClick:) forControlEvents:UIControlEventTouchUpInside];
    [_startMt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monitor.mas_top);
        make.left.equalTo(monitor.mas_right).offset(10);
        make.width.mas_equalTo((smtSize.width+1));
        make.height.mas_equalTo(smtSize.height);
    }];
    _stopMt = [UIButton buttonWithType:UIButtonTypeSystem];
    _stopMt.layer.borderWidth = 1;
    [_stopMt setTitle:@"stopMt" forState:UIControlStateNormal];
    [self.view addSubview:_stopMt];
    [_stopMt addTarget:self action:@selector(monitorClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stopMt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monitor.mas_top);
        make.left.equalTo(_startMt.mas_right).offset(10);
        make.width.mas_equalTo((smtSize.width+1));
        make.height.mas_equalTo(smtSize.height);
    }];
    
    UILabel *label3 = [UILabel new];
    label3.text = @"playback";
    labelSize = [label3 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(monitor.mas_bottom).offset(10);
        make.left.equalTo(talkback.mas_left);
        make.width.mas_equalTo(labelSize.width+1);
        make.height.mas_equalTo(labelSize.height);
    }];
    
    _playback = [UIButton buttonWithType:UIButtonTypeSystem];
      _playback.layer.borderWidth = 1;
        [_playback setTitle:@"playback" forState:UIControlStateNormal];
        [_playback addTarget:self action:@selector(searchPlayback:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_playback];
     CGSize btnSize = [_playback.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
        [_playback mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label3.mas_right).offset(10);
            make.top.equalTo(label3);
            make.width.mas_equalTo((btnSize.width+1));
            make.height.mas_equalTo(btnSize.height);
        }];
    
    UILabel *label4 = [UILabel new];
    label4.text = @"device";
    labelSize = [label4 sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label3.mas_bottom).offset(10);
        make.left.equalTo(label3.mas_left);
        make.width.mas_equalTo(labelSize.width+1);
        make.height.mas_equalTo(labelSize.height);
    }];
    
    _device = [UIButton buttonWithType:UIButtonTypeSystem];
    _device.layer.borderWidth = 1;
    [_device setTitle:@"device" forState:UIControlStateNormal];
    [_device addTarget:self action:@selector(searchDevice:) forControlEvents:UIControlEventTouchUpInside];
     btnSize = [_device.titleLabel sizeThatFits:CGSizeMake(MainScreenWidth, MainScreenHeight)];
    [self.view addSubview:_device];
    [_device mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label4.mas_top);
        make.left.equalTo(label4.mas_right).offset(10);
        make.width.mas_equalTo(btnSize.width+1);
        make.height.mas_equalTo(btnSize.height);
    }];
}
-(void)searchDevice:(UIButton*)btn
{
    DeviceSearchView *dsvc  = [[DeviceSearchView alloc]init];
    [self.navigationController pushViewController:dsvc animated:YES];
}
#pragma mark - Login Logout
-(void)loginBtnClick:(UIButton*)btn
{
    if(isLogin == false){
    if(_account.text.length > 0 && _password.text.length > 0)
    {
        [[TTXAccountManager shareManager] accountLoginServer:_server.text port:_port.text account:_account.text password:_password.text success:^(id  _Nullable responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"result"] intValue] == 0) {
                NSArray *vehicles = dict[@"vehicles"];
                NSLog(@"vehicles = %@",vehicles);
                NSMutableArray *arr = [NSMutableArray array];
                for (NSDictionary *dict1 in vehicles) {
                    VehicleInfoModel *model = [VehicleInfoModel yy_modelWithJSON:dict1];
                    EquipmentInfoModel *model1 = model.dl[0];
                    [[Singleton singleton].vicles setValue:model forKey:model1.id2];
                    [arr addObject:model];
                }
                isLogin = true;
                _login.selected = true;
                deviceList = arr;
                [displayList reloadData];
                [[TTXSDKPrepare prepare] setJsession:[TTXAccountManager shareManager].jsession];
                [[TTXSDKPrepare prepare] setServer:[TTXAccountManager shareManager].server lanIP:[TTXAccountManager shareManager].server port:6605];

                
            }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"error = %@",error);
        }];
        }
        
    }else{
        [[Singleton singleton].vicles removeAllObjects];
        [[TTXAccountManager shareManager] accountLogoutServer:_server.text port:_port.text success:^(bool success) {
            if (success) {
                NSLog(@"Logout success");
                isLogin = false;
                _login.selected = false;
            }
        } failure:^(NSError * _Nonnull error) {
            
        }];
        

    }
    
}
#pragma mark - Video
-(void)soundClick:(UIButton*)btn
{
    if (btn == _sound1) {
        [_video2 stopSound];
        [_video1 playSound];
    }else if (btn == _sound2){
        [_video1 stopSound];
        [_video2 playSound];
    }
}
-(void)startAndStop:(UIButton*)btn
{

    if (![_deviceIdno.text isEqualToString:currentIdno]) {
        currentIdno = _deviceIdno.text;
    
        [_video1 setViewInfo:currentIdno chn:0 mode:0];
        [_video1 setTitleInfo:currentIdno chName:@"CH1"];
        [_video2 setViewInfo:currentIdno chn:1 mode:1];
        [_video2 setTitleInfo:currentIdno chName:@"CH2"];
    }
   
    
    if (btn == _start) {
        [_video1 StartAV];
        [_video2 StartAV];
         [[iToast makeText:@"start preview..."] show];
    }else if (btn == _stop){
        [_video1 StopAV];
        [_video2 StopAV];
         [[iToast makeText:@"stop preview..."] show];
    }
}
-(void)recordClick:(UIButton*)btn
{
    if ([_video1 isViewing]) {
        if (![_video1 isRecording]) {
            [_video1 startRecord];
             [[iToast makeText:@"start record..."] show];
        }else {
            [_video1 stopRecord];
              [[iToast makeText:@"stop record..."] show];
        }
    }
    if([_video2 isViewing]){
        if(![_video2 isRecording]){
            [_video2 startRecord];
        }else{
            [_video2 stopRecord];
        }
    }
}
-(void)monitorClick:(UIButton *)btn
{
    if(btn == _startMt){
        [_video1 playSound];
        [_video2 playSound];
    }else if (btn == _stopMt){
        [_video1 stopSound];
        [_video2 stopSound];
    }
}
#pragma mark - Talkback
-(void)talkbackClick:(UIButton*)btn
{

    if(btn == _statTalk)
    {
        if(![_talkback isTalkback])
        {
//            [_video1 stopSound];
//            [_video2 stopSound];
           if([_talkback startTalkback:currentIdno])
            {
                [[iToast makeText:@"start talkback..."] show];
            }
        }
    }else if (btn == _stopTalk){
        if([_talkback isTalkback])
        {
            [_talkback stopTalkback];
               [[iToast makeText:@"stop talkback..."] show];
        }
    }
}

#pragma mark - Playback
-(void)searchPlayback:(UIButton*)btn
{
    PlaybackViewController *pbvc  = [[PlaybackViewController alloc]init];
    pbvc.currentVehicle = currentVehicle;
    [self.navigationController pushViewController:pbvc animated:YES];

    
}


-(void)textFieldChange:(UITextField*)textField
{

}

-(void)tapTextField:(UITapGestureRecognizer*)ges
{
    if(!isLogin)
    {
        [[iToast makeText:@"Please login"] show];
    }else{
        displayList.hidden = false;
        [self.view bringSubviewToFront:displayList];
    }
   
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _deviceIdno)
    {
    return NO;
    }
    return YES;
}


- (void) viewDidUnload {
    [super viewDidUnload];

}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    VehicleInfoModel *model = deviceList[indexPath.row];
//    EquipmentInfoModel *model1 = model.dl[0];
    cell.textLabel.text = model.nm;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return deviceList.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    VehicleInfoModel *model = deviceList[indexPath.row];
    EquipmentInfoModel *model1 = model.dl[0];
     _deviceIdno.text = model1.id2;
    currentIdno = _deviceIdno.text;
    currentVehicle = model;
    [_video1 setViewInfo:currentIdno chn:0 mode:0];
    [_video1 setTitleInfo:currentIdno chName:@"CH1"];
    [_video2 setViewInfo:currentIdno chn:1 mode:1];
    [_video2 setTitleInfo:currentIdno chName:@"CH2"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    for (UIView *next = touch.view; next; next = next.superview) {
        if ([next isKindOfClass:[UITableView class]]) {
            return NO;
        }
    }
    return YES;
}

@end
