#import "MainViewController.h"

#import "MainLeftTableViewCell.h"
#import "MainRightTableViewCell.h"
#import "MainRootTableViewCell.h"

#import "AccountViewController.h"
#import "BirdHint.h"
#import "Config.h"
#import "DrinkHintTimes.h"
#import "HadDrinkTimes.h"
#import "SetViewController.h"
#import "SystemShare.h"
#import "SystemSoundIDPlayer.h"
#import "TransitionAnimator.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UIButton* shareBtn;
@property (nonatomic, strong) UIButton* menuBtn;
@property (nonatomic, strong) UIButton* accountBtn;

@property (weak, nonatomic) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSMutableArray* dataArr;

@property (weak, nonatomic) IBOutlet UILabel* todayDrinkCount;
@property (strong, nonatomic) UILabel* score;
@property (weak, nonatomic) IBOutlet UIImageView* apple;
@property (nonatomic, strong) UIImageView* wateringCloud;
@property (nonatomic, strong) UIImageView* wateringAnimate;
@property (nonatomic, strong) BirdHint* bird;
@property (nonatomic, strong) NSTimer* timer;
@end

@implementation MainViewController

- (NSMutableArray*)dataArr{
    if (!_dataArr) {
        _dataArr = [ZHSaveDataToFMDB selectDataWithIdentity:@"MainViewControllerDataArr"];
        if (!_dataArr) {
            _dataArr = [NSMutableArray array];

            MainRootCellModel* mainRootModel = [MainRootCellModel new];
            [_dataArr addObject:mainRootModel];
        }
    }
    return _dataArr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 156, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeScale(1, -1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initActions];
    [self addBlockAction];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshUI];
    [self timeoutDismissFruit];
    self.timer.fireDate = [NSDate distantPast];
}
/**添加全局Block*/
- (void)addBlockAction{
    __weak typeof(self) weakSef = self;
    [ZHBlockSingleCategroy addBlockWithThreeCGFloat:^(CGFloat Float1, CGFloat Float2, CGFloat Float3) {
        [weakSef setFruitType:Float3 withX:Float1 withY:Float2];
    }
                                       WithIdentity:@"GetFruit"];
}
- (void)refreshUI{
    NSInteger drinkCountToday = [[HadDrinkTimes sharedHadDrinkTimes] drinkCountToday];
    NSInteger allTimesCount = [[DrinkHintTimes sharedDrinkHintTimes] allTimesCount];
    if (drinkCountToday > allTimesCount)
        drinkCountToday = allTimesCount;
    self.todayDrinkCount.text = [NSString stringWithFormat:@"%zd/%zd", drinkCountToday, allTimesCount];
}
- (void)initUI{
    [self.wateringCloud rotationAnimationFromValue:0 toValue:-M_PI_2 duration:0.01];
    self.wateringCloud.x = self.view.width - 50;
    self.wateringCloud.y = arc4random() % 100 + 100;

    [self.score setAnchorPoint:CGPointMake(0, 0.5)];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self scrollToTop:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([Config sharedConfig].score > 0)
                [self.bird hint:@"欢迎回来"];
            else
                [self.bird hint:@"你好,主人"];
            [self.bird startAnimation];
        });
    });
}
- (void)grow{

    BOOL shouldAddVineItem = NO;
    BOOL shouldSaveData = NO;
    NSInteger fruitLevels = 0;
    if (self.dataArr.count >= 2) {
        for (NSInteger i = 1; i < self.dataArr.count; i++) {
            id model = self.dataArr[i];
            if ([model isKindOfClass:[MainLeftCellModel class]]) {
                MainLeftCellModel* leftModel = model;
                if ([leftModel addLeverRandom])
                    shouldSaveData = YES;
                if (leftModel.fruitType > 6)
                    fruitLevels++;
            } else if ([model isKindOfClass:[MainRightCellModel class]]) {
                MainRightCellModel* rightModel = model;
                if ([rightModel addLeverRandom])
                    shouldSaveData = YES;
                if (rightModel.fruitType > 6)
                    fruitLevels++;
            }
        }
        //如果有4/5的水果都完全成熟了,就不需要长藤
        if (fruitLevels > (self.dataArr.count - 1) * (4 / 5.0)) {
            shouldAddVineItem = YES;
            shouldSaveData = YES;
        } else { //如果按照上面的4/5来算,基本上很难长高
            NSInteger randomNum = arc4random() % 101;
            if (randomNum > 95)
                shouldAddVineItem = YES;
        }
        [self.tableView reloadData];
    } else {
        shouldAddVineItem = YES;
    }

    if (shouldAddVineItem)
        [self addVinesItem];
    if (shouldSaveData)
        [self saveData];
}
- (void)saveData{
    if (self.dataArr.count > 0) {
        [ZHSaveDataToFMDB insertDataWithData:self.dataArr WithIdentity:@"MainViewControllerDataArr"];
    }
}

