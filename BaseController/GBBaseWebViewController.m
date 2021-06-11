//
//  GBBaseWebViewController.m
//  Dmallovo
//
//  Created by Mac on 2020/3/24.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"
#import "DZShareManeger.h"
#import "AccountLoginController.h"
#import "DZRegirstSuccessController.h"
#import "GBQuickLoginController.h"
#import "GBJumpLinkModel.h"
#import "SignContractController.h"
#import "GBShareVoucherModel.h"
#import "GBShareVoucherListModel.h"
#import "GBLaborDayShareRewardAlertView.h"

@interface GBBaseWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareIcon;
@property (nonatomic, strong) NSString *shareRemark;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, assign) BOOL isGetSharePoints;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, strong) NSString *sharePointsName;
@property (nonatomic, strong) NSString *shareImgUrlStr ;//分享图片地址
@property (nonatomic, strong) NSString *toUrl;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;
@property (nonatomic, strong) NSString *pushedControllerName;
@property (nonatomic, assign) BOOL isCanPopToOrigin;

@end

@implementation GBBaseWebViewController

- (void)dealloc {
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        _shouldDisableWebViewClose = YES;
        _shouldDisableWebViewShare = YES;
        _shouldHiddenSectionView = YES;
        _shouldHiddenNavigationBar = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = _shouldHiddenNavigationBar;
    if (_pushedControllerName && ([_pushedControllerName containsString:@"AddressEditController"] || [_pushedControllerName containsString:@"AddressManageController"] || [_pushedControllerName containsString:@"GBMallCollectionController"])) {
        [self.webView reload];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if ([_URLStr containsString:@"Activity/GiftCalendar_Activity_2020_Oct"]) {
        self.shouldHiddenNavigationBar = YES;
    }
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self addObserve];
    [self setBridgeConfig];
}

