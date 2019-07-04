//
//  Singleton.h
//  cmsv6demo
//
//  Created by tongtianxing on 2018/12/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject

+(Singleton *)singleton;
-(NSMutableDictionary *)vicles;


@end

NS_ASSUME_NONNULL_END
