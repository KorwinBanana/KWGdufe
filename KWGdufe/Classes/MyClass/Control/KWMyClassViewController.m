//
//  KWMyClassViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMyClassViewController.h"
#import "KWMyClassCollectionCell.h"
#import "KWCollectionViewLayout.h"
#import "KWReusableView.h"
#import "KWReusableView.h"
#import "KWWeekDay.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface KWMyClassViewController ()<UICollectionViewDataSource> {
    UICollectionView *collectionView;
    CGFloat addWidth;
    CGFloat addWidthWeek;
    CGFloat addHeight;
    NSArray *colors;
    NSInteger schoolWeek;
    UIView *bgView;
}

@property (nonatomic,strong) NSArray  *scheduleModel;
@property (nonatomic,strong) KWCollectionViewLayout  *course;

@end

@implementation KWMyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    //设置标题
    self.navigationItem.title = @"课程表";
    
    colors = @[@"#FF8C00",@"#F08080",@"#F08080",@"#BCEE68",@"#B03060",@"#AB82FF",@"#8470FF",@"#87CEFA",@"#76EEC6",@"#66CDAA",@"#4F4F4F"];
    
    //获取第几周
    [self getSchoolWeek];
    
    //申请数据
    [self loadData];
    
    //获取课程展示的宽度
    addWidth= ([UIScreen mainScreen].bounds.size.width-30)/7.0 - 1;
    
    //获取星期的宽度
    addWidthWeek= ([UIScreen mainScreen].bounds.size.width-30)/7.0;
    
    //获取高度
    addHeight = (CGRectGetHeight([UIScreen mainScreen].bounds)-64-30)/9.7;
    
    //设置星期一到星期日和第几周
    [self setWeekAndDays];
    
    //自定义流水布局——用于展示课表位置和大小
    KWCollectionViewLayout *course = [[KWCollectionViewLayout alloc] init];
    self.course = course;
    
    //创建collectionVIew
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    self.course.width = addWidth;
    _course.height = (CGRectGetHeight([UIScreen mainScreen].bounds)-64-30)/9.7;
    
    //创建collectionView视图
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+30, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:_course];
//    bgHeight = CGRectGetHeight([UIScreen mainScreen].bounds)/12;//设置背景格子的高度
    collectionView.dataSource=self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;//取消弹回
    collectionView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    
    //设置格子背景
    UIView *bg = [[UIView alloc]initWithFrame:collectionView.bounds];
    bgView = bg;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.alpha = 0.5;
    [collectionView addSubview:bgView];
    
    [self setGeziBg];
    
    //注册cell
    [collectionView registerClass:[KWMyClassCollectionCell class] forCellWithReuseIdentifier:@"course"];
    [collectionView registerClass:[KWReusableView class] forSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num"];
    [self.view addSubview:collectionView];
}

- (void)setGeziBg
{
    KWWeekDay *flag;
    CGFloat x=37;
    
    for (int j = 0; j<12; j++) {
        x = 37;
        for(int i=1;i<=7;i++)
        {
            x--;
            flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, 0+j*addHeight, addWidthWeek, addHeight)];
            x+=addWidthWeek;
            flag.alpha=0.2;//格子颜色深浅
            [bgView addSubview:flag];
        }
    }
}

- (void)setWeekAndDays{
    NSArray *weekStr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
//    NSArray *arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    
    KWWeekDay *flag;
    CGFloat height = 30;
    CGFloat x=37;
//    NSInteger startWeek = 0;
    flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(0, 64, 37, height)];
    flag.alpha=0.8;
    [flag setDay:[NSString stringWithFormat:@"%ld周",(long)schoolWeek]];
    [self.view addSubview:flag];
    
    for(int i=1;i<=7;i++)
    {
        x--;
        flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, 64, addWidthWeek, height)];
        x+=addWidthWeek;
        flag.alpha=0.8;
        [flag setDay:weekStr[i-1]];
        [self.view addSubview:flag];
    }
}

-(NSArray *)randomArray
{
    //随机数从这里边产生
    NSMutableArray *startArray = [[NSMutableArray alloc] initWithObjects:@0,@1,@2,@3,@4,@5,@6,@7, nil];
    
    //随机数产生结果
    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithCapacity:0];
    //随机数个数
    NSInteger m=8;
    for (int i=0; i<m; i++) {
        int t=arc4random()%startArray.count;
        resultArray[i]=startArray[t];
        startArray[t]=[startArray lastObject]; //为更好的乱序，故交换下位置
        [startArray removeLastObject];
    }
    return resultArray;
}

#pragma mark - 加载数据
- (void)loadData
{
    //创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSString *week = [NSString stringWithFormat:@"%ld",schoolWeek];
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = @"14251101256";
    parements[@"pwd"] = @"yifei520";
    parements[@"stu_time"] = @"2015-2016-2";
    parements[@"week"] = week;
    
    [self getSchoolWeek];
    
    //发送请求
    [mgr POST:@"http://api.wegdufe.com:82/index.php?r=jw/get-schedule" parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"%@",responseObject);
        //        [responseObject writeToFile:@"/Users/k/iOS-KW/project/model.plist" atomically:nil];
        
        NSArray *dicAry = responseObject[@"data"];
        
        //字典数组转模型数组
        _scheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:dicAry];
        self.course.array = _scheduleModel;
        [collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//获取第几周
- (void)getSchoolWeek
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString * dateBeginTime = @"2017-09-04";//开学日期（需要每学期修改）
    NSString *dateNowTime = [df stringFromDate:[NSDate date]];//当前日期;
    NSDate * date1 = [df dateFromString:dateBeginTime];
    NSDate * date2 = [df dateFromString:dateNowTime];
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1]; //date1是前一个时间(早)，date2是后一个时间(晚)
    schoolWeek = (NSInteger)time/604800;
}

#pragma mark - UICollectionViewDataSource
//cell的个数是：课程个数 + 最左边第几节课的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _scheduleModel.count + 12;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView sendSubviewToBack:bgView];//把格子背景放在最底层
    KWMyClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"course" forIndexPath:indexPath];
    cell.model = _scheduleModel[indexPath.row-12];
    cell.name.backgroundColor = [Utils colorWithHexString:@"4F4F4F"];
//    NSLog(@"cell%ld = %@",indexPath.row - 12,NSStringFromCGRect(cell.frame));
    return cell;
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    [collectionView sendSubviewToBack:bgView];//把格子背景放在最底层
    KWReusableView *Tag = [collectionView dequeueReusableSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num" forIndexPath:indexPath];
//    NSLog(@"%@",NSStringFromCGRect(Tag.frame));
    //防止循环利用cell多增加了一行cell
    if (indexPath.row == 12) {
        Tag.self.layer.borderWidth = 0;
        Tag.num.text = NULL;
        return Tag;
    }else {
        Tag.self.layer.borderWidth = 0.5;
        Tag.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        Tag.num.textColor = [UIColor blackColor];//节数颜色
        return Tag;
    }
}

@end
