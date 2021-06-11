//
//  SGLNavigationViewController.m
//  MFNav
//
//  Created by 爱上党 on 16/7/22.
//  Copyright © 2016年 尚高林. All rights reserved.
//

#import "GBNavigationController.h"
#import "GBTabBarController.h"

@interface GBNavigationController () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSMutableArray *blackList;

@end

@implementation GBNavigationController
+ (void)initialize {
    
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [UINavigationBar appearance].translucent = NO;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = FONT(18);
    dict[NSForegroundColorAttributeName] = GloBal_BlackColor;
    [[UINavigationBar appearance] setTitleTextAttributes:dict];
    NSMutableDictionary *dict2 = [NSMutableDictionary dictionary];
    dict2[NSFontAttributeName] = FONT(14);
    dict2[NSForegroundColorAttributeName] = GloBal_DarkGrayColor;
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict2 forState:UIControlStateNormal];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary dictionary];
    dict3[NSFontAttributeName] = FONT(14);
    dict3[NSForegroundColorAttributeName] = GloBal_BlackColor;
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict3 forState:UIControlStateHighlighted];
    
    NSMutableDictionary *dict4 = [NSMutableDictionary dictionary];
    dict4[NSFontAttributeName] = FONT(14);
    dict4[NSForegroundColorAttributeName] = GloBal_GrayColor;
    [[UIBarButtonItem appearance] setTitleTextAttributes:dict4 forState:UIControlStateDisabled];
}

+ (void)load {
    
}

#pragma mark - Lazy load
- (NSMutableArray *)blackList {
    if (!_blackList) {
        _blackList = [NSMutableArray array];
    }
    return _blackList;
}

#pragma mark - Public
- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController {
    if (!viewController) {
        return ;
    }//GBInverstZFMethodController
    [self.blackList addObject:viewController];
}

- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController {
    for (UIViewController *vc in self.blackList) {
        if (vc == viewController) {
            [self.blackList removeObject:vc];
        }
    }
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.modalPresentationStyle = UIModalPresentationFullScreen;
#if 1 //边缘返回手势开启
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = YES;
#else //全屏返回手势开启
    //  这句很核心 稍后讲解
    id target = self.interactivePopGestureRecognizer.delegate;
    //  这句很核心 稍后讲解
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    //  获取添加系统边缘触发手势的View
    _targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    _fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    _fullScreenGes.delegate = self;
    [_targetView addGestureRecognizer:_fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
#endif
}

#pragma mark - UIGestureRecognizerDelegate
//  防止导航控制器只有一个rootViewcontroller时触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 根据具体控制器对象决定是否开启全屏右滑返回
    for (UIViewController *viewController in self.blackList) {
        if ([self topViewController] == viewController) {
            return NO;
        }
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x < 0) {
        return NO;
    }
    
    return self.childViewControllers.count > 1;
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:YES];
}

@end


