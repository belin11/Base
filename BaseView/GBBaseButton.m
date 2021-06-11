//
//  GBBaseButton.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseButton.h"

@interface GBBaseButton ()
@property (nonatomic, copy) GBBaseButtonClickBlock clickBlock;
@end

@implementation GBBaseButton

- (instancetype)initWithImage:(UIImage *)image forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    
    return [self initWithTitle:nil image:image titleColor:nil font:nil bgColor:nil forControlEvents:controlEvents handler:block];
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    
    if (self = [super init]) {
        
        _clickBlock = block;
      
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self sizeToFit];
        [self addTarget:self action:@selector(clickButton:) forControlEvents:controlEvents];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    if (self = [super init]) {
        
        _clickBlock = block;
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:selectedImage forState:UIControlStateSelected];
        [self sizeToFit];
        [self addTarget:self action:@selector(clickButton:) forControlEvents:controlEvents];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image disabledImage:(UIImage *)disabledImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    if (self = [super init]) {
        
        _clickBlock = block;
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:disabledImage forState:UIControlStateDisabled];
        [self sizeToFit];
        [self addTarget:self action:@selector(clickButton:) forControlEvents:controlEvents];
    }
    return self;
}

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    if (self = [super init]) {
        
        _clickBlock = block;
        
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self sizeToFit];
        [self addTarget:self action:@selector(clickButton:) forControlEvents:controlEvents];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font bgColor:(UIColor *)bgColor forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    
    return [self initWithTitle:title image:nil titleColor:titleColor font:font bgColor:bgColor forControlEvents:controlEvents handler:block];
}


- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image titleColor:(UIColor *)titleColor font:(UIFont *)font bgColor:(UIColor *)bgColor forControlEvents:(UIControlEvents)controlEvents handler:(GBBaseButtonClickBlock)block {
    
    if (self = [super init]) {
        
        _clickBlock = block;
        if (title) {
            
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitleColor:titleColor forState:UIControlStateNormal];
            [self.titleLabel setFont:font];
        }
        
        if (image) {
            
            [self setImage:image forState:UIControlStateNormal];
        }
        
        [self sizeToFit];
        if (bgColor) {//设置背景
            self.backgroundColor = bgColor;
        }
        [self addTarget:self action:@selector(clickButton:) forControlEvents:controlEvents];
    }
    
    return self;
}

- (void)clickButton:(GBBaseButton *)button {
    
    if (_clickBlock) {
        
        _clickBlock(button);
    }
}

@end