- (void)setBridgeConfig{
    
    // 开启日志
    [WKWebViewJavascriptBridge enableLogging];
    
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [self.bridge setWebViewDelegate:self];
    __weak typeof(self) weakself = self;
    [self.bridge registerHandler:@"getBlogNameFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {

        NSLog(@"js call getBlogNameFromObjC, data from js is %@", data);
        [weakself getData:data];
        responseCallback(@"");
    }];
    //0：保存图片 1.分享图片 2.分享链接
    [self.bridge registerHandler:@"getShareImgFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getShareImgFromObjC, data from js is %@", data);
        [weakself shareImageWithData:data];
        responseCallback(@"");
    }];
    [self.bridge registerHandler:@"onBackPressed" handler:^(id data, WVJBResponseCallback responseCallback) {
//        [weakself.navigationController popViewControllerAnimated:YES];
        [weakself popController];
    }];
    
    [self.bridge registerHandler:@"getShopInfoFromObjC" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getShopInfoFromObjC, data from js is %@", data);
        [weakself getShopInfoWithData:data];
    }];
}
#pragma mark 去登录
- (void)toQuickLoginWithControllerName:(NSString *)controllerName parameter:(NSString *)parameter {
    Class Class = NSClassFromString(controllerName);
    GBQuickLoginController *vc = [Class new];
    vc.Parameter = parameter;
    vc.gb_refreshAPIBlock = ^{
        NSURL *URL = [NSURL URLWithString:_URLStr];
        NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:URL];
        GBAccountModel *account = [GBAccountManager.sharedManager account];
        if (account.authToken) {
            [re setValue:account.authToken forHTTPHeaderField:@"AuthToken"];
        }
        [self.webView loadRequest:re];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getShopInfoWithData:(id)data {
    NSDictionary *dict = data;
    NSInteger admin = [dict[@"admin"] integerValue];
    NSString *controllerName = dict[@"ViewController"];
    NSString *parameter = dict[@"Parameter"];
    if (admin == 0) {
        [self toQuickLoginWithControllerName:controllerName parameter:parameter];
    } else {
        [self gb_jumpLinkWithValue:controllerName];
    }
}

- (void)shareImageWithData:(id)data {
    NSDictionary *dic = data;
    _shareTitle = dic[@"ShareTitle"];
    _shareIcon = dic[@"ShareIcon"];
    _shareLink = dic[@"ShareLink"];
    _shareRemark = dic[@"ShareRemark"];
    _isGetSharePoints = [dic[@"IsGetSharePoints"] boolValue];
    _sharePointsName = dic[@"SharePointsName"];
    _shareImgUrlStr = dic[@"ShareImgUrlStr"];
    NSString *dictStr = dic[@"Parameter"];
//        dictStr = @"{\"type\":61,\"num\":\"\"}";
    NSDictionary *params = dictStr.mj_JSONObject;
    _params = params;
    NSInteger type = [dic[@"type"] intValue];
    if (type == 0) {//保存图片
        [self saveImageAction];
    } else if (type == 1){//分享图片
        [self shareImage];
    } else if (type == 2) {//分享链接
        [self share];
    }
}

#pragma mark 去登录
- (void)pushLogin {
    
    [MyAlertView showWithTitle:@"提示" message:@"您还未登录，请先登录" cancelButtonTitle:@"取消" otherButtonTitle:@"去登录" block:^(MyAlertView *view, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            GBQuickLoginController *accoutLoginContrller=[GBQuickLoginController new];
            [self.navigationController pushViewController:accoutLoginContrller animated:YES];
        }
    }];
}
#pragma mark 响应
- (void)getData:(id)data {
    
    NSDictionary *dic = data;
    NSString *controllerName = dic[@"ViewController"];
    _pushedControllerName = controllerName;
//    NSString *paramStr = dic[@"Parameter"];
    int type = [dic[@"type"] intValue];
    BOOL neeed_admin = [dic[@"admin"] boolValue]; //admin = 0 不需要登陆  =1 需要登录];

    if (neeed_admin) {
        if (![GBAccountManager.sharedManager account]) {
           [self pushLogin];
           return ;
       }
    }
    if (type == 0) {
        if ([controllerName isEqualToString:@"GBQuickLoginController"]) {
            [self toQuickLoginWithControllerName:controllerName parameter:nil];
            GBQuickLoginController *accoutLoginContrller=[GBQuickLoginController new];
            accoutLoginContrller.gb_refreshAPIBlock = ^{
                NSURL *URL = [NSURL URLWithString:[self.URLStr gb_URLEncoding]];
                NSMutableURLRequest *re = [NSMutableURLRequest requestWithURL:URL];
                GBAccountModel *account = [GBAccountManager.sharedManager account];
                if (account.authToken) {
                    [re setValue:account.authToken forHTTPHeaderField:@"AuthToken"];
                }
                [self.webView loadRequest:re];
            };

            [self.navigationController pushViewController:accoutLoginContrller animated:YES];
        } else {
            [self gb_jumpLinkWithValue:controllerName];

        }
    } else if (type == 1) {
        //分享按钮
        _shareTitle = dic[@"ShareTitle"];
        _shareIcon = dic[@"ShareIcon"];
        _shareLink = dic[@"ShareLink"];
        _shareRemark = dic[@"ShareRemark"];
        _isGetSharePoints = [dic[@"IsGetSharePoints"] boolValue];
        _sharePointsName = dic[@"SharePointsName"];
        _toUrl = dic[@"toUrl"];
        
        NSString *dictStr = dic[@"Parameter"];
//        dictStr = @"{\"type\":61,\"num\":\"\"}";
        NSDictionary *params = dictStr.mj_JSONObject;
        _params = params;
        [self share];
    } else if (type == 2) {//签合同
        
        GBJumpLinkModel *model = [[GBJumpLinkModel alloc] initWithValue:controllerName];
        NSMutableDictionary *dict = model.params.mutableCopy;
        dict[@"Platform"] = @2;
        [SVProgressHUD showHUD];
        [GBHttpTool POST:SignContractNew params:dict success:^(GBResponseModel * _Nonnull responseModel) {
            [SVProgressHUD dismiss];
            NSInteger status = responseModel.errorCode;
            if (status == 1000) {
                
                SignContractController *VC = [SignContractController new];
                VC.URLStr = responseModel.data;
                VC.OrderId = dict[@"OrderId"];
                [self.navigationController pushViewController:VC animated:YES];
            }  else {
                [MBProgressHUD showAutoHUDWithMessage:responseModel.message];
            }
            
        } failure:^(NSError * _Nonnull error) {
            [SVProgressHUD dismiss];
        }];

    }
}

