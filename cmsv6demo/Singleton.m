//
//  Singleton.m
//  cmsv6demo
//
//  Created by tongtianxing on 2018/12/3.
//  Copyright © 2018年 Apple. All rights reserved.
//

#import "Singleton.h"


@interface Singleton ()

@property (nonatomic , strong)NSMutableDictionary *vicles;

@end


@implementation Singleton

+(Singleton *)singleton
{
    static Singleton *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton == nil) {
            singleton = [Singleton new];
            singleton.vicles = [[NSMutableDictionary alloc]init];
        }
    });
    return singleton;
}
-(NSMutableDictionary *)vicles
{
    return _vicles;
}


@end
