//
//  AccountManager.m
//  cmsv6demo
//
//  Created by tongtianxing on 2019/6/26.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "TTXAccountManager.h"
#import "AFNetworking.h"
@interface TTXAccountManager ()
{
    AFHTTPSessionManager *manager;

}
@end

@implementation TTXAccountManager
static TTXAccountManager *m = nil;
+(TTXAccountManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (m == nil) {
            m = [[TTXAccountManager alloc] init];
            m->manager = [AFHTTPSessionManager manager];
            m->manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        }
    });
    return m;
}
//-(void)updateServer
//{
//    if (_jsession != nil) {
//        NETMEDIA_SetSession([_jsession UTF8String]);
//    }
//    NETMEDIA_SetDirSvr([_server UTF8String], [_server UTF8String], 6605, 0);
//}




-(void)accountLoginServer:(NSString*)server port:(NSString *)port account:(NSString*)account password:(NSString*)password success:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nonnull error))failure
{
    NSString *serverAddr = nil;
    if (port.length > 0) {
        serverAddr =  [NSString stringWithFormat:@"http://%@:%@/",server,port];
    }else{
        serverAddr =  [NSString stringWithFormat:@"http://%@/",server];
    }
    
    NSMutableString *str = [[NSMutableString alloc] initWithString:serverAddr];
          [str appendString:@"StandardApiAction_login.action?account="];
    [str appendString:account];
    [str appendString: @"&password="];
    [str appendString:password];
    
    __weak typeof(self) weakSelf = self;
    [manager POST:str parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = responseObject;
        int result = [dict[@"result"] intValue];
        if(result == 0)
        {
            weakSelf.server = server;
            weakSelf.port   = port;
            weakSelf.account= account;
            weakSelf.password=password;
            weakSelf.jsession=dict[@"jsession"];
            weakSelf.isLogin =true;

            [self getUserVehicleSuccess:^(id  _Nullable responseObject) {
                success(responseObject);
            } failure:^(NSError * _Nonnull error) {
                 failure(error);
            }];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


-(void)accountLogoutServer:(NSString *)server port:(NSString*)port success:(void(^)(bool))success failure:(void(^)(NSError * _Nonnull error))failure
{
//    NSDictionary *parameters = @{@"jsession":_jsession};
    NSString *url;
    if (port.length != 0) {
        url = [NSString stringWithFormat:@"http://%@:%@/StandardApiAction_logout.action?jsession=%@",server,port,_jsession];
    }else{
        url = [NSString stringWithFormat:@"http://%@/StandardApiAction_logout.action?jsession=%@",server,_jsession];
    }
     __weak typeof(self) weakSelf = self;
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       weakSelf.isLogin = NO;
        weakSelf.jsession=@"";
        weakSelf.password=@"";
        weakSelf.server=@"";
        weakSelf.port=@"";
        weakSelf.account=@"";
        success(YES);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}







-(void)getUserVehicleSuccess:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nonnull error))failure
{
    NSString *url;
    if (_port.length == 0 ) {
        url  =  [NSString stringWithFormat:@"http://%@/StandardApiAction_queryUserVehicle.action?jsession=%@",_server,_jsession];
    }else{
        url  =  [NSString stringWithFormat:@"http://%@:%@/StandardApiAction_queryUserVehicle.action?jsession=%@",_server,_port,_jsession];
    }
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


@end
