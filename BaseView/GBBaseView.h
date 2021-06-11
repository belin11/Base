//
//  GBBaseView.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBBaseView : UIView

- (instancetype)initWithBgColor:(UIColor *)bgColor;

- (instancetype)initWithBgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