#pragma mark 分享链接
- (void)share {
   
    [DZShareManeger shareWithShareTitle:_shareTitle shareContent:_shareRemark shareIcon:_shareIcon shareUrl:_shareLink success:^(BOOL isPaste) {

        if (_isGetSharePoints == 1) {
            if (_params.allKeys.count) {
                [self postShareWithParams:_params];
            } else {
                [self getShare];
            }
        } else {
            [MBProgressHUD showSuccess:@"分享成功！"];
        }
        if (_toUrl.length) {
            [self gb_jumpLinkWithValue:_toUrl];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败！"];
    }];
}
#pragma mark 保存图片操作
- (void)saveImageAction {
    if (!_shareImgUrlStr.length) {
        [MBProgressHUD showAutoHUDWithMessage:@"获取图片失败"];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImgUrlStr]];
        UIImage *photoImage = [UIImage imageWithData:imagedata];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self saveImageFinished:photoImage];
        });
    });
}

#pragma mark 保存图片
- (void)saveImageFinished:(UIImage *)image {

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error) {
        NSLog(@"保存相册失败");
    } else {
        [MBProgressHUD showAutoHUDWithMessage:@"保存成功"];
        NSLog(@"保存相册成功");
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

#pragma mark 分享图片
- (void)shareImage {
    //_shareImgUrlStr：表示分享图片的链接
    [DZShareManeger shareWithImage:_shareImgUrlStr success:^{
        if (_isGetSharePoints == 1) {
            if (_params.allKeys.count) {
                [self postShareWithParams:_params];
            } else {
                [self getShare];
            }
        } else {
            [MBProgressHUD showSuccess:@"分享成功！"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"分享失败！"];
    }];
}

#pragma mark 分享成功请求接口
-(void)getShare {

    [GBHttpTool POST:_sharePointsName params:nil success:^(GBResponseModel * _Nonnull responseModel) {
        if (responseModel.errorCode == 1000) {
            if ([responseModel.data isKindOfClass:[NSNumber class]]) {
                NSInteger num = [responseModel.data integerValue];
                if (num>1) {
                    [DZToolKit showStatusViewWithString:[NSString stringWithFormat:@"分享成功+%@积分",responseModel.data] andSuperView:self.view andHeadImage:[UIImage imageNamed:@"ic_common_remind"]];
                } else {
                    [MBProgressHUD showSuccess:@"分享成功！"];
                }
            } else if ([responseModel.data isKindOfClass:[NSDictionary class]]) {
                [MBProgressHUD showSuccess:@"分享成功！"];
            }

        } else {
            [MBProgressHUD showAutoHUDWithMessage:responseModel.message];
        }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络不给力"];
    }];
}
#pragma mark post分享
- (void)postShareWithParams:(NSDictionary *)params {
    
    [GBHttpTool POST:_sharePointsName params:params success:^(GBResponseModel * _Nonnull responseModel) {
        if (responseModel.errorCode == 1000) {
            if ([responseModel.data isKindOfClass:[NSDictionary class]]) {//
                GBShareVoucherModel *model = [GBShareVoucherModel mj_objectWithKeyValues:responseModel.data];
                [self.webView reload];

                if (model.List.count == 0) {
                    return;
                }
//                NSInteger type = [params[@"type"] integerValue];
                
                [GBLaborDayShareRewardAlertView showWithModel:model block:^(NSInteger index) {
                    if (model.List.firstObject.VoucherType == 1) {//
                        if (index == 0) {
                            [self gb_jumpLinkWithValue:@"GBCouponCollectController"];
                        } else {
                            [self gb_jumpLinkWithValue:@"GBHotSellController"];
                        }
                    } else {//优品满减券
                        if (index == 0) {
                            [self gb_jumpLinkWithValue:@"GBCouponCollectController?tab=1"];

                        } else {
                            [self gb_jumpLinkWithValue:@"GBYouPinAllGoodsListController"];

                        }
                    }
                }];

            } else {
                NSInteger num = [responseModel.data integerValue];
                if (num>1) {
                    [DZToolKit showStatusViewWithString:[NSString stringWithFormat:@"分享成功+%@积分",responseModel.data] andSuperView:self.view andHeadImage:[UIImage imageNamed:@"ic_common_remind"]];
                } else {
                    [MBProgressHUD showSuccess:@"分享成功！"];
                }
            }

         } else {
             [MBProgressHUD showAutoHUDWithMessage:responseModel.message];
         }
    } failure:^(NSError * _Nonnull error) {
        [MBProgressHUD showError:@"网络不给力，请稍后重试"];
    }];
}

#pragma mark 添加观察者
- (void)addObserve {
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"NSWebviewReloadNotification" object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.webView reload];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"backtoMeVc" object:nil] subscribeNext:^(id x) {
        @strongify(self)
//        [self.navigationController popToRootViewControllerAnimated:YES];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        self.tabBarController.selectedIndex = self.tabBarController.childViewControllers.count-1;
    }];
    
    [[RACObserve(self.webView, estimatedProgress) deliverOnMainThread] subscribeNext:^(NSNumber *x) {
        @strongify(self)
         CGFloat progress = [x floatValue];
         [self.progressView setProgress:progress animated:YES];
         if (progress == 1) {
             [[RACScheduler mainThreadScheduler] afterDelay:0.3 schedule:^{
                 self.progressView.hidden = YES;
             }];
         }
    }];
    
    [[RACObserve(self, URLStr) filter:^BOOL(NSString *value) {

        return value.length;
    }] subscribeNext:^(NSString *x) {
        @strongify(self)
        if ([self isChinese:x]) {
            x = [x gb_URLEncoding];
        }
        NSURL *URL = [NSURL URLWithString:x];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
        GBAccountModel *account = [GBAccountManager.sharedManager account];
        if (account.authToken) {
            [request setValue:account.authToken forHTTPHeaderField:@"AuthToken"];
        }
        NSDictionary *cachedHeaders = [[NSUserDefaults standardUserDefaults] objectForKey:x];
        //设置request headers (带上上次的请求头下面两参数一种就可以，也可以两个都带上)
        if (cachedHeaders) {
            NSString *etag = [cachedHeaders objectForKey:@"Etag"];
            if (etag) {
                [request setValue:etag forHTTPHeaderField:@"If-None-Match"];
            }
            NSString *lastModified = [cachedHeaders objectForKey:@"Last-Modified"];
            if (lastModified) {
                [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
            }
        }
        [self.webView loadRequest:request];
        
        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            NSLog(@"httpResponse == %@", httpResponse);
// 根据statusCode设置缓存策略
            if (httpResponse.statusCode == 304 || httpResponse.statusCode == 0) {
                [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
            } else {
                [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
// 保存当前的NSHTTPURLResponse
            [[NSUserDefaults standardUserDefaults] setObject:httpResponse.allHeaderFields forKey:x];
            }
// 重新刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView reload];
            });
        }] resume];
    }];
    
    [[RACObserve(self, HTMLString) filter:^BOOL(NSString *value) {
        return value.length;
    }] subscribeNext:^(id x) {
        @strongify(self)
        [self.webView loadHTMLString:x baseURL:nil];
    }];
}

