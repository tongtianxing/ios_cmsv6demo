//
//  SRVideoBottomView.h
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoBottomBarDelegate <NSObject>

- (void)videoPlayerBottomBarDidClickPlayPauseBtn;
- (void)videoPlayerBottomBarDidTapSlider:(UISlider *)slider withTap:(UITapGestureRecognizer *)tap;
- (void)videoPlayerBottomBarChangingSlider:(UISlider *)slider;
- (void)videoPlayerBottomBarDidEndChangeSlider:(UISlider *)slider;
- (void)videoPlayerBottomBarDidClickChangeSoundBtn;
@end

@interface VideoPlayerBottomBar : UIView

@property (nonatomic, weak) id<VideoBottomBarDelegate> delegate;

@property (nonatomic, strong) UIButton *playPauseBtn;
@property (nonatomic, strong) UIButton *soundBtn;

@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UISlider *playingProgressSlider;
@property (nonatomic, strong) UIProgressView *bufferedProgressView;

@property (nonatomic, assign)BOOL isplaying; //设置停止开始btn状态   0 播放（pause图标） 1 停止(start图标)
@property (nonatomic, assign)BOOL issounding;// 0 播放 1 停止 声音


+ (instancetype)videoBottomBar;


@end
