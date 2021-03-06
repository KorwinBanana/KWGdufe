//
//  KWIntroduceViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWIntroduceViewController.h"
#import "Utils.h"
#import "KWLoginTableViewController.h"
#import "KWNavigationViewController.h"
#import "KWImageViewCell.h"
#import "KWFlowLayout.h"

#define pageControlHeight 80
static NSString * const ID = @"cell";

@interface KWIntroduceViewController ()<UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,copy) NSArray  *labelArray;

@property (nonatomic,strong) UIView  *introduceView;
@property (nonatomic,strong) UIView  *buttonView;

@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) UIButton  *tryBtn;

//UIScrollView
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *contentList;
@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation KWIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [NSThread sleepForTimeInterval:2.0];  
    [self loadBackground];
    [self loadIntroduceView];
    [self setupScrollView];
//    [self setupIntroduceView];
}

#pragma mark - 初始化背景
- (void)loadBackground {
    //蓝色2E47AC
    self.view.backgroundColor = [Utils colorWithHexString:@"1DB0B8"];
}

- (void)loadIntroduceView {
    //下层VIew
    _buttonView = [[UIView alloc]init];
    _buttonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@80);
    }];
    
    //上层View
    _introduceView = [[UIView alloc]init];
    _introduceView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_introduceView];
    [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(_buttonView.mas_top);
    }];
    [self loadLoginButton];
}

- (void)setupIntroduceView {
    _labelArray = [[NSArray alloc]initWithObjects:@"!",@"Hello",@"World",@"!",@"Hello",nil];
    
    KWFlowLayout *layout = [[KWFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(160, 160);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat marin = ([UIScreen mainScreen].bounds.size.width - 160) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, marin, 0, marin);
    layout.minimumLineSpacing = 50;
    
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KWSCreenH/3, KWSCreenW, KWSCreenH / 3) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor redColor];
    collection.showsVerticalScrollIndicator = NO;
    
    collection.dataSource = self;
    
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([KWImageViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    
    [_introduceView addSubview:collection];
}

- (void)setupScrollView {
    self.contentList = @[@"Introduce1"];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    for (NSUInteger i=0; i<self.contentList.count; ++i) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) * i, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:self.contentList[i]];
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor(scrollView.contentOffset.x - pageWidth/2)/pageWidth + 1;
    self.pageControl.currentPage = page;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageControlHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 2.2*pageControlHeight)];
        NSLog(@"%f",(CGRectGetHeight(self.view.frame) - 2.2*pageControlHeight));
        NSLog(@"%f",CGRectGetWidth(self.view.frame));
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * self.contentList.count, CGRectGetHeight(self.view.frame) - 2.2*pageControlHeight);
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 1.2*pageControlHeight, CGRectGetWidth(self.view.frame), 0.2*pageControlHeight)];
        _pageControl.numberOfPages = self.contentList.count;
        _pageControl.currentPage = 0;
        _pageControl.enabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
    }
    return _pageControl;
}

#pragma mark - 体验登录/登录
- (void)loadLoginButton {
    _loginBtn = [UIButton buttonWithTitle:@"登录" titleColorN:[UIColor whiteColor] titleColorH:[UIColor whiteColor] image:[UIImage imageNamed:@"friendsTrend_login"] hightImage:[UIImage imageNamed:@"friendsTrend_login_click"] target:self action:@selector(pushLoginView)];
    
    [_buttonView addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_buttonView.mas_centerY);
        make.centerX.mas_equalTo(_buttonView.mas_centerX);
    }];
}

- (void)pushLoginView {
    KWLoginTableViewController *loginView = [[KWLoginTableViewController alloc]init];
    KWNavigationViewController *nav1 = [[KWNavigationViewController alloc]initWithRootViewController:loginView];
    [self presentViewController:nav1 animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KWImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.label.text = _labelArray[indexPath.row];
    NSLog(@"%@",_labelArray[indexPath.row]);
    return cell;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
