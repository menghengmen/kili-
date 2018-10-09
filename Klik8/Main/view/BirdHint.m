#import "BirdHint.h"

@interface BirdHint ()
@property (strong, nonatomic) UIImageView* birdIcon;
@property (strong, nonatomic) UIView* bgView;
@property (strong, nonatomic) UIImageView* bubble;
@property (strong, nonatomic) UILabel* content;
@property (nonatomic, assign) long long hintStartTime;
@end
@implementation BirdHint
- (void)addSubViews{

    UIImageView* birdIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11, 71, 60)];
    [self addSubview:birdIcon];
    birdIcon.image = [UIImage imageNamed:@"img_bird_vine"];
    self.birdIcon = birdIcon;

    UIView* bgView = [[UIView alloc] initWithFrame:CGRectMake(birdIcon.maxX, 0, 200, 50)];
    [self addSubview:bgView];
    self.bgView = bgView;

    UIImageView* bubble = [[UIImageView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:bubble];
    [bubble addAutoresizingMask];
    self.bubble = bubble;

    UILabel* content = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, bgView.width - 20 - 10, bgView.height - 25)];
    [bgView addSubview:content];
    content.numberOfLines = 0;
    self.content = content;

    content.font = [UIFont systemFontOfSize:16];
    [self hint:@"你好,主人"];
}

- (void)hint:(NSString*)text{
    CGFloat width = CurrentScreen_Width - 80 - 60;
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:16] } context:nil].size;
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.borderWidth = 1;
    self.bubble.image = [[UIImage imageNamed:@"bubble1"] stretchableImageWithLeftCapWidth:112 / 4.0 topCapHeight:80 / 4.0 + 5];

    self.content.text = text;
    self.content.size = size;
    self.content.x = 20;
    self.content.y = 10;

    self.bgView.width = size.width + 10 + 20;
    self.bgView.height = size.height + 20;
    if (self.bgView.height < 42)
        self.bgView.height = 42;
    self.height = self.bgView.height;
}

- (void)startAnimation{
    self.x = -self.bgView.maxX;
    self.hintStartTime = [DateTools getCurInterval];
    [UIView animateWithDuration:0.5
        animations:^{
            self.x = 0;
        }
        completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                long long curInterval = [DateTools getCurInterval];
                if (curInterval >= 2 + self.hintStartTime) {
                    [UIView animateWithDuration:0.25
                                     animations:^{
                                         self.x = -self.bgView.maxX;
                                     }];
                }
            });
        }];
}

- (void)endAnimation{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.x = -self.bgView.maxX;
                     }];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubViews];
    self.backgroundColor = [UIColor clearColor];
    self.content.textColor = [UIColor whiteColor];
    self.content.numberOfLines = 0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubViews];
    }
    return self;
}
@end

