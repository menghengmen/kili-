#import "ProfileTextFileMeasurementTableViewCell.h"

@interface ProfileTextFileMeasurementTableViewCell ()

@property (nonatomic, weak) ProfileTextFileMeasurementCellModel* dataModel;

@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeight;

@property (weak, nonatomic) IBOutlet UILabel* measurement;
@property (weak, nonatomic) IBOutlet UITextField* textFiled;
@end

@implementation ProfileTextFileMeasurementTableViewCell

- (void)refreshUI:(ProfileTextFileMeasurementCellModel*)dataModel{
    _dataModel = dataModel;

    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgImageView.image = [[UIImage imageNamed:@"bubble2"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.measurement.text = dataModel.measurement;
    self.textFiled.text = dataModel.textFiled;

    self.bgViewWidth.constant = dataModel.sizeMeasurement.width + 60 + 23 + 1 + 15 + 20;
    self.bgViewHeight.constant = dataModel.sizeMeasurement.height + 20;
    if (self.bgViewHeight.constant < 42)
        self.bgViewHeight.constant = 42;

    [self loadData];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    self.textFiled.textAlignment = NSTextAlignmentCenter;
    self.textFiled.backgroundColor = [UIColor clearColor];
    self.textFiled.borderStyle = UITextBorderStyleNone;
    self.textFiled.placeholder = @"未知";
    self.measurement.textColor = [UIColor getColor:@"#898888"];
    self.textFiled.textColor = [UIColor getColor:@"#898888"];
    [self.textFiled addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)textFieldDidEnd:(UITextField*)textField{
    if ([textField isEqual:self.textFiled]) {
        if ([[self.dataModel.measurement lowercaseString] isEqualToString:@"kg"]) {

            NSString* text = self.textFiled.text;
            if ([self isPureInt:text]) {
                NSInteger weight = [text integerValue];
                if (weight > 150) {
                    weight = 150;
                }
                self.textFiled.text = [NSString stringWithFormat:@"%zd", weight];
                if (weight <= 0) {
                    self.textFiled.text = @"";
                }
                [ZHSaveDataToFMDB insertDataWithData:self.textFiled.text WithIdentity:@"Weight"];
            } else {
                NSString* weight = [ZHSaveDataToFMDB selectDataWithIdentity:@"Weight"];
                self.textFiled.text = StringNoNull(weight);
                [MBProgressHUD showMessage:@"年龄只能为0-150的整数"];
            }

        } else if ([[self.dataModel.measurement lowercaseString] isEqualToString:@"cm"]) {

            NSString* text = self.textFiled.text;
            if ([self isPureInt:text]) {
                NSInteger height = [text integerValue];
                if (height > 300) {
                    height = 300;
                }
                self.textFiled.text = [NSString stringWithFormat:@"%zd", height];
                if (height <= 0) {
                    self.textFiled.text = @"";
                }
                [ZHSaveDataToFMDB insertDataWithData:self.textFiled.text WithIdentity:@"Height"];
            } else {
                NSString* height = [ZHSaveDataToFMDB selectDataWithIdentity:@"Height"];
                self.textFiled.text = StringNoNull(height);
                [MBProgressHUD showMessage:@"年龄只能为0-300的整数"];
            }
        }
    }
}

- (void)loadData{
    if ([[self.dataModel.measurement lowercaseString] isEqualToString:@"kg"]) {
        NSString* weight = [ZHSaveDataToFMDB selectDataWithIdentity:@"Weight"];
        self.textFiled.text = StringNoNull(weight);
    } else if ([[self.dataModel.measurement lowercaseString] isEqualToString:@"cm"]) {
        NSString* height = [ZHSaveDataToFMDB selectDataWithIdentity:@"Height"];
        self.textFiled.text = StringNoNull(height);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

@end

