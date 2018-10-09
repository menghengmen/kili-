//
//  SetViewController.m
//  Klik8
//
//  Created by mac on 17/5/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "SetViewController.h"
#import "SetTableViewCell.h"
#import "AccountViewController.h"
#import "TransitionAnimator.h"
#import "ProfileViewController.h"
#import "SystemSoundIDPlayer.h"
#import "DrinkHintTimes.h"
#import "NSTimer+Block.h"

@interface SetViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate>

@property (nonatomic,strong)NSIndexPath *curSelectIndex;
@property (nonatomic,strong)NSIndexPath *willChangeSelectIndex;

@property (nonatomic,strong)UIButton *menuBtn;
@property (nonatomic,strong)UIButton *accountBtn;
@property (nonatomic,strong)UIImageView *moveBall;//移动的小球,用于添加,编辑,删除
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *mote;
@property (weak, nonatomic) IBOutlet UIButton *refresh;
@property (weak, nonatomic) IBOutlet UIButton *personal;
@property (weak, nonatomic) IBOutlet UIImageView *needDrinkTimeBgImg;
@property (weak, nonatomic) IBOutlet UIImageView *needDrinkTimeBird;
@property (weak, nonatomic) IBOutlet UIImageView *alertBird;
@property (weak, nonatomic) IBOutlet UILabel *needDrinkTimeCount;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIButton *needRestore;
@property (weak, nonatomic) IBOutlet UIButton *noNeedRestore;
@property (weak, nonatomic) IBOutlet UIImageView *editStatusImg;
@property (nonatomic,assign)BOOL isMote;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)BOOL isScroll;
@end

@implementation SetViewController

- (void)setIsMote:(BOOL)isMote{
    _isMote=isMote;
    if (isMote) {
        [self.mote setBackgroundImage:[UIImage imageNamed:@"btn_static_music"] forState:(UIControlStateNormal)];
        [ZHSaveDataToFMDB insertDataWithData:@"YES" WithIdentity:@"isMote"];
    }else{
        [self.mote setBackgroundImage:[UIImage imageNamed:@"btn_music"] forState:(UIControlStateNormal)];
        [ZHSaveDataToFMDB insertDataWithData:@"NO" WithIdentity:@"isMote"];
    }
}

- (NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr=[NSMutableArray array];
        NSInteger timeCount=0;
        for (NSInteger i=0; i<24*6; i++) {
            SetModel *model=[[SetModel alloc]initWithMinutes:timeCount];
            [_dataArr addObject:model];
            timeCount+=10;
        }
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initActions];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor clearColor];
    [self.bgImg addBlurEffectWithAlpha:0.6];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    [self initUI];
    [self initData];
    [self refreshUI];
}

- (void)initUI{
    self.alertView.hidden=YES;
    self.alertBird.hidden=YES;
    [self.alertView cornerRadiusWithFloat:15 borderColor:[UIColor getColor:@"#eedd11"] borderWidth:1];
    self.alertView.backgroundColor=[UIColor getColor:@"#465055"];
    [self.editStatusImg cornerRadiusWithFloat:30];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[DateTools getCurDayMinites]/10 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
}

- (void)initData{
    //是否静音
    NSString *isMote=[ZHSaveDataToFMDB selectDataWithIdentity:@"isMote"];
    if ([isMote isEqualToString:@"YES"]) {
        self.isMote=YES;
    }else{
        self.isMote=NO;
    }
}

- (void)refreshUI{
    self.needDrinkTimeCount.text=[NSString stringWithFormat:@"%zd",[[DrinkHintTimes sharedDrinkHintTimes] allTimesCount]];
}

#pragma mark - TableViewDelegate实现的方法:
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count*2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id modelObjct=self.dataArr[indexPath.row%self.dataArr.count];
    if ([modelObjct isKindOfClass:[SetModel class]]){
        SetTableViewCell *setCell=[tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell"];
        SetModel *model=modelObjct;
        [setCell refreshUI:model];
        
        if (![self isSelectIndex:indexPath]) {
            setCell.backgroundColor=[UIColor clearColor];
        }
        return setCell;
    }
    //随便给一个cell
    UITableViewCell *cell=[UITableViewCell new];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id modelObjct=self.dataArr[indexPath.row%self.dataArr.count];
    if ([modelObjct isKindOfClass:[SetModel class]]){
        return 13.0f;
    }
    return 44.0f;
}

