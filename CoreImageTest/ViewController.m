//
//  ViewController.m
//  CoreImageTest
//
//  Created by YeYiFeng on 2018/4/2.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "ViewController.h"
#import "faceRecoginzeViewController.h"
#import "filterImageViewController.h"
@interface ViewController ()
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}
- (IBAction)faceClick:(id)sender {
    faceRecoginzeViewController * vc = [[faceRecoginzeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)filterImage:(id)sender {
    filterImageViewController * vc = [[filterImageViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
