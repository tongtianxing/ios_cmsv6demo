//
//  AccountManager.h
//  cmsv6demo
//
//  Created by tongtianxing on 2019/6/26.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTXAccountManager : NSObject
@property (nonatomic , assign) BOOL isLogin;
@property (nonatomic , copy) NSString *server;
@property (nonatomic , copy) NSString *port;
@property (nonatomic , copy) NSString *account;
@property (nonatomic , copy) NSString *password;
@property (nonatomic , copy) NSString *jsession;

+(TTXAccountManager *)shareManager;
/*
 * 登陆并返回车辆信息
 */
-(void)accountLoginServer:(NSString*)server port:(NSString *)port account:(NSString*)account password:(NSString*)password success:(void(^)(id  _Nullable responseObject))success failure:(void(^)(NSError * _Nonnull error))failure;

-(void)accountLogoutServer:(NSString *)server port:(NSString*)port success:(void(^)(bool))success failure:(void(^)(NSError * _Nonnull error))failure;
@end

NS_ASSUME_NONNULL_END