/**超时不捡消失果子*/
- (void)timeoutDismissFruit{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        BOOL shouldSaveData = NO;
        if (self.dataArr.count >= 2) {
            for (NSInteger i = 1; i < self.dataArr.count; i++) {
                id model = self.dataArr[i];
                if ([model isKindOfClass:[MainLeftCellModel class]]) {
                    MainLeftCellModel* leftModel = model;
                    if ([leftModel isTimeOutDay])
                        shouldSaveData = YES;
                } else if ([model isKindOfClass:[MainRightCellModel class]]) {
                    MainRightCellModel* rightModel = model;
                    if ([rightModel isTimeOutDay])
                        shouldSaveData = YES;
                }
            }
        }
        if (shouldSaveData) {
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveData];
                [self.tableView reloadData];
            });
        }
    });
}
- (void)addVinesItem{
    NSArray* rightVines = @[ @"img_vine_a_01", @"img_vine_a_02", @"img_vine_a_03" ];
    NSArray* leftVines = @[ @"img_vine_b_01", @"img_vine_b_02", @"img_vine_b_03" ];
    id model = [self.dataArr lastObject];
    if ([model isKindOfClass:[MainRootCellModel class]] || [model isKindOfClass:[MainLeftCellModel class]]) {
        MainRightCellModel* mainRightModel = [MainRightCellModel new];
        mainRightModel.vineImageName = [rightVines objectAtIndex:arc4random() % rightVines.count];
        mainRightModel.fruit = @"";
        [_dataArr addObject:mainRightModel];
        if (_dataArr.count > 0 && _dataArr.count % 8 == 0) {
            mainRightModel.shouldShowCloud = YES;
            mainRightModel.isRandomLeft = arc4random() % 2 == 0;
            mainRightModel.isLargetCloud = arc4random() % 2 == 0;
            mainRightModel.leftCloudMargin = arc4random() % 30 + 25;
            mainRightModel.rightCloudMargin = arc4random() % 15;
        }
    } else if ([model isKindOfClass:[MainRightCellModel class]]) {
        MainLeftCellModel* mainLeftModel = [MainLeftCellModel new];
        mainLeftModel.vineImageName = [leftVines objectAtIndex:arc4random() % rightVines.count];
        mainLeftModel.fruit = @"";
        [_dataArr addObject:mainLeftModel];
        if (_dataArr.count > 0 && _dataArr.count % 8 == 0) {
            mainLeftModel.shouldShowCloud = YES;
            mainLeftModel.isRandomLeft = arc4random() % 2 == 0;
            mainLeftModel.isLargetCloud = arc4random() % 2 == 0;
            mainLeftModel.leftCloudMargin = arc4random() % 15;
            mainLeftModel.rightCloudMargin = arc4random() % 30 + 25;
        }
    }
    [self.tableView reloadData];
    [self scrollToTop:YES];
}
- (void)initActions{
    [self.shareBtn addUITapGestureRecognizerWithTarget:self withAction:@selector(shareAction)];
    [self.menuBtn addUITapGestureRecognizerWithTarget:self withAction:@selector(menuAction)];
    [self.accountBtn addUITapGestureRecognizerWithTarget:self withAction:@selector(accountAction)];
    [self.wateringCloud addUITapGestureRecognizerWithTarget:self withAction:@selector(wateringAction)];
}

