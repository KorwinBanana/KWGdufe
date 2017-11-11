//
//  KWMyClassViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "Utils.h"
#import "KWMyClassViewController.h"
#import "KWMyClassCollectionCell.h"
#import "KWCollectionViewLayout.h"
#import "KWReusableView.h"
#import "KWReusableView.h"
#import "KWWeekDay.h"
#import "NSData+KWAES.h"
#import "KWMyClassMsgViewController.h"
#import "KWMineViewController.h"
#import "KeychainWrapper.h"
#import <AFNetworking/AFNetworking.h>
#import "KWAFNetworking.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "KWRequestUrl.h"


@interface KWMyClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *collectionView;
    CGFloat addWidth;
    CGFloat addWidthWeek;
    CGFloat addHeight;
    NSArray *colors;
    NSString *schoolWeek;
    UIImageView *bgView;
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
    [self setupNavBar];
    
    self.stuTime  = [Utils getCache:gdufeAccount andID:@"stuTime"];
    
    colors = @[@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF"];
    
    //状态栏高度
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    //获取第几周
    [self getSchoolWeek];
    
    //提示用户当前正在加载数据 SVPro
    [SVProgressHUD showWithStatus:@"等一下能怎么样！？"];
    
    //获取缓存数据
//    [self getDataFromCache];
//    [self loadData];
    [self loadAllData];//加载所以数据
    
    //获取课程展示的宽度
    addWidth= (KWSCreenW-20-7)/7.0;
    
    //获取星期的宽度
    addWidthWeek= (KWSCreenW-20)/7.0;
    
    //获取高度
    addHeight = (KWSCreenH-rectStatus.size.height - rectNav.size.height - 20)/10;
    
    //设置星期一到星期日和第几周
    [self setWeekAndDays];
    
    //自定义流水布局——用于展示课表位置和大小
    self.course = [[KWCollectionViewLayout alloc] init];;
    self.course.width = addWidth;
    _course.height = (KWSCreenH - rectStatus.size.height - rectNav.size.height - 20)/10;
    
    //缓存获取界面数据
    NSArray *dicAry = [Utils getCache:gdufeAccount andID:@"ClassModel"];
    if (dicAry) {
        _scheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:dicAry];
        self.course.array = [[NSArray alloc]initWithArray:_scheduleModel];
        [SVProgressHUD dismiss];
    } else {
        [self loadData:self.stuTime week:schoolWeek];
    }
    
    //创建collectionVIew
    [self setupCollectionView];
}

////初始化stuTime
//- (void)setStuTime:(NSString *)stuTime {
//    NSString *sno = [wrapper myObjectForKey:(id)kSecAttrAccount];
//    stuTime = [Utils getCache:sno andID:@"stuTime"];
//    self.stuTime = stuTime;
//}

#pragma mark - 设置导航条
- (void)setupNavBar {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] hightImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(selectYear)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"friendsRecommentIcon"] hightImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(selectWeek)];
    self.navigationItem.title = @"课程表";
}

- (void)selectYear {
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSMutableArray *stuTimes = [Utils getCache:account andID:@"stuTimes"];
//    NSLog(@"stuTimes = %@",stuTimes);
    [ActionSheetStringPicker showPickerWithTitle:@"学期"
                                            rows:stuTimes
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.stuTime = selectedValue;
                                           [SVProgressHUD showWithStatus:@"更新课表"];
                                           [Utils updateCache:gdufeAccount andID:@"stuTime" andValue:selectedValue];
                                           [self loadData:self.stuTime week:schoolWeek];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self.view];
}

- (void)selectWeek {
    NSArray *stuWeek = @[@"当前周", @"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周", @"第8周", @"第9周", @"第10周", @"第11周", @"第12周", @"第13周", @"第14周", @"第15周", @"第16周", @"第17周", @"第18周"];
    [ActionSheetStringPicker showPickerWithTitle:@"周"
                                            rows:stuWeek
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           if (selectedIndex == 0) {
                                               [self getSchoolWeek];
                                               [SVProgressHUD showWithStatus:@"更新课表"];
                                               [self loadData:self.stuTime week:schoolWeek];
                                           } else {
                                               schoolWeek = [NSString stringWithFormat:@"%ld", (long)selectedIndex];
                                               [SVProgressHUD showWithStatus:@"更新课表"];
                                               [self loadData:self.stuTime week:schoolWeek];
                                           }
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:self.view];
}

- (void)setupCollectionView
{
    //状态栏高度
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    //创建collectionView视图，应用自定义的collectionViewLayout：_course
    
    //适配iPhone X
    CGFloat myHeight;
    if (KWSCreenH == 812.0000) {
        myHeight = KWSCreenH - 22;
    } else {
        myHeight = KWSCreenH;
    }
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+rectNav.size.height+30, KWSCreenW,myHeight) collectionViewLayout:_course];
//    bgHeight = CGRectGetHeight([UIScreen mainScreen].bounds)/12;//设置背景格子的高度
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.bounces = NO;//取消弹回
    collectionView.showsVerticalScrollIndicator = NO;//隐藏滚动条
