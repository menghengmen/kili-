//
//  SetTableViewCell.m
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SetTableViewCell.h"

@interface SetTableViewCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* splitWidth;
@property (weak, nonatomic) IBOutlet UIImageView* hintImg;
@property (weak, nonatomic) IBOutlet UILabel* timeStr;

@end

@implementation SetTableViewCell

- (void)refreshUI:(SetModel*)dataModel{
    self.timeStr.text = dataModel.timeStr;
    self.splitWidth.constant = dataModel.splitWidth;

    switch (dataModel.timeStrTipType) {
        case SetModelTimeStrTipTypeNone: //不显示时间
        {
            self.timeStr.hidden = YES;
        } break;
        case SetModelTimeStrTipTypeIsHour: //是处于小时的时刻
        {
            self.timeStr.hidden = NO;
            self.timeStr.textColor = [UIColor getColor:@"#656688"];
        } break;
        case SetModelTimeStrTipTypeHaveTip: //此刻需要提示用户喝水
        {
            self.timeStr.hidden = NO;
            self.timeStr.textColor = [UIColor getColor:@"#e7e74d"];
        } break;
    }

    switch (dataModel.imageTipType) {
        case SetModelImageTipTypeNone: //没有此刻的提示
        {
            self.hintImg.hidden = YES;
        } break;
        case SetModelImageTipTypeDone: //已经喝完水了
        {
            self.hintImg.hidden = NO;
            self.hintImg.image = [UIImage imageNamed:@"img_water_polo_check"];
        } break;
        case SetModelImageTipTypeUntill: //还没到时间
        {
            self.hintImg.hidden = NO;
            self.hintImg.image = [UIImage imageNamed:@"img_water_polo_s"];
        } break;
        case SetModelImageTipTypeExpired: //已经到点了,还没有喝水
        {
            self.hintImg.hidden = NO;
            self.hintImg.image = [UIImage imageNamed:@"img_water_polo_warn"];
        } break;
    }
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

@end

