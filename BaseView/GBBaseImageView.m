//
//  GBBaseImageView.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseImageView.h"

@implementation GBBaseImageView

- (instancetype)init {
    
    return [self initWithImageName:nil];
}
- (instancetype)initWithImageName:(NSString *)name {
    
    return [self initWithImageName:name handle:nil];
}

- (instancetype)initWithImageName:(NSString *)name handle:(GBImageViewClickBlock)block {
    
    return [self initWithImageName:name cornerRadius:0 handle:block];
}

- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius {
    
    return [self initWithImageName:name cornerRadius:cornerRadius handle:nil];
}

- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius handle:(GBImageViewClickBlock)block {
    
    return [self initWithImageName:name cornerRadius:cornerRadius borderWidth:0 borderColor:nil handle:block];
}

- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    return [self initWithImageName:name cornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor handle:nil];
}


- (instancetype)initWithImageName:(NSString *)name cornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor handle:(GBImageViewClickBlock)block {
    
    if (self = [super init]) {
        
        if (name.length) {
            
            self.image = [UIImage imageNamed:name];
        }
        
        if (cornerRadius) {
            
            self.layer.cornerRadius = cornerRadius;

        }
        
        if (borderWidth) {
            self.layer.borderWidth = borderWidth;
            self.layer.borderColor = borderColor.CGColor;
        }
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.masksToBounds = YES;
        if (block) {
            
            _clickBlock = block;
            [self addTapGesture];
        }
    }
    return self;
}
- (void)addTapGesture {

    self.enable = YES;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)setClickBlock:(GBImageViewClickBlock)clickBlock {
    
    _clickBlock = clickBlock;
    [self addTapGesture];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    UIImageView *imageView = (UIImageView *)tap.view;
    if (self.enable) {
        _clickBlock(imageView);
    } else {
        NSAssert(self.enable, @"不能点击，用户交互关闭");
    }
}

- (void)startAnimatingWithImageNames:(NSArray *)names duration:(CFTimeInterval)duration repeatCount:(NSInteger)repeatCount {
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSString *imageName in names) {
        
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    self.animationDuration = duration; // 动画时间
    self.animationImages = images.copy; // 执行动画的image数组
    self.animationRepeatCount = repeatCount; // 0 表示循环播放
    [self startAnimating]; // 开始动画
}

@end
