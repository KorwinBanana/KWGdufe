//
//  KWWebViewController.m
//  BuDeJie
//
//  Created by korwin on 2017/9/25.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWWebViewController.h"
#import <WebKit/WebKit.h>

@interface KWWebViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForward;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) WKWebView *WebView;

@end

@implementation KWWebViewController
- (IBAction)goBack:(id)sender {
    [self.WebView goBack];
}
- (IBAction)goForward:(id)sender {
    [self.WebView goForward];
}
- (IBAction)refresh:(id)sender {
    [self.WebView reload];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    WKWebView *WebView = [[WKWebView alloc] init];
    _WebView = WebView;
    NSURLRequest *Request = [[NSURLRequest alloc] initWithURL:_url];
    [WebView loadRequest:Request];
    [self.contentView addSubview:WebView];
    
    /*
     *KVO监听
     */
    [WebView addObserver:self forKeyPath:@"canGoBack" options:NSKeyValueObservingOptionNew context:nil];
    [WebView addObserver:self forKeyPath:@"canGoForward" options:NSKeyValueObservingOptionNew context:nil];
    [WebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [WebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)dealloc
{
    [self.WebView removeObserver:self forKeyPath:@"canGoBack"];
    [self.WebView removeObserver:self forKeyPath:@"canGoForward"];
    [self.WebView removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    _goBack.enabled = self.WebView.canGoBack;
    _goForward.enabled = self.WebView.canGoForward;
    _progressView.progress = self.WebView.estimatedProgress;
    _progressView.hidden = self.WebView.estimatedProgress >= 1;
    self.navigationItem.title = self.WebView.title;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.WebView.frame = self.contentView.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
