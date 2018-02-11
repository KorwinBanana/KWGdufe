//
//  KWAboutViewController.m
//  KWGdufe
//
//  Created by korwin on 2018/2/8.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWAboutViewController.h"
#import "Utils.h"

@interface KWAboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutBody;

@end

@implementation KWAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [Utils colorWithHexString:@"0691CD"];
    self.navigationItem.title = @"关于茶珂";
    [_aboutBody setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    _aboutBody.text = [NSString stringWithFormat:@"茶珂\n\n面向广东财经大学在校学生(iOS用户)\n连接学校信息门户\n提供校园信息服务"];
//    self.backView.backgroundColor = [Utils colorWithHexString:@"37C6C0"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
