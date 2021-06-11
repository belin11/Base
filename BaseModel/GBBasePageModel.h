//
//  GBBasePageModel.h
//  Dmallovo
//
//  Created by Mac on 2020/3/9.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GBShareInfoModel;
@interface GBBasePageModel : NSObject

/// 第几页
@property (nonatomic, assign) NSInteger pageIndex;

/// 单页设置个数
@property (nonatomic, assign) NSInteger pageSize;

///  总共多少页
@property (nonatomic, assign) NSInteger pageTotal;

/// 总个数
@property (nonatomic, assign) NSInteger pageCount;

/// 分享类型
@property (nonatomic, strong) GBShareInfoModel *ShareInfo;

/// 列表模型
@property (nonatomic, strong) id List;
@end

NS_ASSUME_NONNULL_END
