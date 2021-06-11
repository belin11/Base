//
//  GBBaseController.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseViewController.h"
#import "GBPrivacyPopupView.h"
#import "GBBaseWebViewController.h"

#import "GBYouPinOrderCollectionController.h"
#import "GBShoppingCartController.h"

#import "DZShareManeger.h"
#import "GBShareInfoModel.h"

@interface GBBaseViewController ()

@property (nonatomic, strong) GBBaseView *navigationBarBackgroundView;

@property (nonatomic, strong) JhtFloatingBall *ball;
@property (nonatomic, assign) BOOL isPopLastController;

@end

@implementation GBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
    }
    self.navigationBarOpaque = YES;
    self.showNavigationBarBottomLine = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    
    if (!CGRectEqualToRect(self.viewFrame, CGRectZero)) {
        self.view.frame = self.viewFrame;
    }
}

#pragma mark 设置导航栏
- (void)setupNavigationBar {
    
    if (self.navigationController.childViewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage gb_originalImageWithImageName:@"返回-1"] style:UIBarButtonItemStylePlain target:self action:@selector(popController)];
    }
}

#pragma mark - 添加浮球
- (void)addFloatingBallWithImageName:(NSString *)imageName {
    
    UIImage *image;
    if ([imageName hasSuffix:@"gif"]) {
        image = [UIImage gb_animatedImageWithGifName:imageName];
    } else {
        image = [UIImage imageNamed:imageName];
    }
    JhtFloatingBall *ball = [[JhtFloatingBall alloc] initWithFrame:CGRectMake(self.view.width - image.size.width, selfViewHeight-image.size.height-100, image.size.width, image.size.height)];
    ball.image = image;
    ball.delegate = self;
    ball.stayMode = StayMode_OnlyRight;
    [self.view addSubview:ball];
    _ball = ball;
}


