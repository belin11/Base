//
//  GBResponseModel.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBTipsBtnListModel : NSObject

@property (nonatomic, strong) NSString *BtnStr;
@property (nonatomic, strong) NSString *JumpUrl;

@end

@interface GBResponseModel : NSObject

/// 状态码 1000.成功 1001.登录失败 1002.网络异常 999.签名错误
@property (nonatomic, assign) NSInteger errorCode;

/// 状态码说明
@property (nonatomic, copy) NSString *message;

/// 展示的数据
@property (nonatomic, copy) id data;

@property (nonatomic, strong) NSArray <GBTipsBtnListModel *> *TipsBtnList;

@end

NS_ASSUME_NONNULL_END
