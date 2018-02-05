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
#import "KWRealm.h"
#import "KWScheduleObject.h"

static float progress = 0.0f;

@interface KWMyClassViewController ()<UICollectionViewDataSource,UICollectionViewDelegate> {
    UICollectionView *collectionView;
    CGFloat addWidth;
    CGFloat addWidthWeek;
    CGFloat addHeight;
    NSArray *colors;
    NSString *schoolWeek;
    NSString *selectSchoolWeek;
    UIImageView *bgView;
    KWWeekDay *weekView;
}

@property (nonatomic,strong) NSArray  *scheduleModel;
@property (nonatomic,strong) KWCollectionViewLayout  *course;

@end

@implementation KWMyClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self preferredStatusBarStyle];
    //设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    schoolWeek = [Utils getCache:gdufeAccount andID:@"schoolWeek"];

    //设置标题
    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYear"] setleftName:[NSString stringWithFormat:@"第%@周",schoolWeek]];
    
    colors = @[@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF",@"#37C6C0",@"#5A4446",@"#FB7C85",@"#373E40",@"#8BACA1",@"#39A9CF",@"#DEBE9B",@"#C9D2CB",@"#8C7E78",@"#8ECB78",@"#0973AF"];
    
    //获取课程展示的宽度
    addWidth= (KWSCreenW-20-7)/7.0;
    
    //获取星期的宽度
    addWidthWeek= (KWSCreenW-20)/7.0;
    
    //获取高度
    addHeight = (KWSCreenH - 20)/10;
    
    //设置星期一到星期日和第几周
    [self setWeekAndDays];
    
    //自定义流水布局——用于展示课表位置和大小
    self.course = [[KWCollectionViewLayout alloc] init];;
    self.course.width = addWidth;
    _course.height = (KWSCreenH - 20)/10;
    
//    //缓存获取界面数据
//    NSArray *dicAry = [Utils getCache:gdufeAccount andID:@"ClassModel"];
//    if (dicAry) {
//        _scheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:dicAry];
//        self.course.array = [[NSArray alloc]initWithArray:_scheduleModel];
//        [SVProgressHUD dismiss];
//    } else {
//        self.stuTime = [Utils getCache:gdufeAccount andID:@"stuTime"];
//        NSLog(@"self.stuTime = %@",self.stuTime);
//
//        [self loadData:self.stuTime week:schoolWeek];
//    }
    
    //使用数据库获取
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWScheduleObject allObjectsInRealm:real];
    NSInteger dataCount = [KWRealm getNumOfLine:results];
    if (!dataCount) {
        //无
        self.stuTime = [Utils getCache:gdufeAccount andID:@"stuTime"];
        NSLog(@"self.stuTime = %@",self.stuTime);
        
        [self loadData:self.stuTime week:schoolWeek];
    } else {
        //有
        NSMutableArray *arraySchedule = [NSMutableArray array];
        for (RLMObject *object in results) {
            [arraySchedule addObject:object];
        }
        _scheduleModel = arraySchedule;
        self.course.array = [[NSArray alloc]initWithArray:_scheduleModel];
        [SVProgressHUD dismiss];
    }
    //创建collectionVIew
    [self setupCollectionView];
}

#pragma mark - 设置导航条
- (void)setupNavBarRightName:(NSString *)rightName setleftName:(NSString *)lefrName {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:rightName target:self action:@selector(selectYear)];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithString:lefrName target:self action:@selector(selectWeek)];
    self.navigationItem.title = @"课程表";
}

