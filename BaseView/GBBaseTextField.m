//
//  GBTextField.m
//  Dmallovo
//
//  Created by Malilai on 2020/6/4.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseTextField.h"

@implementation GBBaseTextField

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += _leftView_offset_x; //像右边偏15
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, _text_offset_x, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, _text_offset_x, 0);
}

@end
