//
//  GBBaseImageView.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GBImageViewClickBlock)(UIImageView *sender);

@interface GBBaseImageView : UIImageView

/**
 是否可点击，默认为NO
 */
@property (nonatomic, assign) BOOL enable;

@property (nonatomic, copy) GBImageViewClickBlock clickBlock;

/**
 以图片名初始化对象
 @param name 图片名
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name;

/**
 以图片名 block初始对象
 @param name 图片名
 @param block 回调
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name handle:(GBImageViewClickBlock)block;


/**
 以图片名 圆角初始对象
 @param name 图片名
 @param cornerRadius 圆角
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius;


/**
 以图片名 圆角 回调初始对象
 @param name 图片名
 @param cornerRadius 圆角
 @param block 回调
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius handle:(GBImageViewClickBlock)block;

/**
 以图片名 圆角 边框宽度 边框颜色 初始对象
 @param name 图片名
 @param cornerRadius 圆角
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 以图片名 圆角 边框宽度 边框颜色 block 初始对象
 @param name 图片名
 @param cornerRadius 圆角
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param block 回调
 @return 对象
 */
- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor handle:(GBImageViewClickBlock)block;

/**
 图片动画
 @param names 图片名数组
 @param duration 时长
 @param repeatCount 重复次数 0表示无限
 */
- (void)startAnimatingWithImageNames:(NSArray *)names duration:(CFTimeInterval)duration repeatCount:(NSInteger)repeatCount;

@end
