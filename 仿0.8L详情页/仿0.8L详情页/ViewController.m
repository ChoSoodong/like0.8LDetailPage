//
//  ViewController.m
//  仿0.8L详情页
//
//  Created by xialan on 2019/1/24.
//  Copyright © 2019 ZHAO. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"仿0.8L";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    UIButton *button = [[UIButton alloc] initWithFrame:self.view.bounds];
    [button setTitle:@"点击去详情页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UILabel *psLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, self.view.frame.size.height-300)];
    psLabel.text = @"注意:\n使用的tableView不可设置sectionHeader\n因为设置sectionHeader后透明的导航栏并不能将sectionHeader覆盖\n如果你有更好的解决方法,请告知一下!";
    psLabel.font = [UIFont systemFontOfSize:20];
    psLabel.textColor = [UIColor redColor];
    psLabel.textAlignment = NSTextAlignmentCenter;
    psLabel.numberOfLines = 0;
    [self.view addSubview:psLabel];
    
}

-(void)buttonClick{
    
    [self.navigationController pushViewController:[DetailViewController new] animated:YES];
    
}
@end
