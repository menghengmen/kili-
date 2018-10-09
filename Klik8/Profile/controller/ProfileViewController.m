#import "ProfileViewController.h"

#import "ProfileOptionThreeTableViewCell.h"
#import "ProfileOptionTwoTableViewCell.h"
#import "ProfilePureTextFileTableViewCell.h"
#import "ProfileTextFileMeasurementTableViewCell.h"
#import "ProfileTextTableViewCell.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (weak, nonatomic) IBOutlet UIImageView* bgImg;
@property (nonatomic, strong) NSMutableArray* dataArr;

@end

@implementation ProfileViewController

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
        NSLog(@"fafa");
        [_dataArr addObject:@"空格行"];
        ProfileTextCellModel* sexModel = [ProfileTextCellModel new];
        sexModel.width = self.view.width - 70 - 20 - 10 - 50;
        sexModel.content = @"您的性别?";
        [_dataArr addObject:sexModel];

        [_dataArr addObject:@"空格行"];
        ProfileOptionTwoCellModel* profileOptionTwoModel = [ProfileOptionTwoCellModel new];
        profileOptionTwoModel.width = self.view.width - 70 - 20 - 15 - 50;
        [profileOptionTwoModel setOption1:@"男" Option2:@"女"];
        [_dataArr addObject:profileOptionTwoModel];

        [_dataArr addObject:@"空格行"];
        ProfileTextCellModel* ageModel = [ProfileTextCellModel new];
        ageModel.width = self.view.width - 70 - 20 - 10 - 50;
        ageModel.content = @"您的年龄?";
        [_dataArr addObject:ageModel];

        [_dataArr addObject:@"空格行"];
        ProfilePureTextFileCellModel* profilePureTextFileModel = [ProfilePureTextFileCellModel new];
        profilePureTextFileModel.textFiled = @"150";
        [_dataArr addObject:profilePureTextFileModel];

        [_dataArr addObject:@"空格行"];
        ProfileTextCellModel* weightModel = [ProfileTextCellModel new];
        weightModel.width = self.view.width - 70 - 20 - 10 - 50;
        weightModel.content = @"您的体重?";
        [_dataArr addObject:weightModel];

        [_dataArr addObject:@"空格行"];
        ProfileTextFileMeasurementCellModel* profileTextFileMeasurementModel = [ProfileTextFileMeasurementCellModel new];
        profileTextFileMeasurementModel.width = self.view.width - 70 - 20 - 15 - 50;
        [profileTextFileMeasurementModel setMeasurement:@"KG"];
        [_dataArr addObject:profileTextFileMeasurementModel];

        [_dataArr addObject:@"空格行"];
        ProfileTextCellModel* heightModel = [ProfileTextCellModel new];
        heightModel.width = self.view.width - 70 - 20 - 10 - 50;
        heightModel.content = @"您的身高?";
        [_dataArr addObject:heightModel];

        [_dataArr addObject:@"空格行"];
        ProfileTextFileMeasurementCellModel* profileTextFileMeasurementModel2 = [ProfileTextFileMeasurementCellModel new];
        profileTextFileMeasurementModel2.width = self.view.width - 70 - 20 - 15 - 50;
        [profileTextFileMeasurementModel2 setMeasurement:@"CM"];
        [_dataArr addObject:profileTextFileMeasurementModel2];

        [_dataArr addObject:@"空格行"];
        ProfileTextCellModel* bellModel = [ProfileTextCellModel new];
        bellModel.width = self.view.width - 70 - 20 - 10 - 50;
        bellModel.content = @"请选择您的提醒铃声?";
        [_dataArr addObject:bellModel];

        [_dataArr addObject:@"空格行"];
        ProfileOptionThreeCellModel* profileOptionThreeModel = [ProfileOptionThreeCellModel new];
        profileOptionThreeModel.width = self.view.width - 70 - 20 - 15 - 50;
        [profileOptionThreeModel setOption1:@"Klik" Option2:@"咕噜" Option3:@"叮咚"];
        [_dataArr addObject:profileOptionThreeModel];
        [_dataArr addObject:@"空格行"];
    }
    return _dataArr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.bgImg addBlurEffectWithAlpha:0.6];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [TabBarAndNavagation setLeftBarButtonItemImageName:@"btn_back" TintColor:[UIColor whiteColor] target:self action:@selector(backAction)];
    [TabBarAndNavagation setBackImage:[UIColor imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]] ForNavagationBar:self];
    [TabBarAndNavagation setShadowImage:[UIColor imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.2]] ForNavagationBar:self];
}
- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - TableViewDelegate实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath{
    id modelObjct = self.dataArr[indexPath.row];
    if ([modelObjct isKindOfClass:[ProfileTextCellModel class]]) {
        ProfileTextTableViewCell* profileTextCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTextTableViewCell"];
        ProfileTextCellModel* model = modelObjct;
        [profileTextCell refreshUI:model];
        return profileTextCell;
    }
    if ([modelObjct isKindOfClass:[ProfileOptionTwoCellModel class]]) {
        ProfileOptionTwoTableViewCell* profileOptionTwoCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileOptionTwoTableViewCell"];
        ProfileOptionTwoCellModel* model = modelObjct;
        [profileOptionTwoCell refreshUI:model];
        return profileOptionTwoCell;
    }
    if ([modelObjct isKindOfClass:[ProfileOptionThreeCellModel class]]) {
        ProfileOptionThreeTableViewCell* profileOptionThreeCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileOptionThreeTableViewCell"];
        ProfileOptionThreeCellModel* model = modelObjct;
        [profileOptionThreeCell refreshUI:model];
        return profileOptionThreeCell;
    }
    if ([modelObjct isKindOfClass:[ProfilePureTextFileCellModel class]]) {
        ProfilePureTextFileTableViewCell* profilePureTextFileCell = [tableView dequeueReusableCellWithIdentifier:@"ProfilePureTextFileTableViewCell"];
        ProfilePureTextFileCellModel* model = modelObjct;
        [profilePureTextFileCell refreshUI:model];
        return profilePureTextFileCell;
    }
    if ([modelObjct isKindOfClass:[ProfileTextFileMeasurementCellModel class]]) {
        ProfileTextFileMeasurementTableViewCell* profileTextFileMeasurementCell = [tableView dequeueReusableCellWithIdentifier:@"ProfileTextFileMeasurementTableViewCell"];
        ProfileTextFileMeasurementCellModel* model = modelObjct;
        [profileTextFileMeasurementCell refreshUI:model];
        return profileTextFileMeasurementCell;
    }
    //随便给一个cell
    UITableViewCell* cell = [UITableViewCell new];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    id modelObjct = self.dataArr[indexPath.row];
    if ([modelObjct isKindOfClass:[ProfileTextCellModel class]]) {
        ProfileTextCellModel* model = modelObjct;
        if (model.size.height + 20 < 42)
            return 42;
        else
            return model.size.height + 20;
    }
    if ([modelObjct isKindOfClass:[ProfileOptionTwoCellModel class]]) {
        ProfileOptionTwoCellModel* model = modelObjct;
        if ([model maxHeight] + 20 < 42)
            return 42;
        else
            return [model maxHeight] + 20;
    }
    if ([modelObjct isKindOfClass:[ProfileOptionThreeCellModel class]]) {
        ProfileOptionThreeCellModel* model = modelObjct;
        if ([model maxHeight] + 20 < 42)
            return 42;
        else
            return [model maxHeight] + 20;
    }
    if ([modelObjct isKindOfClass:[ProfilePureTextFileCellModel class]]) {
        return 42.0f;
    }
    if ([modelObjct isKindOfClass:[ProfileTextFileMeasurementCellModel class]]) {
        ProfileTextFileMeasurementCellModel* model = modelObjct;
        if (model.sizeMeasurement.height + 20 < 42)
            return 42;
        else
            return model.sizeMeasurement.height + 20;
    }
    return 25.0f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

