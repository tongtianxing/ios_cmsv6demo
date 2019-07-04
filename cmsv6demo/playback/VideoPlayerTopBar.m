//
//  SRVideoTopBar.m
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import "VideoPlayerTopBar.h"


static const CGFloat kItemWH = 60;


@interface VideoPlayerTopBar ()

@property (nonatomic, strong) UIView *gradientView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UIButton *cameraBtn;

@end

@implementation VideoPlayerTopBar

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
        _gradientLayer.startPoint = CGPointMake(0.5, 1);
        _gradientLayer.endPoint = CGPointMake(0.5, 0);
    } else {
        [_gradientLayer removeFromSuperlayer];
    }
    _gradientLayer.frame = _gradientView.bounds;
    return _gradientLayer;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.showsTouchWhenHighlighted = YES;
        [_closeBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
      
    }
    return _closeBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _titleLabel;
}

- (UIButton *)cameraBtn {
    if (!_cameraBtn) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.showsTouchWhenHighlighted = YES;
        [_cameraBtn setImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _cameraBtn;
}

+ (instancetype)videoTopBar {
    return [[VideoPlayerTopBar alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        __weak typeof(self) weakSelf = self;
        [self addSubview:self.gradientView];
//        [_gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(0);
//        }];
        [self addSubview:self.closeBtn];
//        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.mas_equalTo(0);
//            make.width.height.mas_equalTo(kItemWH);
//        }];
        [self addSubview:self.cameraBtn];
//        [self.downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.right.mas_equalTo(0);
//            make.width.height.mas_equalTo(kItemWH);
//        }];
        [self addSubview:self.titleLabel];
        
     
        
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(weakSelf.closeBtn.mas_right);
//            make.right.mas_equalTo(weakSelf.downloadBtn.mas_left);
//            make.top.bottom.mas_equalTo(0);
//        }];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientView.frame = self.bounds;
     _gradientLayer.frame = _gradientView.bounds;
       self.closeBtn.frame = CGRectMake(0, 0, 60, 60);
        self.cameraBtn.frame = CGRectMake(CGRectGetMaxX(self.frame)-60, 0, 60, 60);
    self.titleLabel.frame = CGRectMake( CGRectGetMaxX(self.closeBtn.frame),0 ,CGRectGetMaxX(self.cameraBtn.frame) - CGRectGetMaxX(self.closeBtn.frame) , 60);
//    NSLog(@"self.titleLabel.frame = %@",NSStringFromCGRect(self.titleLabel.frame));
//    NSLog(@"self.downloadBtn.frame = %@",NSStringFromCGRect(self.downloadBtn.frame));
    [self.gradientView.layer addSublayer:self.gradientLayer];
}

- (void)closeBtnAction {
    if ([_delegate respondsToSelector:@selector(videoPlayerTopBarDidClickCloseBtn)]) {
        [_delegate videoPlayerTopBarDidClickCloseBtn];
    }
}

- (void)cameraBtnAction {
//    self.cameraBtn.userInteractionEnabled = NO;
    if ([_delegate respondsToSelector:@selector(videoPlayerTopBarDidClickCameraBtn)]) {
        [_delegate videoPlayerTopBarDidClickCameraBtn];
    }
}

- (void)setTitle:(NSString *)text {
       self.titleLabel.text = text;
    CGFloat fontSizeThatFits;
    [self.titleLabel.text sizeWithFont:self.titleLabel.font
                 minFontSize:14.0   //最小字体
              actualFontSize:&fontSizeThatFits
                    forWidth:self.titleLabel.bounds.size.width
               lineBreakMode:NSLineBreakByWordWrapping];
    
    self.titleLabel.font = [self.titleLabel.font fontWithSize:fontSizeThatFits];
 
}

@end
