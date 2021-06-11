//
//  GBBaseController.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JhtFloatingBall/JhtFloatingBall.h>
#import "GBSuspensionBox.h"

NS_ASSUME_NONNULL_BEGIN
@class GBShareInfoModel;
@interface GBBaseViewController : UIViewController <JhtFloatingBallDelegate>

/// 状态栏是否是白色
@property (nonatomic, assign) BOOL statusBarStyleLight;

/// 导航栏是否是不透明的，默认是YES
@property (nonatomic, assign) BOOL navigationBarOpaque;

/// 是否隐藏导航栏底线，默认是NO
@property (nonatomic, assign) BOOL showNavigationBarBottomLine;

/// 导航栏背景色
@property (nonatomic, assign) CGFloat navigationBarAlpha;

/// 是否隐藏返回按钮
@property (nonatomic, assign) BOOL hiddenBackItem;

@property (nonatomic, assign) CGRect viewFrame;

@property (nonatomic, strong) GBSuspensionBox *box;

- (void)loadIsShowGetRedPacketData:(NSString *)imageName isPopLastController:(BOOL)yesOrNo; 

- (void)loadIsShowGetRedPacketData:(NSString *)imageName;

/// 设置导航栏
- (void)setupNavigationBar;

///  退出当前控制器
- (void)popController;

- (void)loadBuriedPointWithPositionType:(NSInteger)PositionType ClassId:(NSString *)ClassId  ClassName:(NSString *)ClassName SalesArea:(NSInteger)SalesArea  RelationId:(NSInteger)RelationId RelationName:(NSString *)RelationName UniqueId:(NSString *)UniqueId;

- (void)requestBuryingPointsWithType:(NSInteger)type page:(NSInteger)page;

- (void)gotoShareWithShareInfo:(GBShareInfoModel *)shareInfo success:(void(^)(void))success;

- (void)saveImageToPhoto:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