- (void)initActions{
    [self.menuBtn addUITapGestureRecognizerWithTarget:self withAction:@selector(menuAction)];
    [self.accountBtn addUITapGestureRecognizerWithTarget:self withAction:@selector(accountAction)];
    [self.mote addUITapGestureRecognizerWithTarget:self withAction:@selector(moteAction)];
    [self.refresh addUITapGestureRecognizerWithTarget:self withAction:@selector(refreshAction)];
    [self.personal addUITapGestureRecognizerWithTarget:self withAction:@selector(personalAction)];
    [self.needRestore addUITapGestureRecognizerWithTarget:self withAction:@selector(needRestoreAction)];
    [self.noNeedRestore addUITapGestureRecognizerWithTarget:self withAction:@selector(noNeedRestoreAction)];
    [self.needDrinkTimeBgImg addUILongPressGestureRecognizerWithTarget:self withAction:@selector(addDrinkTimeLongPressAction:) withMinimumPressDuration:0.25];
    [self.tableView addUILongPressGestureRecognizerWithTarget:self withAction:@selector(removeDrinkTimeLongPressAction:) withMinimumPressDuration:0.25];
}

- (void)menuAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accountAction{
    AccountViewController *setVc=(AccountViewController *)[TabBarAndNavagation getViewControllerFromStoryBoardWithIdentity:@"AccountViewController"];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:setVc];
    nav.transitioningDelegate=self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)moteAction{
    self.isMote=!self.isMote;
    if (!self.isMote) {
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] play];
    }
    if (self.isMote) {
        [[DrinkHintTimes sharedDrinkHintTimes] cancelLocalNotification];
    }else{
        [[DrinkHintTimes sharedDrinkHintTimes] registerLocalNotification];
    }
}

- (void)refreshAction{
    self.alertBird.alpha=self.alertView.alpha=0;
    self.needDrinkTimeBird.alpha=self.needDrinkTimeBgImg.alpha=self.needDrinkTimeCount.alpha=1;
    [UIView animateWithDuration:0.15 animations:^{
        self.alertBird.alpha=self.alertView.alpha=1;
        self.needDrinkTimeBird.alpha=self.needDrinkTimeBgImg.alpha=self.needDrinkTimeCount.alpha=0;
    }completion:^(BOOL finished) {
        self.alertView.hidden=self.alertBird.hidden=NO;
        self.needDrinkTimeBird.hidden=self.needDrinkTimeBgImg.hidden=self.needDrinkTimeCount.hidden=YES;
    }];
}

- (void)personalAction{
    ProfileViewController *profileVc=(ProfileViewController *)[TabBarAndNavagation getViewControllerFromStoryBoardWithIdentity:@"ProfileViewController"];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:profileVc];
    nav.transitioningDelegate=self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)needRestoreAction{
    [[DrinkHintTimes sharedDrinkHintTimes]reset];
    [self.dataArr removeAllObjects];
    self.dataArr=nil;
    [self hideAlert];
    [self refreshUI];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[DateTools getCurDayMinites]/10 inSection:0] atScrollPosition:(UITableViewScrollPositionMiddle) animated:NO];
}

- (void)noNeedRestoreAction{
    [self hideAlert];
}

- (void)hideAlert{
    self.alertBird.alpha=self.alertView.alpha=1;
    self.needDrinkTimeBird.alpha=self.needDrinkTimeBgImg.alpha=self.needDrinkTimeCount.alpha=0;
    [UIView animateWithDuration:0.15 animations:^{
        self.alertBird.alpha=self.alertView.alpha=0;
        self.needDrinkTimeBird.alpha=self.needDrinkTimeBgImg.alpha=self.needDrinkTimeCount.alpha=1;
    }completion:^(BOOL finished) {
        self.alertView.hidden=self.alertBird.hidden=YES;
        self.needDrinkTimeBird.hidden=self.needDrinkTimeBgImg.hidden=self.needDrinkTimeCount.hidden=NO;
    }];
}

//长按后触发该方法(准备添加喝水提示时间点)
- (void)addDrinkTimeLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([[DrinkHintTimes sharedDrinkHintTimes] allTimesCount]>=12) {
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint=[gestureRecognizer locationInView:self.view];
        self.moveBall.center=CGPointMake(touchPoint.x, touchPoint.y-60);
        [self.moveBall bringSubviewToFront:self.view];
        self.moveBall.hidden=NO;
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] vibrate];
        self.editStatusImg.backgroundColor=[[UIColor getColor:@"00ffff"] colorWithAlphaComponent:0.1];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint=[gestureRecognizer locationInView:self.view];
        [self movingWithCenterPoint:CGPointMake(touchPoint.x, touchPoint.y-60)];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded||[gestureRecognizer state] == UIGestureRecognizerStateCancelled) {
        [self moveEnd];
        _isScroll=NO;
    }
}