-(BOOL) isChinese:(NSString *) str
{
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4E00 && a < 0x9FFF)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark 退出控制器
- (void)popController {
    
    if ([_URLStr containsString:@"Activity/OneOff_Activity_2020_Nov"] || [_URLStr containsString:@"Activity/OneOffTime_Activity_2020_Nov"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if ([_webView.URL.absoluteString containsString:@"/PointsMall/ExchangeResults"]) {
        
        return;
    }
    //http://dev.dmallovo1901.com/Activity/OneOffTime_Activity_2020_Nov
    NSString *urlStr = _webView.URL.absoluteString;
    if ([self.webView canGoBack] && ![urlStr isEqualToString:_URLStr]) {
          [self.webView goBack];
      } else {
          if (self.popBlock) {
              self.popBlock();
          }
          NSArray <GBBaseViewController *> *childvcs = self.navigationController.viewControllers;
          __block BOOL isContained = NO;
          [childvcs enumerateObjectsUsingBlock:^(GBBaseViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
              if ([obj isKindOfClass:[DZRegirstSuccessController class]]) {
                  isContained = YES;
                  *stop = YES;
              }
          }];
          if (isContained) {
              [self.navigationController popToRootViewControllerAnimated:YES];
              self.tabBarController.selectedIndex = self.tabBarController.childViewControllers.count-1;
          }
         
          if (self.presentingViewController) {
              [self dismissViewControllerAnimated:YES completion:nil];
          } else {
              [self.navigationController popViewControllerAnimated:YES];
          }
      }
}

#pragma mark - 设置导航栏
- (void)setupNavigationBar {
    [super setupNavigationBar];
    @weakify(self)
    if (!_shouldDisableWebViewShare) {
        UIBarButtonItem *_shareItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage gb_originalImageWithImageName:@"ic_common_activity_share"] style:UIBarButtonItemStyleDone handler:^(id sender) {
            @strongify(self)
            [self share];
        }];
        self.navigationItem.rightBarButtonItem = _shareItem;
    }
    
    if (_shouldPresentStyle) {
        UIBarButtonItem *_closeItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage gb_originalImageWithImageName:@"ic_common_close_black"] style:0 handler:^(id sender) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        self.navigationItem.leftBarButtonItem = _closeItem;
    }
    
    if (_shouldDisableWebViewClose) return;
        
    UIBarButtonItem *_backItem = self.navigationItem.leftBarButtonItem;
    UIBarButtonItem *_closeItem = [[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"ic_navbar_com_close_default"] style:0 handler:^(id sender) {
        @strongify(self)
        [self popController];
    }];
    if (_backItem) {
        self.navigationItem.leftBarButtonItems = @[_backItem, _closeItem];
    } else {
        self.navigationItem.leftBarButtonItems = @[ _closeItem];
    }
}

