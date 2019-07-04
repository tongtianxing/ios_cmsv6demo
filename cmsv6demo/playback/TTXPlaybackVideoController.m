//
//  TTXPlaybackVieoController.m
//  cmsv6
//
//  Created by tongtianxing on 2018/8/24.
//  Copyright © 2018年 babelstar. All rights reserved.
//

#import "TTXPlaybackVideoController.h"
#import "TTXPlaybackView.h"
#import "VideoPlayerTopBar.h"
#import "VideoPlayerBottomBar.h"
#import "iToast.h"
@interface TTXPlaybackVideoController ()<VideoTopBarBarDelegate,VideoBottomBarDelegate,PlaybcakViewDelegate>
{

    BOOL isDragingSlider;
    int currentPlayTime;
}
@property (nonatomic , strong)TTXPlaybackView *pbView;
@property (nonatomic , strong)VideoPlayerTopBar *topBar;
@property (nonatomic , strong)VideoPlayerBottomBar *bottomBar;
@property (nonatomic , strong)UIButton *replayBtn;
@property (nonatomic , strong)UILabel *rateLabel;
@end

@implementation TTXPlaybackVideoController



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    basicAnimation.fromValue = @(-M_PI_4);
    basicAnimation.toValue = @(0);
    basicAnimation.removedOnCompletion = YES;
    basicAnimation.fillMode = kCAFillModeForwards;
    [self.view.layer addAnimation:basicAnimation forKey:nil];
}
- (void)timingHideTopBottomBar {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTopBottomBar) object:nil];
    [self performSelector:@selector(hideTopBottomBar) withObject:nil afterDelay:5.0];
}
- (void)hideTopBottomBar {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationBeginsFromCurrentState:true];
    CGRect topBarRect = self.topBar.frame;
    topBarRect.origin.y = 0 - topBarRect.size.height;
    CGRect bottomBarRect = self.bottomBar.frame;
    bottomBarRect.origin.y = self.view.bounds.size.height;
    self.topBar.frame = topBarRect;
    self.bottomBar.frame = bottomBarRect;
    [UIView commitAnimations];
}
-(void)showTopBottomBar
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationBeginsFromCurrentState:true];
    CGRect topBarRect = self.topBar.frame;
    topBarRect.origin.y = 0;
    CGRect bottomBarRect = self.bottomBar.frame;
    bottomBarRect.origin.y = self.view.bounds.size.height - bottomBarRect.size.height;
    self.topBar.frame = topBarRect;
    self.bottomBar.frame = bottomBarRect;
    [UIView commitAnimations];
    
    [self timingHideTopBottomBar];
}

-(UIButton *)replayBtn
{
    if (_replayBtn == nil) {
        _replayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _replayBtn.frame = CGRectMake(0, 0, 100, 100);
        _replayBtn.center = self.view.center;
        _replayBtn.hidden = true;
        [_replayBtn setImage:[UIImage imageNamed:@"images/video/replay.png"] forState:UIControlStateNormal];
        [_replayBtn addTarget:self action:@selector(replayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_replayBtn];
    }
    return _replayBtn;
}

-(VideoPlayerTopBar *)topBar
{
    if (_topBar == nil) {
        _topBar = [VideoPlayerTopBar videoTopBar];
        _topBar.delegate = self;
        [self.view addSubview:_topBar];
    }
    return _topBar;
}
-(VideoPlayerBottomBar *)bottomBar
{
    if (_bottomBar == nil) {
        _bottomBar = [VideoPlayerBottomBar videoBottomBar];
        _bottomBar.delegate = self;
//        _bottomBar.userInteractionEnabled = NO;
        [self.view addSubview:_bottomBar];
    }
    return _bottomBar;
}
-(TTXPlaybackView *)pbView
{
    if (_pbView == nil) {
        _pbView = [[TTXPlaybackView alloc]init];
        _pbView.delegate = self;
           [self.view addSubview:_pbView];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOne:)];
        [_pbView addGestureRecognizer:tapGes];
    }
    return _pbView;
}
-(UILabel *)rateLabel
{
    if (_rateLabel == nil) {
        _rateLabel = [[UILabel alloc]init];
        _rateLabel.frame =CGRectMake(20, 60, 100, 25);
        _rateLabel.backgroundColor = [UIColor clearColor];
        _rateLabel.font = [UIFont systemFontOfSize:12];
        _rateLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_rateLabel];
    }
    return _rateLabel;
}
-(void)tapOne:(UITapGestureRecognizer*)ges
{
    if (self.bottomBar.frame.origin.y >= self.view.bounds.size.height && self.topBar.frame.origin.y <= 0) { //隐藏
         [self showTopBottomBar];
    }else{
           [self hideTopBottomBar];
    }
}
-(void)setRateText:(int)rate
{
    if (rate == 0) {
        self.rateLabel.hidden = true;
    }else{
        self.rateLabel.text = [NSString stringWithFormat:@"%dKB/S",rate];
        self.rateLabel.hidden = false;
    }
    
}