- (void)movingWithCenterPoint:(CGPoint)center{
    self.moveBall.center=center;
    //判断小球是否移进了去了TableView
    if(CGRectContainsPoint(self.tableView.frame, center)){
        [self cancleShowSelectCell];
        [self shouldScrollTableViewWithCenterPoint:center];
        CGPoint inTableViewPoint=CGPointMake(center.x-self.tableView.x, center.y-self.tableView.y+[self modHeight]);
        NSIndexPath *selectIndex=[self.tableView indexPathForRowAtPoint:inTableViewPoint];
        selectIndex=[NSIndexPath indexPathForRow:selectIndex.row+[self topCellRow] inSection:selectIndex.section];
        UITableViewCell *selectCell=[self.tableView cellForRowAtIndexPath:selectIndex];
        if (selectCell) {
            selectCell.backgroundColor=[[UIColor getColor:@"#ffffff"] colorWithAlphaComponent:0.3];
        }
        self.curSelectIndex=selectIndex;
    }else{
        [self cancleShowSelectCell];
        self.curSelectIndex=nil;
        _isScroll=NO;
    }
}
- (void)moveEnd{
    BOOL isAddDrinkTime=[self addDrinkTime];
    [self cancleShowSelectCell];
    if (isAddDrinkTime) {
        self.moveBall.hidden=YES;
    }else{
        [UIView animateWithDuration:0.15 animations:^{
            self.moveBall.center=CGPointMake(self.needDrinkTimeBgImg.centerX+12/2.0, self.needDrinkTimeBgImg.centerY+12/2.0);
        }completion:^(BOOL finished) {
            self.moveBall.hidden=YES;
        }];
    }
    self.editStatusImg.backgroundColor=[UIColor clearColor];
}
- (BOOL)addDrinkTime{
    if (self.curSelectIndex) {
        if (![[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:(self.curSelectIndex.row%self.dataArr.count)*10]) {
            [[DrinkHintTimes sharedDrinkHintTimes] insertTime:(self.curSelectIndex.row%self.dataArr.count)*10];
            [self refreshUI];
            [self.dataArr removeAllObjects];
            self.dataArr=nil;
            [self.tableView reloadData];
            return YES;
        }
    }
    return NO;
}
- (void)removeOrEditDrinkTime{
    if (self.willChangeSelectIndex) {
        if (self.curSelectIndex) {
            if ([[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:(self.curSelectIndex.row%self.dataArr.count)*10]) {
                [[DrinkHintTimes sharedDrinkHintTimes] removeTime:(self.curSelectIndex.row%self.dataArr.count)*10];
                [[DrinkHintTimes sharedDrinkHintTimes] insertTime:(self.willChangeSelectIndex.row%self.dataArr.count)*10];
                [self refreshUI];
                [self.dataArr removeAllObjects];
                self.dataArr=nil;
                [self.tableView reloadData];
            }
        }
    }else{
        if (self.curSelectIndex) {
            if ([[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:(self.curSelectIndex.row%self.dataArr.count)*10]) {
                [[DrinkHintTimes sharedDrinkHintTimes] removeTime:(self.curSelectIndex.row%self.dataArr.count)*10];
                [self refreshUI];
                [self.dataArr removeAllObjects];
                self.dataArr=nil;
                [self.tableView reloadData];
            }
        }
    }
}
- (void)cancleShowSelectCell{
    if (self.curSelectIndex) {
        UITableViewCell *curSelectCell=[self.tableView cellForRowAtIndexPath:self.curSelectIndex];
        if (curSelectCell) {
            curSelectCell.backgroundColor=[UIColor clearColor];
        }
    }
}
- (void)cancleShowWillSelectCell{
    if (self.willChangeSelectIndex) {
        UITableViewCell *curSelectCell=[self.tableView cellForRowAtIndexPath:self.willChangeSelectIndex];
        if (curSelectCell) {
            if (self.curSelectIndex) {
                if (self.curSelectIndex.row==self.willChangeSelectIndex.row&&self.curSelectIndex.section==self.willChangeSelectIndex.section) {
                    curSelectCell.backgroundColor=[[UIColor getColor:@"#ffffff"] colorWithAlphaComponent:0.3];
                    return;
                }
            }
            curSelectCell.backgroundColor=[UIColor clearColor];
        }
    }
}

- (void)removeDrinkTimeLongPressAction:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([[DrinkHintTimes sharedDrinkHintTimes] allTimesCount]<=0) {
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (![self isCanEditOrDeleteWithGestureRecognizer:gestureRecognizer]) {
            return;
        }
        [self.moveBall bringSubviewToFront:self.view];
        self.moveBall.hidden=NO;
        [[SystemSoundIDPlayer sharedSystemSoundIDPlayer] vibrate];
        self.editStatusImg.backgroundColor=[[UIColor getColor:@"00ffff"] colorWithAlphaComponent:0.1];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint=[gestureRecognizer locationInView:self.view];
        [self movingTheEditMoveBallWithCenterPoint:CGPointMake(touchPoint.x, touchPoint.y-60)];
    }
    else if ([gestureRecognizer state] == UIGestureRecognizerStateEnded||[gestureRecognizer state] == UIGestureRecognizerStateCancelled) {
        [self moveEndEditMoveBall];
        _isScroll=NO;
    }
}
- (void)moveEndEditMoveBall{
    if (self.moveBall.hidden) {
        return;
    }
    [self removeOrEditDrinkTime];
    [self cancleShowSelectCell];
    [self cancleShowWillSelectCell];
    if (!self.willChangeSelectIndex) {
        [UIView animateWithDuration:0.15 animations:^{
            self.moveBall.center=CGPointMake(self.needDrinkTimeBgImg.centerX+12/2.0, self.needDrinkTimeBgImg.centerY+12/2.0);
        }completion:^(BOOL finished) {
            self.moveBall.hidden=YES;
        }];
    }else{
        self.moveBall.hidden=YES;
    }
    self.editStatusImg.backgroundColor=[UIColor clearColor];
}
//(准备删除或交换喝水提示时间点)
- (void)movingTheEditMoveBallWithCenterPoint:(CGPoint)center{
    if (self.moveBall.hidden) {
        return;
    }
    self.moveBall.center=center;
    //判断小球是否移进了去了TableView
    if(CGRectContainsPoint(self.tableView.frame, center)){
        [self cancleShowWillSelectCell];
        [self shouldScrollTableViewWithCenterPoint:center];
        CGPoint inTableViewPoint=CGPointMake(center.x-self.tableView.x, center.y-self.tableView.y+[self modHeight]);
        NSIndexPath *willChangeSelectIndex=[self.tableView indexPathForRowAtPoint:inTableViewPoint];
        willChangeSelectIndex=[NSIndexPath indexPathForRow:willChangeSelectIndex.row+[self topCellRow] inSection:willChangeSelectIndex.section];
        UITableViewCell *willChangeSelectCell=[self.tableView cellForRowAtIndexPath:willChangeSelectIndex];
        if (willChangeSelectCell) {
            willChangeSelectCell.backgroundColor=[[UIColor getColor:@"#32454d"] colorWithAlphaComponent:0.3];
        }
        self.willChangeSelectIndex=willChangeSelectIndex;
    }else{
        [self cancleShowWillSelectCell];
        self.willChangeSelectIndex=nil;
        _isScroll=NO;
    }
}

- (BOOL)isCanEditOrDeleteWithGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint touchPoint=[gestureRecognizer locationInView:self.tableView];
    CGPoint inTableViewPoint=CGPointMake(touchPoint.x, touchPoint.y);
    NSIndexPath *selectIndex=[self.tableView indexPathForRowAtPoint:inTableViewPoint];
    if (![[DrinkHintTimes sharedDrinkHintTimes] isExsitTime:(selectIndex.row%self.dataArr.count)*10]) {
        return NO;
    }
    UITableViewCell *selectCell=[self.tableView cellForRowAtIndexPath:selectIndex];
    if (selectCell) {
        selectCell.backgroundColor=[[UIColor getColor:@"#ffffff"] colorWithAlphaComponent:0.3];
        self.moveBall.center=CGPointMake(touchPoint.x+self.tableView.x, selectCell.centerY-40-self.tableView.contentOffset.y);
    }
    self.curSelectIndex=selectIndex;
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x,self.tableView.contentOffset.y+60) animated:YES];
    return YES;
}