#pragma mark - 设置导航栏标题
- (void)setNavigationBarTitle:(NSString *)navigationBarTitle {
    
    _navigationBarTitle = navigationBarTitle;
    self.navigationItem.title = navigationBarTitle;
    self.shouldDisableWebViewTitle = YES;
}

#pragma mark - 设置导航栏标题
- (void)setNavigationItemTitle {
    
    if (self.shouldDisableWebViewTitle) return;
    ///获取网页标题
    NSString *htmlTitle = @"document.title";
    @weakify(self)
    [_webView evaluateJavaScript:htmlTitle completionHandler:^(id _Nullable evaluate, NSError * _Nullable error) {
        @strongify(self)
        NSLog(@"导航栏标题：%@", evaluate);
        self.navigationItem.title = (NSString *)evaluate;
    }];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
    id dict = message.body;
    
    NSString *body = dict[@"body"];
    if (body) {
        // 复制到黏贴版
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:body];
        // 打开微信
        NSURL *url = [NSURL URLWithString:@"weixin://"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            // 安装了微信
            [[UIApplication sharedApplication] openURL:url];
        } else {
            [MBProgressHUD showError:@"您未安装微信!" afterDelay:1.5];
        }
    }
}

#pragma mark - webView WKNavigationDelegate
#pragma mark - 在发送请求之前，决定是否跳转的代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"发送请求----》%@", navigationAction.request.URL.absoluteString);
    NSLog(@"在发送请求之前，决定是否跳转的代理");
//    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
//    NSString *url_str = navigationAction.request.URL.absoluteString;
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url_str]];
//        // 不允许web内跳转
//        decisionHandler(WKNavigationActionPolicyCancel);
//        return;
//    }
    NSString *path = navigationAction.request.URL.path;
//    webView.y = _shouldHiddenSectionView?-44: (_shouldHiddenNavigationBar ? StatusBarHeight: 0);
//    if ([path containsString:@"PointsMall/ChooseAddress"] || [path containsString:@"Member/EditAddress"] || [path containsString:@"Member/AddAddress"]) {
//        webView.y = -44;
//    }

    if ([path isEqualToString:@"/Home/Index"]||[path isEqualToString:@"/Project/Info"]||[path isEqualToString:@"/Life/Index"]||[path isEqualToString:@"/Member/My"] || [path isEqualToString:@"/PointsMall/Index"]) {
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
        _isCanPopToOrigin = NO;
        if (self.didSelectedBlock) {
            self.didSelectedBlock();
        }
    }
    if (navigationAction.targetFrame == nil) {//当target="blank"标签时 表示新建窗口打开 实现这句代码就能在当前窗口打开
        [webView loadRequest:navigationAction.request];
    }
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    // 打电话
    if ([scheme isEqualToString:@"tel"]) {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:URL]) {
            [app openURL:URL];
            // 一定要加上这句,否则会打开新页面
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
    }

    //应用的web内跳转
    decisionHandler(_isCanPopToOrigin? WKNavigationActionPolicyCancel:WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"接收到服务器跳转请求的代理");
    
}
#pragma mark - 准备加载页面

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    NSLog(@"准备加载页面");
}

