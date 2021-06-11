//
//  GBResponseModel.m
//  Dmallovo
//
//  Created by Mac on 2020/2/20.
//  Copyright © 2020 Belin. All rights reserved.
//

#import "GBResponseModel.h"

@implementation GBTipsBtnListModel

@end

@implementation GBResponseModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"TipsBtnList" :[GBTipsBtnListModel class]
    };
}

@end