- (BOOL)shouldScrollTableViewWithCenterPoint:(CGPoint)center{
    _isScroll=YES;
    if (center.y<=13*3+self.tableView.y&&center.y>=self.tableView.y) {
        [self scrollTableViewUp];
        return YES;
    }
    if (center.y<=self.tableView.height+self.tableView.y&&center.y>=self.tableView.height+self.tableView.y-13*3) {
        [self scrollTableViewDown];
        return YES;
    }
    _isScroll=NO;
    return NO;
}
- (void)scrollTableViewUp{
    if (_isScroll) {
        if (!self.timer) {
            self.timer=[NSTimer scheduledTimerWithTimeInterval:0.15 block:^(NSTimer * _Nonnull timer) {
                if (!_isScroll) {
                    self.timer.fireDate=[NSDate distantFuture];
                    self.timer=nil;
                    return;
                }
                [UIView animateWithDuration:0.15 animations:^{
                    if (self.tableView.contentOffset.y>13) {
                        self.tableView.contentOffset=CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y-13);
                    }
                }];
            } repeats:YES];
            self.timer.fireDate=[NSDate distantPast];
        }
    }else{
        self.timer.fireDate=[NSDate distantFuture];
        self.timer=nil;
    }
}
- (void)scrollTableViewDown{
    if (_isScroll) {
        if (!self.timer) {
            self.timer=[NSTimer scheduledTimerWithTimeInterval:0.15 block:^(NSTimer * _Nonnull timer) {
                if (!_isScroll) {
                    self.timer.fireDate=[NSDate distantFuture];
                    self.timer=nil;
                    return;
                }
                [UIView animateWithDuration:0.15 animations:^{
                    if (self.tableView.contentOffset.y+13+self.tableView.height<self.tableView.contentSize.height) {
                        self.tableView.contentOffset=CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y+13);
                    }
                }];
            } repeats:YES];
            self.timer.fireDate=[NSDate distantPast];
        }
    }else{
        self.timer.fireDate=[NSDate distantFuture];
        self.timer=nil;
    }
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [self generateAnimatorWithPresenting:YES forVC:presented];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [self generateAnimatorWithPresenting:NO forVC:self];
}