- (void)shareAction{
    NSString* textToShare = @"水是生命之源！喝水很简单，但我们总是忘记。“喝水吧”APP趣味实用，推荐给你！http://klik8.slfteam.com/zh";
    UIImage* imageToShare = [UIImage imageNamed:@"img_logo.png"];
    NSURL* urlToShare = [NSURL URLWithString:@"http://klik8.slfteam.com/zh"];

    [SystemShare shareFromVC:self
                 textToShare:textToShare
                imageToShare:imageToShare
                  urlToShare:urlToShare
                  completion:^(BOOL completed){

                  }];
}
- (void)menuAction{
    SetViewController* setVc = (SetViewController*)[TabBarAndNavagation getViewControllerFromStoryBoardWithIdentity:@"SetViewController"];
    setVc.transitioningDelegate = self;
    [self presentViewController:setVc animated:YES completion:nil];
}
- (void)accountAction{
    AccountViewController* setVc = (AccountViewController*)[TabBarAndNavagation getViewControllerFromStoryBoardWithIdentity:@"AccountViewController"];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:setVc];
    nav.transitioningDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)wateringAction{
    //如果此时的喝水次数是否已经达到此刻的最高次数
    if ([[HadDrinkTimes sharedHadDrinkTimes] drinkCountToday] < [[DrinkHintTimes sharedDrinkHintTimes] countBeforeTime:[DateTools getCurDayMinites]]) {
        //        把小鸟提示语收回
        [self.bird endAnimation];
        [self scrollToTop:NO];
        [self wateringBeginAnimate];
    } else {
        //        提示不要频繁喝水
        [self.bird hint:@"主人，太频繁的喝水对胃肠道不好呢"];
        [self.bird startAnimation];
    }
}
- (void)wateringBeginAnimate{
    self.wateringCloud.userInteractionEnabled = NO;
    self.menuBtn.hidden = self.accountBtn.hidden = self.shareBtn.hidden = YES;
    CGFloat y = 72;
    if (self.view.height - (y + self.wateringCloud.height) > self.tableView.contentSize.height + 10)
        y = self.view.height - (self.tableView.contentSize.height + 10) - self.wateringCloud.height;
    [UIView animateWithDuration:0.5
        animations:^{
            [self.wateringCloud rotationAnimationFromValue:-M_PI_2 toValue:0 duration:0.5];
            self.wateringCloud.transform = CGAffineTransformScale(self.wateringCloud.transform, 1.5, 1.5);
            self.wateringCloud.x = self.view.width * 3 / 4 - 109 / 2.0;
            self.wateringCloud.y = y;
        }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5
                animations:^{
                    self.wateringCloud.transform = CGAffineTransformIdentity;
                    self.wateringCloud.frame = CGRectMake((self.view.width - 109) / 2.0, y, 109, 109);
                }
                completion:^(BOOL finished) {
                    [self watering];
                }];
        }];
}
- (void)watering{
    self.wateringAnimate.hidden = NO;
    self.wateringAnimate.frame = self.wateringCloud.frame;
    [self.wateringAnimate startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self wateringEndAnimate];
    });
}
- (void)wateringEndAnimate{
    self.wateringAnimate.hidden = YES;
    [self.wateringAnimate stopAnimating];

    [self.wateringCloud rotationAnimationDuration:0.5 repeatCount:0];
    [UIView animateWithDuration:0.5
        animations:^{
            self.wateringCloud.transform = CGAffineTransformScale(self.wateringCloud.transform, 0.3, 0.3);
            self.wateringCloud.centerX = self.view.width / 2.0;
            self.wateringCloud.y -= 30;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [UIView animateWithDuration:1
                    animations:^{
                        [self.wateringCloud rotationAnimationFromValue:0 toValue:M_PI_2 + M_PI duration:1];
                        self.wateringCloud.frame = CGRectMake(self.view.width - 50, arc4random() % 100 + 100, 109, 109);
                    }
                    completion:^(BOOL finished) {
                        self.wateringCloud.userInteractionEnabled = YES;
                        [[HadDrinkTimes sharedHadDrinkTimes] addDrinkToday];
                        [self addScore:1];
                        [self refreshUI];
                        self.menuBtn.hidden = self.accountBtn.hidden = self.shareBtn.hidden = NO;
                        [self grow];
                    }];
            });
        }];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController*)presented presentingController:(UIViewController*)presenting sourceController:(UIViewController*)source{
    return [self generateAnimatorWithPresenting:YES forVC:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController*)dismissed{
    return [self generateAnimatorWithPresenting:NO forVC:self];
}

- (TransitionAnimator*)generateAnimatorWithPresenting:(BOOL)presenting forVC:(UIViewController*)viewController{
    TransitionAnimator* animator = [[TransitionAnimator alloc] init];
    animator.presenting = presenting;
    animator.duration = 0.25;
    animator.originFrame = [self.view convertRect:self.view.frame toView:nil];
    if ([viewController isKindOfClass:[UINavigationController class]] || viewController == nil) {
        CGFloat margin = 50;
        CGFloat height = margin * self.view.height / self.view.width;
        animator.originFrame = CGRectMake(margin, height, self.view.width - 2 * margin, self.view.height - 2 * height);
    }
    return animator;
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
    if ([modelObjct isKindOfClass:[MainRootCellModel class]]) {
        MainRootTableViewCell* mainRootCell = [tableView dequeueReusableCellWithIdentifier:@"MainRootTableViewCell"];
        MainRootCellModel* model = modelObjct;
        [mainRootCell refreshUI:model];
        return mainRootCell;
    }
    if ([modelObjct isKindOfClass:[MainLeftCellModel class]]) {
        MainLeftTableViewCell* mainLeftCell = [tableView dequeueReusableCellWithIdentifier:@"MainLeftTableViewCell"];
        MainLeftCellModel* model = modelObjct;
        [mainLeftCell refreshUI:model];
        return mainLeftCell;
    }
    if ([modelObjct isKindOfClass:[MainRightCellModel class]]) {
        MainRightTableViewCell* mainRightCell = [tableView dequeueReusableCellWithIdentifier:@"MainRightTableViewCell"];
        MainRightCellModel* model = modelObjct;
        [mainRightCell refreshUI:model];
        return mainRightCell;
    }
    //随便给一个cell
    UITableViewCell* cell = [UITableViewCell new];
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    id modelObjct = self.dataArr[indexPath.row];
    if ([modelObjct isKindOfClass:[MainRootCellModel class]]) {
        return tableView.width * 129 / 360;
    }
    if ([modelObjct isKindOfClass:[MainLeftCellModel class]]) {
        return 62.0f;
    }
    if ([modelObjct isKindOfClass:[MainRightCellModel class]]) {
        return 62.0f;
    }
    return 44.0f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIButton*)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _shareBtn.frame = CGRectMake(self.view.width - 13 - 35, 15 + 20, 35, 35);
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share"] forState:(UIControlStateNormal)];
        [self.view addSubview:_shareBtn];
    }
    return _shareBtn;
}
- (UIButton*)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _menuBtn.frame = CGRectMake(12, self.view.height - 12 - 60, 60, 60);
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"btn_menu"] forState:(UIControlStateNormal)];
        [self.view addSubview:_menuBtn];
    }
    return _menuBtn;
}
- (UIButton*)accountBtn{
    if (!_accountBtn) {
        _accountBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _accountBtn.frame = CGRectMake(self.view.width - 12 - 37, self.view.height - 12 - 37, 37, 37);
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"btn_account"] forState:(UIControlStateNormal)];
        [self.view addSubview:_accountBtn];
    }
    return _accountBtn;
}
- (BirdHint*)bird{
    if (!_bird) {
        _bird = [[BirdHint alloc] initWithFrame:CGRectMake(0, 113, self.view.width, 80)];
        [self.view addSubview:_bird];
    }
    return _bird;
}
- (NSTimer*)timer{
    if (!_timer) {
        [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updataHint) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
    return _timer;
}
- (void)updataHint{
    if ([[DateTools getCurSecondString] integerValue] == 0) {
        if ([[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:[DateTools getCurDayMinites]]) {
            [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] play];
            [self.bird hint:@"主人，该喝水了"];
            [self.bird startAnimation];
        }
    }
}
- (UILabel*)score{
    if (!_score) {
        _score = [[UILabel alloc] initWithFrame:CGRectMake(50, 20 + 33 - 9, 120, 18)];
        _score.textColor = [UIColor whiteColor];
        _score.font = [UIFont systemFontOfSize:15];
        _score.text = [Config sharedConfig].scoreNumString;
        [self.view addSubview:_score];
        [self.view bringSubviewToFront:_score];
    }
    return _score;
}
- (UIImageView*)getFruit{
    UIImageView* fruit = [[UIImageView alloc] initWithFrame:CGRectMake(self.apple.centerX + 12 / 2.0, self.apple.centerY + 12 / 2.0, 12, 12)];
    [self.view addSubview:fruit];
    return fruit;
}
- (void)setFruitType:(NSInteger)fruitType withX:(CGFloat)x withY:(CGFloat)y{
    if (fruitType < 4) {
        return;
    }
    UIImageView* fruit = [self getFruit];
    fruit.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_fruit_%02zd", fruitType]];
    switch (fruitType) {
    case 1:
        fruit.width = fruit.height = 8;
        break;
    case 2:
        fruit.width = fruit.height = 10;
        break;
    case 3:
    case 4:
    case 5:
    case 6:
        fruit.width = fruit.height = 15;
        break;
    case 7:
        fruit.width = fruit.height = 28;
        break;
    }
    fruit.x = x;
    fruit.y = y;
    [self setScoreHintType:fruitType withX:x withY:y withWidth:fruit.width withHeight:fruit.height];
    [UIView animateWithDuration:0.3
        animations:^{
            fruit.centerX = self.apple.centerX + 12 / 2.0;
            fruit.centerY = self.apple.centerY + 12 / 2.0;
        }
        completion:^(BOOL finished) {
            [fruit removeFromSuperview];
        }];
}
- (void)setScoreHintType:(NSInteger)fruitType withX:(CGFloat)x withY:(CGFloat)y withWidth:(CGFloat)w withHeight:(CGFloat)h{
    if (fruitType < 4) {
        return;
    }
    UILabel* score = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, 10)];
    [self.view addSubview:score];
    score.textAlignment = NSTextAlignmentCenter;
    score.textColor = [UIColor redColor];
    score.font = [UIFont systemFontOfSize:10];
    switch (fruitType) {
    case 4:
        score.text = @"+2";
        [self addScore:2];
        break;
    case 5:
        score.text = @"+4";
        [self addScore:4];
        break;
    case 6:
        score.text = @"+8";
        [self addScore:8];
        break;
    case 7:
        score.text = @"+15";
        [self addScore:15];
        break;
    }

    [UIView animateWithDuration:0.3
        animations:^{
            score.centerY -= 30;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [score removeFromSuperview];
            });
        }];
}
- (UIImageView*)wateringCloud{
    if (!_wateringCloud) {
        _wateringCloud = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 109) / 2.0, 72, 109, 109)];
        _wateringCloud.image = [UIImage imageNamed:@"img_rain_cloud1"];
        [self.view addSubview:_wateringCloud];
    }
    return _wateringCloud;
}
- (UIImageView*)wateringAnimate{
    if (!_wateringAnimate) {
        _wateringAnimate = [[UIImageView alloc] initWithFrame:self.wateringCloud.frame];
        _wateringAnimate.animationImages = @[ [UIImage imageNamed:@"img_rain_cloud1"], [UIImage imageNamed:@"img_rain_cloud2"], [UIImage imageNamed:@"img_rain_cloud"] ];
        [self.view addSubview:_wateringAnimate];
        _wateringAnimate.animationDuration = 0.5;
        _wateringAnimate.animationRepeatCount = MAXFLOAT;
        _wateringAnimate.hidden = YES;
    }
    return _wateringAnimate;
}

/**添加分数*/
- (void)addScore:(NSInteger)score{
    NSInteger oldScore = [self.score.text integerValue];
    oldScore += score;
    [[Config sharedConfig] setScore:oldScore];
    self.score.text = [NSString stringWithFormat:@"%zd", oldScore];
    [UIView animateWithDuration:0.25
        animations:^{
            [self.score setTransform:CGAffineTransformScale(self.score.transform, 2, 2)];
            self.score.textColor = [UIColor redColor];
        }
        completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.score.textColor = [UIColor whiteColor];
                                 [self.score setTransform:CGAffineTransformIdentity];
                             }];
        }];
}
- (void)scrollToTop:(BOOL)animate{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0] atScrollPosition:(UITableViewScrollPositionTop)animated:animate];
}

@end
