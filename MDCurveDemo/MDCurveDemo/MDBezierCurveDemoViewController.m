//
//  MDBezierCurveDemoViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 1/3/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDBezierCurveDemoViewController.h"
#import "MDBezierCurve.h"
#import "MDDemoView.h"

@interface MDBezierCurveDemoViewController ()

@end

@implementation MDBezierCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  MDDemoView *demoView = [[MDDemoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
  [self.view addSubview:demoView];
  
  MDBezierCurve *curve = [[MDBezierCurve alloc] initWithStartPointPair0:pointPairWithCoordinate(0, 20, 320, 60)
                                                             pointPair1:pointPairWithCoordinate(100, 100, 0, 160)];
  curve.isCubic = YES;
  [curve addPointPair:pointPairWithCoordinate(300, 200, 200, 250)];
  [curve addPointPair:pointPairWithCoordinate(30, 200, 20, 250)];
  [curve addPointPair:pointPairWithCoordinate(130, 20, 220, 50)];
  NSLog(@"a");
  demoView.curve = curve;
  NSLog(@"a");
}

@end
