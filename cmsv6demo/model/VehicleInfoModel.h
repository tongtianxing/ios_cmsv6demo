//
//  VehicleInfo.h
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

@interface VehicleInfoModel : NSObject<YYModel>

@property NSInteger id1;
@property NSString *nm;
@property NSInteger ic;
@property NSInteger pid;
@property NSArray *dl;
//@property (nonatomic , copy)NSString* io;
//@property (nonatomic , assign)int cc;
//@property (nonatomic , copy)NSString *cn;
//@property (nonatomic , assign)int tc;
//@property (nonatomic , copy)NSString *tn;

@end
//id    number    车辆ID
//nm    string    车牌号
//ic    number    车辆图标
//pid    number    所属公司或者车队
//dl    Array    设备列表
//以下是设备信息


