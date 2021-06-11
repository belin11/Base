//
//  GBBaseLabel.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBBaseLabel : UILabel

//链式写法

- (GBBaseLabel *(^)(UIColor *color))gb_textColor;
- (GBBaseLabel *(^)(NSTextAlignment align))gb_textAlignment;
- (GBBaseLabel *(^)(UIFont *font))gb_font;
- (GBBaseLabel *(^)(UIColor *color))gb_backgroundColor;
- (GBBaseLabel *(^)(NSInteger numberOfLines))gb_numberOfLines;
- (GBBaseLabel *(^)(NSString *text))gb_text;



- (instancetype)initWithFrame:(CGRect)frame
                    textColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
                         font:(UIFont *)font
              backgroundColor:(UIColor *)backgroundColor
                numberOfLines:(NSInteger)numberOfLines
                         text:(NSString *)text;


/**
 可设numberOfLines和textAlignment
 @param textColor <#textColor description#>
 @param font <#font description#>
 @param numberOfLines <#numberOfLines description#>
 @param textAlignment <#textAlignment description#>
 @param text <#text description#>
 @return <#return value description#>
 */
- (instancetype)initWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                    numberOfLines:(NSInteger)numberOfLines
                    textAlignment:(NSTextAlignment)textAlignment
                             text:(NSString *)text;

/**
 可设numberOfLines
 @param textColor <#textColor description#>
 @param font <#font description#>
 @param numberOfLines <#numberOfLines description#>
 @param text <#text description#>
 @return <#return value description#>
 */
- (instancetype)initWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                    numberOfLines:(NSInteger)numberOfLines
                             text:(NSString *)text;

/**
 可设textAlignment
 @param textColor <#textColor description#>
 @param font <#font description#>
 @param textAlignment <#textAlignment description#>
 @param text <#text description#>
 @return <#return value description#>
 */
- (instancetype)initWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                    textAlignment:(NSTextAlignment)textAlignment
                             text:(NSString *)text;

/**
 最基本的
 @param textColor <#textColor description#>
 @param font <#font description#>
 @param text <#text description#>
 @return <#return value description#>
 */
- (instancetype)initWithTextColor:(UIColor *)textColor
                             font:(UIFont *)font
                             text:(NSString *)text;

/**
 获取label尺寸
 @param size 可设原始尺寸大小
 @param extraWidth 补偿高度
 @param extraHeight 补偿宽度
 @return 修改后的尺寸
 */
- (CGSize)sizeThatFits:(CGSize)size
            extraWidth:(CGFloat)extraWidth
           extraHeigth:(CGFloat)extraHeight;

@end
