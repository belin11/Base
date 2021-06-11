//
//  GBBaseView.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseView.h"

@implementation GBBaseView

- (instancetype)initWithBgColor:(UIColor *)bgColor {
    
    return [self initWithBgColor:bgColor cornerRadius:0];
}

- (instancetype)initWithBgColor:(UIColor *)bgColor cornerRadius:(CGFloat)cornerRadius {
    
    if (self = [super init]) {
        
        self.backgroundColor = bgColor;
        self.layer.cornerRadius = cornerRadius;
    }
    return self;
}

@end
