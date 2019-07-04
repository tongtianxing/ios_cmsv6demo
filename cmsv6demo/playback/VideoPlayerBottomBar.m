//
//  SRVideoBottomView.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/5.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "VideoPlayerBottomBar.h"
//#import "Masonry.h"

static const CGFloat kItemWH = 60;

@interface VideoPlayerBottomBar ()

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation VideoPlayerBottomBar

- (UIView *)gradientView {
    if (!_gradientView) {
        _gradientView = [[UIView alloc] init];
        _gradientView.backgroundColor = [UIColor clearColor];
    }
    return _gradientView;
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
    } else {
        [_gradientLayer removeFromSuperlayer];
    }
    _gradientLayer.frame = _gradientView.bounds;
    return _gradientLayer;
}

- (UIButton *)playPauseBtn {
    if (!_playPauseBtn) {
        _playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playPauseBtn.showsTouchWhenHighlighted = YES;
        [_playPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_playPauseBtn setImage:[UIImage imageNamed:@"start"] forState:UIControlStateSelected];
        [_playPauseBtn addTarget:self action:@selector(playPauseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playPauseBtn;
}

- (UIButton *)soundBtn {
    if (!_soundBtn) {
        _soundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _soundBtn.showsTouchWhenHighlighted = YES;
        [_soundBtn setImage:[UIImage imageNamed:@"voiced"] forState:UIControlStateNormal];
          [_soundBtn setImage:[UIImage imageNamed:@"mute"] forState:UIControlStateSelected];
        [_soundBtn addTarget:self action:@selector(soundBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _soundBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
        _currentTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _currentTimeLabel;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc]init];
        _totalTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _totalTimeLabel.textColor = [UIColor whiteColor];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _totalTimeLabel;
}

- (UISlider *)playingProgressSlider {
    if (!_playingProgressSlider) {
        _playingProgressSlider = [[UISlider alloc] init];
        _playingProgressSlider.minimumTrackTintColor = [UIColor whiteColor];
        _playingProgressSlider.maximumTrackTintColor = [UIColor colorWithWhite:0 alpha:0.5];
        [_playingProgressSlider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
        [_playingProgressSlider addTarget:self action:@selector(sliderChanging:) forControlEvents:UIControlEventValueChanged];
        [_playingProgressSlider addTarget:self action:@selector(sliderDidEndChange:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapAction:)];
        [_playingProgressSlider addGestureRecognizer:tap];
    }
    return _playingProgressSlider;
}

- (UIProgressView *)bufferedProgressView {
    if (!_bufferedProgressView) {
        _bufferedProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _bufferedProgressView.progressTintColor = [UIColor colorWithWhite:1 alpha:0.5];
        _bufferedProgressView.trackTintColor = [UIColor clearColor];
        _bufferedProgressView.layer.cornerRadius = 0.5;
        _bufferedProgressView.layer.masksToBounds = YES;
    }
    return _bufferedProgressView;
}

+ (instancetype)videoBottomBar {
    return [[VideoPlayerBottomBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        __weak typeof(self) weakSelf = self;
        
        [self addSubview:self.gradientView];
 
//
//        [_gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(0);
//        }];
        
        [self addSubview:self.playPauseBtn];
        
//        [self.playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(0);
//            make.width.height.mas_equalTo(kItemWH);
//        }];
      
        
        [self addSubview:self.currentTimeLabel];
//        [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.playPauseBtn.mas_right);
//            make.top.mas_equalTo(0);
//            make.width.mas_equalTo(55);
//            make.height.mas_equalTo(kItemWH);
//        }];

        
        [self addSubview:self.soundBtn];
//        [self.changeScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.mas_equalTo(0);
//            make.width.height.mas_equalTo(kItemWH);
//        }];
    
        
        
        
        [self addSubview:self.totalTimeLabel];
//        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.right.mas_equalTo(weakSelf.changeScreenBtn.mas_left);
//            make.width.mas_equalTo(55);
//            make.height.mas_equalTo(kItemWH);
//        }];
       
        
        
        [self addSubview:self.playingProgressSlider];
//        [self.playingProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.mas_equalTo(0);
//            make.left.mas_equalTo(weakSelf.currentTimeLabel.mas_right);
//            make.right.mas_equalTo(weakSelf.totalTimeLabel.mas_left);
//        }];

        [self addSubview:self.bufferedProgressView];
//        [self.bufferedProgressView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.currentTimeLabel.mas_right);
//            make.right.mas_equalTo(weakSelf.totalTimeLabel.mas_left);
//            make.centerY.mas_equalTo(weakSelf.playingProgressSlider.mas_centerY).offset(1);
//            make.height.mas_equalTo(1);
//        }];

        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
        _gradientView.frame = self.bounds;
      _playPauseBtn.frame = CGRectMake(0, 0, kItemWH, kItemWH);

    _currentTimeLabel.frame = CGRectMake(CGRectGetMaxX(_playPauseBtn.frame), 0, 55, kItemWH);

        _soundBtn.frame = CGRectMake(CGRectGetMaxX(self.bounds)-kItemWH, 0, kItemWH, kItemWH);

     _totalTimeLabel.frame = CGRectMake(CGRectGetMinX(_soundBtn.frame)-55, 0, 55, kItemWH);

    _playingProgressSlider.frame = CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame) - 1, 0,CGRectGetMinX(_totalTimeLabel.frame) - CGRectGetMaxX(_currentTimeLabel.frame) - 1, CGRectGetHeight(self.bounds));

    _bufferedProgressView.frame = CGRectMake(CGRectGetMaxX(_currentTimeLabel.frame), _playingProgressSlider.center.y-1 ,CGRectGetMinX(_totalTimeLabel.frame) - CGRectGetMaxX(_currentTimeLabel.frame)-1 , 1);

    
    
    [self.gradientView.layer addSublayer:self.gradientLayer];
}

- (void)playPauseBtnAction {
    if ([_delegate respondsToSelector:@selector(videoPlayerBottomBarDidClickPlayPauseBtn)]) {
        [_delegate videoPlayerBottomBarDidClickPlayPauseBtn];
    }
}

- (void)soundBtnAction {
    if ([_delegate respondsToSelector:@selector(videoPlayerBottomBarDidClickChangeSoundBtn)]) {
        [_delegate videoPlayerBottomBarDidClickChangeSoundBtn];
    }
}

- (void)sliderChanging:(UISlider *)sender {
    if ([_delegate respondsToSelector:@selector(videoPlayerBottomBarChangingSlider:)]) {
        [_delegate videoPlayerBottomBarChangingSlider:sender];
    }
}

- (void)sliderDidEndChange:(UISlider *)sender {
    if ([_delegate respondsToSelector:@selector(videoPlayerBottomBarDidEndChangeSlider:)]) {
        [_delegate videoPlayerBottomBarDidEndChangeSlider:sender];
    }
}

- (void)sliderTapAction:(UITapGestureRecognizer *)tap {
    if ([_delegate respondsToSelector:@selector(videoPlayerBottomBarDidTapSlider:withTap:)]) {
        [_delegate videoPlayerBottomBarDidTapSlider:self.playingProgressSlider withTap:tap];
    }
}

-(void)setIsplaying:(BOOL)isplaying
{
    self.playPauseBtn.selected = isplaying;
}
-(BOOL)isplaying
{
    return self.playPauseBtn.selected;
}
-(void)setIssounding:(BOOL)issounding
{
    self.soundBtn.selected = issounding;
}
-(BOOL)issounding
{
    return self.soundBtn.selected;
}

@end