-(void)replayBtnClick:(UIButton*)btn
{
    btn.hidden = true;
    [self.pbView startVod:_selectedModel];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始化设置
    self.bottomBar.currentTimeLabel.text = [self secondSwitchHourString:(int)_selectedModel.beginTime];
    self.bottomBar.totalTimeLabel.text = [self secondSwitchHourString:(int)_selectedModel.endTime];
    
    NSString *date = [NSString stringWithFormat:@"%04zd-%02zd-%02zd",_selectedModel.year,_selectedModel.month,_selectedModel.day];
    NSString *title = [NSString stringWithFormat:@"%@ CH%d %@ %@ - %@",_selectedModel.devIdno,(int)_selectedModel.chn+1,date,[self getTimeStr:_selectedModel.beginTime],[self getTimeStr:_selectedModel.endTime]];
    [self.topBar setTitle:title];
    [self.pbView startVod:_selectedModel];
     [self.bottomBar setIsplaying:false];//
    [self.bottomBar setIssounding:false];
    [self timingHideTopBottomBar];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.pbView stopVod];
    [self.pbView stopSound];
}

/*
 * 将秒转换成时间
 */
- (NSString*)secondSwitchHourString:(int)second {
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", second/3600, second%3600/60, second%60];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomBar.currentTimeLabel.text =  @"00:00:00";
    self.bottomBar.totalTimeLabel.text =  @"00:00:00";
}
-(void)viewDidLayoutSubviews
{
   self.pbView.frame = self.view.bounds;
    self.topBar.frame = CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 60);
    self.bottomBar.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 60, CGRectGetWidth(self.view.bounds), 60);
    [self.view bringSubviewToFront:self.topBar];
     [self.view bringSubviewToFront:self.bottomBar];
}
-(void)dealloc
{
    NSLog(@"TTXPlaybackVideoController delloc");
}

