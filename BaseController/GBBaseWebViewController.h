//
//  GBBaseWebViewController.h
//  Dmallovo
//
//  Created by Mac on 2020/3/24.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GBBaseWebViewController : GBBaseViewController

/// 请求URL
@property (nonatomic, strong) NSString *URLStr;

@property (nonatomic, strong) NSString *HTMLString;

/// 导航栏标题
@property (nonatomic, strong) NSString *navigationBarTitle;

/// 是否隐藏导航栏 默认NO
@property (nonatomic, assign) BOOL shouldHiddenNavigationBar;

/// 是否取消导航栏的title等于webView的title。默认是不取消，default is NO
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewTitle;
/// 是否取消关闭按钮。默认是取消，default is YES
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewClose;
/// 是否取消分享按钮，默认是取消， YES
@property (nonatomic, readwrite, assign) BOOL shouldDisableWebViewShare;

/// 默认隐藏,yes
@property (nonatomic, readwrite, assign) BOOL shouldHiddenSectionView;

/// 是否PresentStyle
@property (nonatomic, assign) BOOL shouldPresentStyle;

@property (nonatomic, copy) void (^didSelectedBlock) (void);

@property (nonatomic, copy) void (^popBlock) (void);

@end

NS_ASSUME_NONNULL_END