#pragma mark 点击浮窗的代理事件
- (void)tapFloatingBall {

    GBBaseWebViewController *vc = [GBBaseWebViewController new];
    NSString *str = [NSString stringWithFormat:@"%@%@", Load_SERVICE_PATH, @"/Activity/RedPackets_Activity_2020_Dec"];
    if (_isPopLastController) {
        str = [NSString stringWithFormat:@"%@?SourceEntrance=app", str];
    }
    vc.URLStr = str;
    vc.shouldHiddenSectionView = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 退出控制器
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadIsShowGetRedPacketData:(NSString *)imageName isPopLastController:(BOOL)yesOrNo {
    self.isPopLastController = yesOrNo;
    [self loadIsShowGetRedPacketData:imageName];
    
}

- (void)loadIsShowGetRedPacketData:(NSString *)imageName {
    
    if (![GBPickManager isNeedPick]) {
        return;
    }
    [GBHttpTool POST:@"RedEnvelope/GetActivityState" params:nil success:^(GBResponseModel * _Nonnull responseModel) {
        if (responseModel.errorCode == 1000) {
            bool enable = [responseModel.data boolValue];
            if (enable) {
                if (!_ball) {
                    [self addFloatingBallWithImageName:imageName];
                }
            } else {
                if (_ball) {
                    [_ball removeFromSuperview];
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setStatusBarStyleLight:(BOOL)statusBarStyleLight {
    _statusBarStyleLight = statusBarStyleLight;
    if (@available(iOS 13.0, *)) {
        
        [UIApplication sharedApplication].statusBarStyle = statusBarStyleLight? UIStatusBarStyleLightContent: UIStatusBarStyleDarkContent;
    } else {
        
        [UIApplication sharedApplication].statusBarStyle = statusBarStyleLight? UIStatusBarStyleLightContent: UIStatusBarStyleDefault;
    };
}

- (void)setNavigationBarOpaque:(BOOL)navigationBarOpaque {
    _navigationBarOpaque = navigationBarOpaque;
    if (navigationBarOpaque) {//不透明
       [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
       self.navigationController.navigationBar.translucent = NO;
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = YES;
    }
}

- (void)setShowNavigationBarBottomLine:(BOOL)showNavigationBarBottomLine {
    _showNavigationBarBottomLine = showNavigationBarBottomLine;
    [self.navigationController.navigationBar setShadowImage:showNavigationBarBottomLine? nil : [UIImage new]];
}

- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    _navigationBarAlpha = navigationBarAlpha;
    self.navigationBarBackgroundView.alpha = navigationBarAlpha;
}

- (GBBaseView *)navigationBarBackgroundView {
    if (!_navigationBarBackgroundView) {
        
        _navigationBarBackgroundView = [[GBBaseView alloc] initWithBgColor:[UIColor whiteColor]];
        _navigationBarBackgroundView.frame = CGRectMake(0, 0, self.view.width, StatusAndNavHeight);
        _navigationBarBackgroundView.alpha = 0;
        [self.navigationController.view insertSubview:_navigationBarBackgroundView belowSubview:self.navigationController.navigationBar];
    }
    return _navigationBarBackgroundView;
}

- (void)loadBuriedPointWithPositionType:(NSInteger)PositionType ClassId:(NSString *)ClassId ClassName:(NSString *)ClassName SalesArea:(NSInteger)SalesArea RelationId:(NSInteger)RelationId RelationName:(NSString *)RelationName UniqueId:(NSString *)UniqueId {
    
    NSMutableDictionary *dict = @{
     
        @"PositionType": @(PositionType),
        @"ClassId": ClassId?:@"",
        @"ClassName": ClassName?:@"",
        @"SalesArea": @(SalesArea),
//        @"ClientType" :@2,
        @"UniqueId" : UniqueId?:@"",
//        @"DeviceId" : [NSString gb_getUUID],
        @"RelationId": @(RelationId),
        @"RelationName": RelationName?:@"",
        
    }.mutableCopy;
    
    [GBHttpTool POST:@"Global/BuriedPoint" params:dict success:^(GBResponseModel * _Nonnull responseModel) {
        if (responseModel.errorCode == 1000) {
            NSLog(@"埋点成功");
        }
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestBuryingPointsWithType:(NSInteger)type page:(NSInteger)page {
    
    NSDictionary *dict = @{
        @"type": @(type),
        @"page": @(page),
        @"remark": @"",
        @"points":@0,
    };
    [GBHttpTool POST:@"Activity/BuryingPoints" params:dict success:^(GBResponseModel * _Nonnull responseModel) {
        if (responseModel.errorCode == 1000) {
            NSLog(@"埋点成功");
        }
        
    } failure:^(NSError * _Nonnull error) {
    }];
}

- (void)gotoShareWithShareInfo:(GBShareInfoModel *)shareInfo success:(nonnull void (^)(void))success{
    
    [DZShareManeger shareWithShareTitle:shareInfo.ShareTitle shareContent:shareInfo.ShareRemark shareIcon:shareInfo.ShareIcon shareUrl:shareInfo.ShareLink success:^(BOOL isPaste) {
        if (!success) {
            [MBProgressHUD showAutoHUDWithMessage:@"分享成功"];
        } else {
            if (success) {
                success();
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (GBSuspensionBox *)box {
    if (!_box) {
        _box = [[GBSuspensionBox alloc] initWithFrame:CGRectMake(0, selfViewHeight - 50 - 45, 90, 75)];
        @weakify(self)
        _box.didClickButtonBlock = ^(NSInteger index) {
            @strongify(self)
            [GBLoginManager.sharedManager needJudgeWhetherLoginWithLoginedBlock:^{
                if (index == 0) {
                    GBYouPinOrderCollectionController *vc = [GBYouPinOrderCollectionController new];
                    [self.navigationController pushViewController:vc animated:YES];
                } else if (index == 1) {
                    GBShoppingCartController *vc = [GBShoppingCartController new];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } afterLoginBlock:^{
                
            }];
        };
    }
    return _box;
}

#pragma mark 保存图片
- (void)saveImageToPhoto:(UIImage *)image {

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if (error) {
        NSLog(@"保存相册失败");
    } else {
        [MBProgressHUD showAutoHUDWithMessage:@"保存相册成功"];
        NSLog(@"保存相册成功");
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

@end
