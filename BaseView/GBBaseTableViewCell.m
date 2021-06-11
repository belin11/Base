//
//  GBBaseTableViewCell.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBBaseTableViewCell.h"

@interface GBBaseTableViewCell ()

//@property (nonatomic, strong) GBBaseView *bottomLine;

@end

@implementation GBBaseTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    return [self cellWithTableView:tableView style:UITableViewCellStyleDefault];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)style {
    
    id cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        
        cell = [[self alloc] initWithStyle:style reuseIdentifier:@"cellId"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = [UIColor gb_colorWithRed:240 green:240 blue:240];
        
//        self.bottomLine = [[GBBaseView alloc] initWithBgColor:GloBal_DivideColor];
//        self.bottomLine.hidden = YES;
//        [self.contentView addSubview:self.bottomLine];
    }
    return self;
}

- (void)bindViewModel:(id)viewModel{
    
}


@end
