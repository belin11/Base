//
//  GBBaseLabel.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseLabel.h"

@implementation GBBaseLabel

- (GBBaseLabel *(^)(UIColor *))gb_textColor {
    
    GBBaseLabel *(^v)(UIColor *) =  ^ (UIColor *color) {

        self.textColor = color;
        return self;
    };
    return v;
}

- (GBBaseLabel *(^)(NSTextAlignment))gb_textAlignment {
    
    return ^(NSTextAlignment align) {
        
        self.textAlignment = align;
        return self;
    };
}

- (GBBaseLabel *(^)(UIFont *))gb_font {
    
    return ^ (UIFont *f) {
        self.font = f;
        return self;
    };
}

- (GBBaseLabel *(^)(UIColor *))gb_backgroundColor {
    
    return ^ (UIColor *bgColor) {
        
        self.backgroundColor = bgColor;
        return self;
    };
}

- (GBBaseLabel *(^)(NSInteger))gb_numberOfLines {
    
    return ^(NSInteger Lines) {
        
        self.numberOfLines = Lines;
        return self;
    };
}

- (GBBaseLabel *(^)(NSString *))gb_text {
    
    return ^ (NSString *t) {
      
        self.text = t;
        return self;
    };
}




- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text {
    
    return [self initWithFrame:CGRectZero textColor:textColor textAlignment:NSTextAlignmentLeft font:font backgroundColor:[UIColor clearColor] numberOfLines:1 text:text];
}

- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text  {
    
    return [self initWithFrame:CGRectZero textColor:textColor textAlignment:textAlignment font:font backgroundColor:[UIColor clearColor] numberOfLines:1 text:text];
}


- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines text:(NSString *)text {
    
    return [self initWithFrame:CGRectZero textColor:textColor textAlignment:NSTextAlignmentLeft font:font backgroundColor:[UIColor clearColor] numberOfLines:numberOfLines text:text];
}

- (instancetype)initWithTextColor:(UIColor *)textColor font:(UIFont *)font numberOfLines:(NSInteger)numberOfLines textAlignment:(NSTextAlignment)textAlignment text:(NSString *)text {
    
    return [self initWithFrame:CGRectZero textColor:textColor textAlignment:textAlignment font:font backgroundColor:[UIColor clearColor] numberOfLines:numberOfLines text:text];

}

- (instancetype)initWithFrame:(CGRect)frame textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor numberOfLines:(NSInteger)numberOfLines text:(NSString *)text {
    
    if (self = [super initWithFrame:frame]) {
        
        self.frame = frame;
        self.text = text;
        self.textColor = textColor;
        self.textAlignment = textAlignment;
        self.font = font;
        if (backgroundColor) {
            
            self.backgroundColor = backgroundColor;

        }
        self.numberOfLines = numberOfLines;
    }
    
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size extraWidth:(CGFloat)extraWidth extraHeigth:(CGFloat)extraHeight {
    CGSize fitSize = [super sizeThatFits:size];
    
    //补偿
    //    fitSize.width = size.width;
    if (extraWidth > 0) {
        
        fitSize.width += extraWidth;
    }
    
    if (extraHeight > 0) {
        
        fitSize.height += extraHeight;
    }
    
    return fitSize;
}


@end
