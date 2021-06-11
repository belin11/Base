//
//  GBBaseTextView.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBBaseTextView : UITextView
/**
 初始化对象
 @param font 字体
 @param textColor 颜色
 @param returnKeyType 回车键类型
 @param delegate 代理
 @return 对象
 */
- (instancetype)initWithFont:(UIFont *)font
                   textColor:(UIColor *)textColor
               returnKeyType:(UIReturnKeyType)returnKeyType
                    delegate:(id<UITextViewDelegate>)delegate;

/**
 占位符
 */
@property (nonatomic, strong, readwrite) NSString *placeholder;

/**
 占位符颜色
 */
@property (nonatomic, strong, readwrite) UIColor *placeholderColor;

/**
 是否隐藏占位符
 */
@property (nonatomic, assign, readwrite) BOOL hidePlaceholder;

/**
 最大的文本长度
 */
@property (nonatomic, assign) NSInteger maxTextLength;

/**
 最小的文本长度控制
 */
@property (nonatomic, assign) NSInteger minTextLength;

/**
 是否成为第一响应者
 */
@property (nonatomic, assign, getter=isCanBecomeFirstResp) BOOL canBecomeFirstResp;
@end

NS_ASSUME_NONNULL_END