#pragma mark - VideoTopBarBarDelegate
-(void)videoPlayerTopBarDidClickCloseBtn
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)videoPlayerTopBarDidClickCameraBtn
{
    if ([self.pbView isViewing]) {
        if([self.pbView savePngFile]){
            [[iToast makeText:NSLocalizedString(@"preview_capture_save", "")] show];
        }
    }
     [self timingHideTopBottomBar];
}
#pragma mark - VideoBottomBarBarDelegate
//点击开始停止
- (void)videoPlayerBottomBarDidClickPlayPauseBtn
{
    BOOL isplaying = [self.bottomBar isplaying];
    [self.pbView pause:!isplaying];
    [self.bottomBar setIsplaying:!isplaying];
    if ((!isplaying)  == 0){//pasue图标 对应正在播放
        [self.pbView playSound];
    }else if((!isplaying) == 1){ //start图标 对应暂停状态
        [self.pbView setPlayTime:currentPlayTime];
        [self.pbView stopSound];
        
    }
    
  
     [self timingHideTopBottomBar];
}
//点击播放静音
- (void)videoPlayerBottomBarDidClickChangeSoundBtn
{
    if ([self.pbView isViewing]) {
    BOOL issound = [self.bottomBar issounding];
    if (issound == 0) {
        [self.pbView stopSound];
    }else{
        [self.pbView playSound];
    }
    [self.bottomBar setIssounding:!issound];
    }
     [self timingHideTopBottomBar];
}
//点击slider
- (void)videoPlayerBottomBarDidTapSlider:(UISlider *)slider withTap:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:slider];
    float value = (touchPoint.x / slider.frame.size.width) * slider.maximumValue;//
    
    int timeTotal = (int)_selectedModel.endTime - (int)_selectedModel.beginTime;
    int tapPlay = timeTotal * value;
    self.bottomBar.currentTimeLabel.text = [self secondSwitchHourString:((int)_selectedModel.beginTime + tapPlay)];    
    
    [self.pbView setPlayTime:tapPlay+1];
      [self timingHideTopBottomBar];
}
- (void)videoPlayerBottomBarChangingSlider:(UISlider *)slider
{
    isDragingSlider = YES;
    float value = slider.value;
     int timeTotal = (int)_selectedModel.endTime - (int)_selectedModel.beginTime;
    self.bottomBar.currentTimeLabel.text = [self secondSwitchHourString:((int)_selectedModel.beginTime + (int)(timeTotal * value))];
    [self timingHideTopBottomBar];
}
- (void)videoPlayerBottomBarDidEndChangeSlider:(UISlider *)slider
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
          isDragingSlider = NO;
    });
    float value = slider.value;
    int timeTotal = (int)_selectedModel.endTime - (int)_selectedModel.beginTime;
    int chanagePlay = timeTotal * value;
    self.bottomBar.currentTimeLabel.text = [self secondSwitchHourString:((int)_selectedModel.beginTime + chanagePlay)];
    [self.pbView setPlayTime:chanagePlay+1];
}

#pragma mark - PlaybackViewDelegate
-(void)onPlayBack:(TTXPlaybackView *)playback rate:(int)realRate
{
    [self setRateText:realRate];
}
-(void)onBeginPlay:(TTXPlaybackView *)playback
{
    if (![self.bottomBar issounding] && ![self.pbView isSounding] ) {
        [self.pbView playSound];
    }
}
-(void)onEndPlay:(TTXPlaybackView *)playback
{
    [self.pbView stopVod];
}
-(void)onUpdatePlay:(TTXPlaybackView *)playback downSecond:(int)down playSecond:(int)play downFinish:(BOOL)finish
{
    NSLog(@"finish = %d",finish);
    NSLog(@"down = %d",down);
    NSLog(@"play = %d",play);
    currentPlayTime = play;
    self.bottomBar.currentTimeLabel.text = [self secondSwitchHourString:(int)(_selectedModel.beginTime + play)];
    
    int timeTotal = (int)_selectedModel.endTime - (int)_selectedModel.beginTime;
    //生成随机浮点
    int x = arc4random() % 10;
    int y = arc4random() % 10;
    NSString *str = [NSString stringWithFormat:@"0.%d%d",x,y];
    float  f = [str floatValue];
    //下载进度
       float progress = (float)down / timeTotal;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomBar.bufferedProgressView setProgress:progress animated:NO];
    });
    //播放进度
    float value = (float)play / timeTotal;
    //拖拽时不跳动
    if (!isDragingSlider) {
    [self.bottomBar.playingProgressSlider setValue:value];
    }
    
    if (finish) {
        [self setRateText:0];
    }
    //结束
    if (_selectedModel.endTime == (_selectedModel.beginTime + play)) {
        [self.pbView stopVod];
        self.replayBtn.hidden = false;
    }
}

#pragma mark - 横屏实现
- (BOOL)shouldAutorotate

{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations

{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation

{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                       
-(NSString *)getTimeStr:(NSInteger)time
{
        NSInteger hour = time / 3600;
        NSInteger minute = (time - 3600 * hour) / 60;
        NSInteger second = time - 3600 * hour - 60 * minute;
        return [NSString stringWithFormat:@"%02zd:%02zd:%02zd",hour,minute,second];
}

@end
