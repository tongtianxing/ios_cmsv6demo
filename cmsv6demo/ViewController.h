//
//  ViewController.h
//  cmsv6demo
//
//  Created by Apple on 13-10-1.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    BOOL isLoading;
    UILabel* videoRate;
    UIImageView *videoImg;
    long realHandle;
    NSTimer *timerPlay;
    NSMutableData *videoBuffer;
    int videoWidth;
    int videoHeight;
    int videoRgb565Length;
}
@end
