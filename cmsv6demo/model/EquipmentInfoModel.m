//
//  EquipmentInfoModel.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/9/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "EquipmentInfoModel.h"

@implementation EquipmentInfoModel
+(NSDictionary<NSString *,id> *)modelCustomPropertyMapper
{
    return @{@"id2":@"id",
             @"stFdt":@"st.fdt"
             };
}

-(BOOL)is1078
{
    if(_stFdt == 3)
    {
        return true;
    }
    return false;
}
@end
