//
//  GBBaseButton.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GBBaseButtonClickBlock)(UIButton *sender);

@interface GBBaseButton : UIButton

/**
 设置文本button
 @param title <#title description#>
 @param titleColor <#titleColor description#>
 @param font <#font description#>
 @param bgColor <#bgColor description#>
 @param controlEvents <#controlEvents description#>
 @param block <#block description#>
 @return <#return value description#>
 */
- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font bgColor:(UIColor *)bgColor forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/**
 设置图文button
 @param title <#title description#>
 @param image <#image description#>
 @param titleColor <#titleColor description#>
 @param font <#font description#>
 @param bgColor <#bgColor description#>
 @param controlEvents <#controlEvents description#>
 @param block <#block description#>
 @return <#return value description#>
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor font:(UIFont *)font bgColor:(UIColor *)bgColor forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/**
 设置图片button 没有高亮图片
 @param image <#image description#>
 @param controlEvents <#controlEvents description#>
 @param block <#block description#>
 @return <#return value description#>
 */
- (instancetype)initWithImage:(UIImage *)image forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/// 创建背景图片的按钮
/// @param backgroundImage <#backgroundImage description#>
/// @param controlEvents <#controlEvents description#>
/// @param block <#block description#>
- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/// 创建有高亮图片的button
- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/// 创建有不能点击的图片的button
- (instancetype)initWithImage:(UIImage *)image disabledImage:(UIImage *)disabledImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;

/**
 设置图片button 有高亮图片
 @param image <#image description#>
 @param highlightedImage <#highlightedImage description#>
 @param controlEvents <#controlEvents description#>
 @param block <#block description#>
 @return <#return value description#>
 */
- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block;


@end
