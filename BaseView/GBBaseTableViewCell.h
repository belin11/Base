//
//  GBBaseTableViewCell.h
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GBBaseTableViewCell : UITableViewCell

//@property (nonatomic, strong, readonly) GBBaseView *bottomLine;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style;

/// 绑定数据
/// @param viewModel 视图模型
- (void)bindViewModel:(nullable id)viewModel;

@end

NS_ASSUME_NONNULL_END