//    collectionView.backgroundColor = [UIColor blueColor];
    
    //设置格子背景
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KWSCreenW,12*addHeight)];
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

/*
 设置格子背景
 问题：直接生成格子，会产生大量格子UIView对象，会造成整个APP卡顿
 解决：
 先定义一个UIView容器：bgImageView，在UIView容器：bgImageView中生成格子，
 最后把bgImageView生成image保存到背景UIImageView里的Image中,并保持清晰度，
 最后把UIView容器：bgImageView中的所有UIView格子对象移除掉
 */
- (void)setGeziBg
{
    KWWeekDay *flag;
    CGFloat x=37;
    
    UIView *bgImageView = [[UIView alloc]initWithFrame:bgView.bounds];
    for (int j = 0; j<12; j++) {
        x = 27;
        for(int i=1;i<=7;i++)
        {
            x--;
            @autoreleasepool {
                flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, 0+j*addHeight, addWidthWeek, addHeight)];
                x+=addWidthWeek;
                flag.alpha=0.5;//格子颜色深浅
            }
            [bgImageView addSubview:flag];
        }
    }
    bgView.image = [self makeImageWithView:bgImageView];
//    bgView.backgroundColor = [UIColor redColor];
    [bgImageView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark 生成image
- (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize size = bgView.bounds.size;
    /*
     下面方法，
     第一个参数表示区域大小。
     第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。
     第三个参数就是屏幕密度了，关键就是第三个参数。
     */
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 设置周
- (void)setWeekAndDays{
    NSArray *weekStr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七"];
    KWWeekDay *flag;
    CGFloat height = 30;
    CGFloat x=27;
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(0, rectStatus.size.height+rectNav.size.height, 26.5, height)];
    flag.alpha=0.8;
    [flag setDay:[NSString stringWithFormat:@"%@周",schoolWeek]];
    [self.view addSubview:flag];
    
    for(int i=1;i<=7;i++)
    {
        x--;
        flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, rectStatus.size.height+rectNav.size.height, addWidthWeek, height)];
//        NSLog(@"%f",addWidthWeek);
        x+=addWidthWeek;
        flag.alpha=0.8;
        [flag setDay:weekStr[i-1]];
        [self.view addSubview:flag];
    }
}

#pragma mark - 加载数据
- (void)loadData:(NSString *)selectStuTime week:(NSString *)selectWeek
{
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = selectStuTime;
    parements[@"week"] = selectWeek;
    
    [self getSchoolWeek];
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=jw/get-schedule" parameters:parements success:^(id data) {
        
        NSArray *dicAry = data[@"data"];;
        [Utils saveCache:gdufeAccount andID:@"ClassModel" andValue:dicAry];//保存到本地沙盒

        //字典数组转模型数组
        _scheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:dicAry];
        self.course.array = _scheduleModel;

        [collectionView reloadData];

        //取消提示框
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadAllData {
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSMutableArray *stuTimes = [Utils getCache:account andID:@"stuTimes"];
    NSString *loaDataStuTime = [[NSString alloc]init];
    for (int i = 0; i < 8; i++) {
        loaDataStuTime = stuTimes[i];
        [self loadDataAll:loaDataStuTime];
    }
}

- (void)loadDataAll:(NSString *)selectStuTime {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = selectStuTime;
    
    [self getSchoolWeek];
    
    [KWAFNetworking postWithUrlString:GetScheduleAPI parameters:parements success:^(id data) {
        
        [data writeToFile:[NSString stringWithFormat:@"/Users/k/iOS-KW/project/classModel-%@.plist",selectStuTime] atomically:nil];
        
        NSArray *dicAry = data[@"data"];
        [Utils saveCache:gdufeAccount andID:[NSString stringWithFormat:@"ClassModel-%@",selectStuTime] andValue:dicAry];//保存到本地沙盒
        
    } failure:^(NSError *error) {
        
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
    schoolWeek = [NSString stringWithFormat:@"%ld",(NSInteger)time/604800];
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
    cell.view.backgroundColor = [Utils colorWithHexString:colors[indexPath.row - 12 + 3]];
//    NSLog(@"cell%ld = %@",indexPath.row - 12,NSStringFromCGRect(cell.frame));
    return cell;
}


- (UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    [collectionView sendSubviewToBack:bgView];
    KWReusableView *Tag = [collectionView dequeueReusableSupplementaryViewOfKind:@"number" withReuseIdentifier:@"num" forIndexPath:indexPath];
//    NSLog(@"%@",NSStringFromCGRect(Tag.frame));
    //防止循环利用cell多增加了一行cell
    if (indexPath.row == 12) {
        Tag.self.layer.borderWidth = 0;
        Tag.num.text = NULL;
        return Tag;
    }else {
        Tag.self.layer.borderWidth = 0.25;
        Tag.num.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        Tag.num.textColor = [UIColor blackColor];//节数颜色
        return Tag;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KWMyClassMsgViewController *msgVc = [[KWMyClassMsgViewController alloc] init];
    KWScheduleModel *classModel = _scheduleModel[indexPath.row - 12];
    msgVc.model = classModel;
    [self.navigationController pushViewController:msgVc animated:YES];
}

@end
