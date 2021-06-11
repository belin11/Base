//
//  GBBaseTextView.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseTextView.h"

@interface GBBaseTextView ()

@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation GBBaseTextView

- (instancetype)initWithFont:(UIFont *)font textColor:(UIColor *)textColor returnKeyType:(UIReturnKeyType)returnKeyType delegate:(id<UITextViewDelegate>)delegate {
    
    if (self = [super init]) {
        if (font == nil) font = [UIFont systemFontOfSize:14]; // 默认字体大小
        self.font = font;
        self.textColor = textColor;
        self.returnKeyType = returnKeyType;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)textDidChange {
    
    if (self.text.length) { //有值隐藏
        
        self.placeholderLabel.hidden = YES;
    } else {//没有显示
        
        self.placeholderLabel.hidden = NO;
    }
    
    if (self.maxTextLength > 0) {
        [self getSubstring];
    }

}

- (void)getSubstring {
    
    //一个中文2个字节
    //当前的输入语言
    UITextInputMode *currentInputMode = self.textInputMode;
    NSString *language = currentInputMode.primaryLanguage;
    NSString *toBeString = self.text;
    if ([language isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，简体五笔，简体手写
        //获取高亮部分 只有在系统中文输入键盘字符串才有高度部分
        UITextRange *selectedRange = [self markedTextRange];
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制（拼音已确认为汉字）
        if (!position) {
            
            NSLog(@"---中文部分：%@---",toBeString);
            if (self.text.length > self.maxTextLength) {//当字数超过长度时
                self.text = [toBeString substringToIndex:self.maxTextLength];
            }
        } else {//有高亮部分的字符串，则暂不对文字进行统计和限制
            //这个时候正是输入的过程还是拼音状态，此时输入框的拼音被高亮选择 还没有按“确认”转化成汉字
            NSLog(@"---高亮部分：%@---",toBeString);
        }
        
    } else { // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        
        NSLog(@"---英文数字下：%@---", toBeString);
        if (self.text.length > self.maxTextLength) {
            self.text = [toBeString substringToIndex:self.maxTextLength];
        }
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    //当初始化的时候赋值也要判断是否显示占位符
    [self textDidChange];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}
- (void)setPlaceholder:(NSString *)placeholder {
    
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    [self.placeholderLabel sizeToFit];
}
- (void)setHidePlaceholder:(BOOL)hidePlaceholder {
    
    _hidePlaceholder = hidePlaceholder;
    
    self.placeholderLabel.hidden = hidePlaceholder;
}
- (void)setCanBecomeFirstResp:(BOOL)canBecomeFirstResp {
    
    _canBecomeFirstResp = canBecomeFirstResp;
    
    if (canBecomeFirstResp) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}
- (UILabel *)placeholderLabel {
    
    if (_placeholderLabel == nil) {
        
        UILabel *label = [[UILabel alloc] init];
        
        [self addSubview:label];
        
        _placeholderLabel = label;
    }
    return _placeholderLabel;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}
- (void)layoutSubviews {

    [super layoutSubviews];
    
    CGRect rect = self.placeholderLabel.frame;
    rect.origin = CGPointMake(self.textContainerInset.left + 5, self.textContainerInset.top);
    self.placeholderLabel.frame = rect;

    //获取垂直中心
//    CGPoint center = self.placeholderLabel.center;
//    self.placeholderLabel.center = CGPointMake(center.x, self.height / 2);
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