#pragma mark - 在收到响应后，决定是否跳转的代理
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"在收到响应后，决定是否跳转的代理");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

#pragma mark - 开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    NSLog(@"开始加载页面");

}

#pragma mark - 页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    [self setNavigationItemTitle];
    //redirect是跳转页面的地址中的一个关键字。进入网页以后，加载完毕以后会跳转到另外一个页面，所以我们等它跳转到加载完毕哪个页面，webView.URL的路径中包含了redirect以后，再显示网页。
//    if ([webView.URL.absoluteString rangeOfString:@"index"].location != NSNotFound) {
//
//        webView.hidden = NO;
//    }
    @weakify(self)
    [webView evaluateJavaScript:@"document.getElementById('ShareTitle').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.shareTitle= value;
    }];
    
    [webView evaluateJavaScript:@"document.getElementById('ShareIcon').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.shareIcon= value;
    }];
    [webView evaluateJavaScript:@"document.getElementById('ShareLink').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.shareLink= value;
    }];
    [webView evaluateJavaScript:@"document.getElementById('ShareRemark').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.shareRemark= value;
        if (self.shareRemark.length) {
            self.shouldDisableWebViewShare = NO;
            [self setupNavigationBar];
        }

    }];
    [webView evaluateJavaScript:@"document.getElementById('IsGetSharePoints').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.isGetSharePoints = [value boolValue];
    }];
    [webView evaluateJavaScript:@"document.getElementById('SharePointsName').value" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
        @strongify(self)
        self.sharePointsName= value;
    }];
    webView.hidden = NO;
    NSLog(@"页面加载完成");
}
#pragma mark - 准备加载页面失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"准备加载页面失败 %@",error);
}
#pragma mark - 页面加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"页面加载失败 %@",error);
}

#pragma mark - 在JS端调用alert函数时，会触发此代理方法。
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"警告框 %@", message);
    completionHandler();
}
#pragma mark - JS端调用confirm函数时，会触发此方法
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    NSLog(@"提示框 %@", message);
    completionHandler(YES);
}

#pragma mark - JS端调用prompt函数时，会触发此方法
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler {
    
    NSLog(@"prompt:%@ defaultText:%@", prompt, defaultText);
    completionHandler(@"yes");
}

#pragma mark 懒加载
- (WKWebView *)webView {
    
    if (!_webView) {
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        config.userContentController = [[WKUserContentController alloc] init];

        // 播放视频设置
        config.allowsInlineMediaPlayback = YES;
        if (@available(iOS 10.0, *)) { // 是否要让用户用手势操作
            config.mediaTypesRequiringUserActionForPlayback = NO;
        }
        
        CGFloat h = _shouldHiddenSectionView? (selfViewHeight+44): (_shouldHiddenNavigationBar?(SCREEN_SIZE.height-StatusBarHeight):selfViewHeight);
        CGFloat y = _shouldHiddenSectionView?-44: (_shouldHiddenNavigationBar ? StatusBarHeight: 0);
        if (self.shouldPresentStyle) {
            h = self.view.height - (_shouldHiddenSectionView? -44 :0) - (_shouldHiddenNavigationBar?0:StatusAndNavHeight);
            y = self.shouldHiddenSectionView? - 44: 0;
        }
        CGRect frame = CGRectMake(0, y, self.view.width, h);
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:config];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        _webView = webView;
    }
    return _webView;
}

#pragma mark - 初始化progressView
- (UIProgressView *)progressView {
    
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 2)];
        progressView.progressTintColor = GloBal_GrayColor;
        _progressView = progressView;
    }
    
    return _progressView;
}

@end
