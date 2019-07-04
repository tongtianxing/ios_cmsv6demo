//
//  VehicleInfo.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/8/31.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "VehicleInfoModel.h"
#import "EquipmentInfoModel.h"

@implementation VehicleInfoModel


+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    
    return @{@"id1":@"id"
             };
}

+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass
{
    return @{@"dl":[EquipmentInfoModel class]};
    
}


@end
