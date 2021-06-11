//
//  SGLNavigationViewController.h
//
//
//  Created by belin on 2020/6/22.
//  Copyright © 2016年 Malilai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GBNavigationController : UINavigationController

- (void)addFullScreenPopBlackListItem:(UIViewController *)viewController;
- (void)removeFromFullScreenPopBlackList:(UIViewController *)viewController;

@property(nonatomic,strong) UIView *targetView;
@property(nonatomic,strong) UIPanGestureRecognizer * fullScreenGes;

@end
