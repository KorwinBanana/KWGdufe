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
#import "KWSelectWeekView.h"
#import "KWWeekDay.h"
#import "Utils.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>

@interface KWMyClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *collectionView;
    CGFloat addWidth;
    NSArray *colors;
    NSInteger schoolWeek;
}
@property (nonatomic,strong) NSMutableArray  *scheduleModel;
@property (nonatomic,strong) KWCollectionViewLayout  *course;
@end

@implementation KWMyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    colors = @[@"#1b83b4",@"#6d9525",@"#c58525",@"#4161b7",@"#af4271",@"#7053ab",@"#60a779",@"#cb5253"];
    
    [self getSchoolWeek];//获取第几周
    [self loadData];
    
    addWidth= ([UIScreen mainScreen].bounds.size.width-30)/7.0;
    
    [self setWeekAndDays];
    
    KWCollectionViewLayout *course = [[KWCollectionViewLayout alloc] init];
    self.view.backgroundColor = [Utils colorWithHexString:@"#FFFFFF"];
    
    course.width = addWidth;
    course.height = (CGRectGetHeight([UIScreen mainScreen].bounds)-64-30)/9.7;
    self.course = course;
    
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+30, CGRectGetWidth([UIScreen mainScreen].bounds),CGRectGetHeight([UIScreen mainScreen].bounds)) collectionViewLayout:course];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerClass:[KWMyClassCollectionCell class] forCellWithReuseIdentifier:@"course"];
    [collectionView registerClass:[KWReusableView class] forSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num"];
    collectionView.bounces = NO;
    [self.view addSubview:collectionView];
}

- (void)getSchoolWeek
{
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString * dateBeginTime = @"2017-09-04";//开学日期
    NSString *dateNowTime = [df stringFromDate:[NSDate date]];//当前日期;
    NSDate * date1 = [df dateFromString:dateBeginTime];
    NSDate * date2 = [df dateFromString:dateNowTime];
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1]; //date1是前一个时间(早)，date2是后一个时间(晚)
    
    NSLog(@"time = %ld", (NSInteger)time/604800);
    schoolWeek = (NSInteger)time/604800;
    
}

- (void)loadData
{
    //创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    NSString *week = [NSString stringWithFormat:@"%ld",schoolWeek];
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = @"14251101256";
    parements[@"pwd"] = @"yifei520";
    parements[@"stu_time"] = @"2016-2017-2";
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

-(void)setWeekAndDays{
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
        flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, 64, addWidth, height)];
        x+=addWidth;
        flag.alpha=0.8;
        [flag setDay:weekStr[i-1]];
        [self.view addSubview:flag];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 31;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    KWMyClassCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"course" forIndexPath:indexPath];
    cell.model = _scheduleModel[indexPath.row-12];
    return cell;
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    KWReusableView *Tag = [collectionView dequeueReusableSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num" forIndexPath:indexPath];
    Tag.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    Tag.num.textColor = [UIColor blackColor];//节数颜色
    return Tag;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
