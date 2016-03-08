//
//  ViewController.m
//  IBLMenuBar
//
//  Created by simpossible on 16/3/8.
//  Copyright © 2016年 simpossible. All rights reserved.
//

#import "ViewController.h"
#import "viewcontroller1.h"
#import "viewcontroller2.h"
#import "IBLMenuBar.h"

@interface ViewController ()
@property(nonatomic, strong)IBLMenuBar *menubar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialUI];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initialUI{
    viewcontroller1 *con1 = [[viewcontroller1 alloc]init];
    viewcontroller2 *con2 = [[viewcontroller2 alloc]init];
    
    _menubar = [[IBLMenuBar alloc]initWithItems:@[@"第一个",@"第二个"] andControllers:@[con1,con2] andHeight:50];
    [_menubar setLocation:CGPointMake(0, 70)];
    [_menubar setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.width)];
    [self.view addSubview:_menubar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