- (void)selectYear {
    NSMutableArray *stuTimes = [Utils getCache:gdufeAccount andID:@"stuTimes"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"学期" rows:stuTimeForSchool initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if(selectedIndex == 0){
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
//                [Utils getNowYear];
                self.stuTime = [Utils getCache:gdufeAccount andID:@"stuTime"];//获取大几的时间
                NSLog(@"全部——当前学期%@",self.stuTime);
                [Utils getStuTimeSchool:self.stuTime];//获取大几
                [Utils updateCache:gdufeAccount andID:@"schoolYear" andValue:[Utils getCache:gdufeAccount andID:@"schoolYear"]];
                [Utils updateCache:gdufeAccount andID:@"stuTimeForClass" andValue:self.stuTime];
                [SVProgressHUD show];
                [self loadData:self.stuTime week:schoolWeek];//更新数据
                NSLog(@"school = %@",[Utils getCache:gdufeAccount andID:@"schoolYear"]);
                [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYear"] setleftName:[NSString stringWithFormat:@"第%@周",schoolWeek]];
                
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];
        } else {
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
                self.stuTime = stuTimes[selectedIndex-1];
                [SVProgressHUD show];
#warning 设置不同stuTime保存当前学期和选择学期
                [Utils updateCache:gdufeAccount andID:@"stuTimeForClass" andValue:stuTimes[selectedIndex-1]];
                [self loadData:self.stuTime week:schoolWeek];
                [self setupNavBarRightName:selectedValue setleftName:[NSString stringWithFormat:@"第%@周",schoolWeek]];
                [Utils updateCache:gdufeAccount andID:@"schoolYear" andValue:selectedValue];
//               NSLog(@"%@",[Utils getCache:gdufeAccount andID:@"schoolYear"]);
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self.view];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

- (void)selectWeek {
    NSArray *stuWeek = @[@"当前周", @"第1周", @"第2周", @"第3周", @"第4周", @"第5周", @"第6周", @"第7周", @"第8周", @"第9周", @"第10周", @"第11周", @"第12周", @"第13周", @"第14周", @"第15周", @"第16周", @"第17周", @"第18周"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"周" rows:stuWeek initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if (selectedIndex == 0) {
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
//                [Utils getSchoolWeek];
                schoolWeek = [Utils getCache:gdufeAccount andID:@"schoolWeek"];
                [SVProgressHUD show];
                
                [self loadData:[Utils getCache:gdufeAccount andID:@"stuTimeForClass"] week:schoolWeek];
                [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYear"] setleftName:[NSString stringWithFormat:@"第%@周",schoolWeek]];
//               [weekView setDay:[NSString stringWithFormat:@"%@周",schoolWeek]];
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];

        } else {
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
                schoolWeek = [NSString stringWithFormat:@"%ld", (long)selectedIndex];
//              [SVProgressHUD showWithStatus:@"更新课表"];
//                [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
                [SVProgressHUD show];
                
                [Utils saveCache:gdufeAccount andID:@"schoolWeek" andValue:[NSString stringWithFormat:@"%ld",(long)selectedIndex]];
                schoolWeek = [Utils getCache:gdufeAccount andID:@"schoolWeek"];
//             NSLog(@"选择的schoolweek = %@",schoolWeek);
                [self loadData:[Utils getCache:gdufeAccount andID:@"stuTimeForClass"] week:schoolWeek];
                [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYear"] setleftName:[NSString stringWithFormat:@"第%ld周",(long)selectedIndex]];
//              [weekView setDay:[NSString stringWithFormat:@"%ld周",(long)selectedIndex]];
                
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self.view];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

- (void)setupCollectionView
{
    //创建collectionView视图，应用自定义的collectionViewLayout：_course
    
    //适配iPhone X
    CGFloat myHeight;
    if (KWSCreenH == 812.0000) {
        myHeight = KWSCreenH - 22;
    } else {
        myHeight = KWSCreenH;
    }
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 30, KWSCreenW,myHeight) collectionViewLayout:_course];
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
    CGFloat x=27.25;
    weekView = [[KWWeekDay alloc] initWithFrame:CGRectMake(0, 0 , x  , height)];
    weekView.alpha=0.8;
//    [weekView setDay:[NSString stringWithFormat:@"%@周",schoolWeek]];
    [self.view addSubview:weekView];
    
    for(int i=1;i<=7;i++)
    {
        x--;
        flag = [[KWWeekDay alloc] initWithFrame:CGRectMake(x, 0 , addWidthWeek, height)];
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
    
//    NSLog(@"加载数据的schoolweek = %@",selectWeek);
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=jw/get-schedule" vController:self parameters:parements success:^(id data) {
        NSArray *scheduleAry = data[@"data"];;
        
        [Utils saveCache:gdufeAccount andID:@"ClassModel" andValue:scheduleAry];//保存到本地沙盒
        
        //字典数组转模型数组
        _scheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:scheduleAry];
        
        //存入数据库
        RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
        KWScheduleObject __block *scheduleObject = [[KWScheduleObject alloc] init];
        RLMResults *results = [KWScheduleObject allObjectsInRealm:real];
        
        if (!results) {
            NSLog(@"1");
            for (int i = 0; i<_scheduleModel.count; i++) {
                scheduleObject = [[KWScheduleObject alloc] initWithValue:_scheduleModel[i]];
//                scheduleObject.num = i;
                [KWRealm saveRLMObject:real rlmObject:scheduleObject];
            }
        } else {
            NSLog(@"2");
            [real beginWriteTransaction];
            RLMResults *scheduleResults = [KWScheduleObject allObjectsInRealm:real];
            [real deleteObjects:scheduleResults];
            [real commitWriteTransaction];
            
            KWScheduleModel *schModel = [[KWScheduleModel alloc] init];
            for (int i = 0; i<_scheduleModel.count; i++) {
                schModel = _scheduleModel[i];
                schModel.num = i;
                scheduleObject = [[KWScheduleObject alloc] initWithValue:schModel];
                [KWRealm saveRLMObject:real rlmObject:scheduleObject];
            }
        }
        
        self.course.array = _scheduleModel;
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
            [collectionView reloadData];
            //取消提示框
            [SVProgressHUD dismiss];
            NSLog(@"请求课程数据成功~");
        });
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        
    }];
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

#pragma mark - SVProgress

- (void)increaseProgress {
    progress += 0.1f;
    [SVProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f){
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    } else {
        [self performSelector:@selector(dismissSVProgressHUD) withObject:nil afterDelay:0.4f];
    }
}

- (void)dismissSVProgressHUD {
    [SVProgressHUD dismiss];
}

@end
