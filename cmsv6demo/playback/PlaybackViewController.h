//
//  PlaybackViewController.h
//  cmsv6demo
//
//  Created by tongtianxing on 2018/9/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VehicleInfoModel;
@interface PlaybackViewController : UIViewController

//@property (nonatomic,strong)NSArray *deviceList;

@property (nonatomic,strong)VehicleInfoModel *currentVehicle;

@end
