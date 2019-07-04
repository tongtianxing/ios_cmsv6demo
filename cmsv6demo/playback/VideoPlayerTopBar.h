//
//  SRVideoTopBar.h
//  SRVideoPlayer
//
//  Created by https://github.com/guowilling on 17/1/6.
//  Copyright © 2017年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoTopBarBarDelegate <NSObject>

- (void)videoPlayerTopBarDidClickCloseBtn;

- (void)videoPlayerTopBarDidClickCameraBtn;

@end

@interface VideoPlayerTopBar : UIView

@property (nonatomic, weak) id<VideoTopBarBarDelegate> delegate;

+ (instancetype)videoTopBar;

- (void)setTitle:(NSString *)text;

@end
