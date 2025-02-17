//
//  HGChildScrollView.m
//  HGStudent
//
//  Created by DoronXC on 2017/3/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HGChildScrollView.h"
#import "HGShowOneViewController.h"

@interface HGChildScrollView ()<UIScrollViewDelegate>

@property (copy, nonatomic) NSArray *children;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger maxCount;

@property (strong, nonatomic) HGShowOneViewController *vc1;
@property (strong, nonatomic) HGShowOneViewController *vc2;
@property (assign, nonatomic) NSInteger currentVcIndex;
//@property (strong, nonatomic) LoadingView *loadingView;

@end

@implementation HGChildScrollView

- (instancetype)initWithFrame:(CGRect)frame ChildViewControllers:(NSArray *)children MaxCount:(NSInteger)maxCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(self.width * 3, self.height);
        self.delegate = self;
        self.maxCount = maxCount;
        self.children = children;
//        [self setup];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedCityNotification:) name:@"SelectCityNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectTypeNotification:) name:@"ShowSelectTypeNotification" object:nil];
    }
    return self;
}

- (void)setup
{
//    SingleClass *single = [SingleClass sharedInstance];
//    ShowSubViewController *vc1 = self.children[0];
//    vc1.view.frame = CGRectMake(0, 0, self.width, self.height);
//    [self addSubview:vc1.view];
//    self.vc1 = vc1;
//    
//    ShowRequestModel *md = [[ShowRequestModel alloc] init];
//    md.cc = @"0";
//    md.cityid = single.cityId;
//    md.mc = @"0";
//    md.ot = @"0";
//    md.p = @"1";
//    md.ps = @"20";
//    
//    ShowSubViewController *vc2 = self.children[1];
//    vc2.view.frame = CGRectMake(self.width, 0, self.width, self.height);
//    [self addSubview:vc2.view];
//    self.vc2 = vc2;
//    
//    self.loadingView.frame = CGRectMake(0, -114, ScreenWidth, ScreenHeight);
//    [self addSubview:self.loadingView];
//    self.userInteractionEnabled = NO;
//    
//    HXWeakSelf
//    [self.vc1 loadData:md Complete:^{
//        weakSelf.userInteractionEnabled = YES;
//        [weakSelf.loadingView removeFromSuperview];
//    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.currentVcIndex == 1) {
        if (scrollView.contentOffset.x > self.width) {
            self.vc1.view.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
        }else if (scrollView.contentOffset.x < self.width) {
            self.vc1.view.frame = CGRectMake(0, 0, self.width, self.height);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / self.width;
    if (index == self.currentVcIndex) {
        return;
    }
    if (index == 0) {
        if (self.currentIndex > 0) {
            self.currentIndex -= 1;
        }
    }else if (index == 1) {
        if (self.currentIndex == 0) {
            self.currentIndex += 1;
        }else if (self.currentIndex == self.maxCount - 1) {
            self.currentIndex -= 1;
        }
    }else {
        if (self.currentIndex < self.maxCount - 1) {
            self.currentIndex += 1;
        }
    }
    if ([self.myDelegate respondsToSelector:@selector(scrollViewEndSlideWithIndex:)]) {
        [self.myDelegate scrollViewEndSlideWithIndex:self.currentIndex];
    }
}

- (void)scrollViewWithIndex:(NSInteger)index
{
    NSString *mc = [NSString stringWithFormat:@"%ld",index];
    if (index == 9) {
        mc = @"100";
    }else if (index == 10) {
        mc = @"200";
    }
    
    if (index == 0) {
        self.vc1.view.frame = CGRectMake(0, 0, self.width, self.height);
        [self loadData:mc OffsetX:0 viewController:self.vc1];
        self.currentVcIndex = 0;
    }else  if (index != self.maxCount - 1){
        [self loadData:mc OffsetX:self.width viewController:self.vc2];
        self.currentVcIndex = 1;
    }else {
        self.vc1.view.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
        [self loadData:mc OffsetX:self.width * 2 viewController:self.vc1];
        self.currentVcIndex = 2;
    }
    self.currentIndex = index;
}

- (void)loadData:(NSString *)mc OffsetX:(CGFloat)offsetX viewController:(HGShowOneViewController *)vc
{
//    self.loadingView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    [self.getCurrentViewController.view addSubview:self.loadingView];
//    SingleClass *single = [SingleClass sharedInstance];
//    ShowRequestModel *md = [[ShowRequestModel alloc] init];
//    md.EndTime = single.endTime;
//    md.StartTime = single.startTime;
//    md.cc = @"0";
//    md.cityid = single.cityId;
//    md.mc = mc;
//    md.ot = [NSString stringWithFormat:@"%ld",single.ot];
//    md.p = @"1";
//    md.ps = @"20";
//    HXWeakSelf
//    [vc loadData:md Complete:^{
//        [weakSelf.loadingView removeFromSuperview];
//        [weakSelf setContentOffset:CGPointMake(offsetX, 0)];
//    }];
//    [self.vc1.tableView setContentOffset:CGPointMake(0, 0)];
}

- (void)selectedCityNotification:(NSNotification *)notification
{
    [self scrollViewWithIndex:self.currentIndex];
}

- (void)selectTypeNotification:(NSNotification *)notification
{
    [self scrollViewWithIndex:self.currentIndex];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
