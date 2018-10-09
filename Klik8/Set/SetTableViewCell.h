//
//  SetTableViewCell.h
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetModel.h"

@interface SetTableViewCell : UITableViewCell

- (void)refreshUI:(SetModel *)dataModel;

@end
