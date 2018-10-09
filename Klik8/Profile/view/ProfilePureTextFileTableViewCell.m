#import "ProfilePureTextFileTableViewCell.h"

@interface ProfilePureTextFileTableViewCell ()

@property (nonatomic, weak) ProfilePureTextFileCellModel* dataModel;

@property (weak, nonatomic) IBOutlet UIImageView* iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImageView;
@property (weak, nonatomic) IBOutlet UIView* bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bgViewHeight;

@property (weak, nonatomic) IBOutlet UITextField* textFiled;
@end

@implementation ProfilePureTextFileTableViewCell

- (void)refreshUI:(ProfilePureTextFileCellModel*)dataModel{
    _dataModel = dataModel;
    self.textFiled.text = dataModel.textFiled;

    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bgImageView.image = [[UIImage imageNamed:@"bubble2"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.bgViewWidth.constant = 60 + 15 + 20;
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
    self.textFiled.textColor = [UIColor getColor:@"#898888"];
    [self.textFiled addTarget:self action:@selector(textFieldDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)textFieldDidEnd:(UITextField*)textField{
    if ([textField isEqual:self.textFiled]) {
        NSString* text = self.textFiled.text;
        if ([self isPureInt:text]) {
            NSInteger age = [text integerValue];
            if (age > 130) {
                age = 130;
            }
            self.textFiled.text = [NSString stringWithFormat:@"%zd", age];
            if (age <= 0) {
                self.textFiled.text = @"";
            }
            [ZHSaveDataToFMDB insertDataWithData:self.textFiled.text WithIdentity:@"Age"];
        } else {
            NSString* age = [ZHSaveDataToFMDB selectDataWithIdentity:@"Age"];
            self.textFiled.text = StringNoNull(age);
            [MBProgressHUD showMessage:@"年龄只能为0-130的整数"];
        }
    }
}

- (void)loadData{
    NSString* age = [ZHSaveDataToFMDB selectDataWithIdentity:@"Age"];
    self.textFiled.text = StringNoNull(age);
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