- (TransitionAnimator *)generateAnimatorWithPresenting:(BOOL)presenting forVC:(UIViewController *)viewController{
    TransitionAnimator *animator = [[TransitionAnimator alloc] init];
    animator.presenting = presenting;
    animator.duration=0.25;
    animator.originFrame = [self.view convertRect:self.view.frame toView:nil];
    if ([viewController isKindOfClass:[UINavigationController class]]||viewController==nil) {
        CGFloat margin=50;
        CGFloat height=margin*self.view.height/self.view.width;
        animator.originFrame = CGRectMake(margin, height, self.view.width-2*margin, self.view.height-2*height);
    }
    return animator;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
        _menuBtn.frame=CGRectMake(12, self.view.height-12-60, 60, 60);
        [_menuBtn setBackgroundImage:[UIImage imageNamed:@"btn_menu_2"] forState:(UIControlStateNormal)];
        [self.view addSubview:_menuBtn];
    }
    return _menuBtn;
}
- (UIButton *)accountBtn{
    if (!_accountBtn) {
        _accountBtn=[UIButton buttonWithType:(UIButtonTypeSystem)];
        _accountBtn.frame=CGRectMake(self.view.width-12-37, self.view.height-12-37, 37, 37);
        [_accountBtn setBackgroundImage:[UIImage imageNamed:@"btn_account"] forState:(UIControlStateNormal)];
        [self.view addSubview:_accountBtn];
    }
    return _accountBtn;
}
- (UIImageView *)moveBall{
    if (!_moveBall) {
        _moveBall=[[UIImageView alloc]initWithFrame:CGRectMake(self.needDrinkTimeBgImg.centerX+12/2.0, self.needDrinkTimeBgImg.centerY+12/2.0, 12, 12)];
        _moveBall.image=[UIImage imageNamed:@"img_water_polo_s"];
        [self.view addSubview:_moveBall];
        _moveBall.hidden=YES;
    }
    return _moveBall;
}

#pragma mark 辅助函数
- (NSInteger)topCellRow{
    return self.tableView.contentOffset.y/13.0;
}
/**最顶部的那个Cell的偏移量*/
- (CGFloat)modHeight{
    NSInteger row=self.tableView.contentOffset.y/13;
    return self.tableView.contentOffset.y-(int)(row)*13;
}
- (BOOL)isSelectIndex:(NSIndexPath *)indexPath{
    if (self.curSelectIndex) {
        if (self.curSelectIndex.row==indexPath.row&&self.curSelectIndex.section==indexPath.section) {
            return YES;
        }
    }
    if (self.willChangeSelectIndex) {
        if (self.willChangeSelectIndex.row==indexPath.row&&self.willChangeSelectIndex.section==indexPath.section) {
            return YES;
        }
    }
    return NO;
}

@end
