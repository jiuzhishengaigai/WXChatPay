//
//  ViewController.m
//  WXChatPay
//
//  Created by gaigai on 16/6/10.
//  Copyright © 2016年 gaigai. All rights reserved.
//

#import "ViewController.h"

#import "WXPayTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)WXChatPay:(UIButton *)sender {
    
    
    [WXPayTools WXPay:@"ND20160610013127103549"];
    
}

@end
