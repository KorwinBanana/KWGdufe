//
//  KWIntroduceViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWIntroduceViewController.h"
#import "Utils.h"
#import "KWLoginViewController.h"
#import "KWLoginTableViewController.h"
#import "KWNavigationViewController.h"
#import "KWImageViewCell.h"
#import "KWFlowLayout.h"

static NSString * const ID = @"cell";

@interface KWIntroduceViewController ()<UICollectionViewDataSource>

@property (nonatomic,copy) NSArray  *labelArray;

@property (nonatomic,strong) UIView  *introduceView;
@property (nonatomic,strong) UIView  *buttonView;

@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) UIButton  *tryBtn;

@end

@implementation KWIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadBackground];
    [self loadIntroduceView];
    [self setupIntroduceView];
}

#pragma mark - 初始化背景
- (void)loadBackground {
    self.view.backgroundColor = [Utils colorWithHexString:@"2E47AC"];
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
        make.height.equalTo(@100);
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
    
    // Do any additional setup after loading the view, typically from a nib.
    
    //注意：
    //1.创建collectionView必须有布局参数
    //2.cell必须注册
    //3.cell必须自定义，系统cell没有任何子控件
//    _introduceView.backgroundColor = [UIColor whiteColor];
    
    //创建流水布局
    KWFlowLayout *layout = [[KWFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(160, 160);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//方向水平
    CGFloat marin = ([UIScreen mainScreen].bounds.size.width - 160) * 0.5;
    layout.sectionInset = UIEdgeInsetsMake(0, marin, 0, marin);//设置内边距
    layout.minimumLineSpacing = 50;
    
    
    //创建UICollectionView
    UICollectionView *collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, KWSCreenH/3, KWSCreenW, KWSCreenH / 3) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor redColor];
    collection.showsVerticalScrollIndicator = NO;//滚动条不可见
    
    //设置数据源
    collection.dataSource = self;
    
    //注册cell
    [collection registerNib:[UINib nibWithNibName:NSStringFromClass([KWImageViewCell class]) bundle:nil] forCellWithReuseIdentifier:ID];
    //    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ID];
    
    [_introduceView addSubview:collection];
}

#pragma mark - 体验登录/登录
- (void)loadLoginButton {
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:nil action:@selector(pushLoginView) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_buttonView.mas_centerY);
//        make.top.equalTo(_buttonView.mas_top);
        make.right.equalTo(_buttonView.mas_right).with.offset(-20);
    }];
    
    _tryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_tryBtn setTitle:@"体验" forState:UIControlStateNormal];
    [_buttonView addSubview:_tryBtn];
    [_tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_buttonView.mas_centerY);
//        make.top.equalTo(_buttonView.mas_top);
        make.left.equalTo(_buttonView.mas_left).with.offset(20);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
