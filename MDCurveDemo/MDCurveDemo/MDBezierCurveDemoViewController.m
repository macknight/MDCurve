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
#import "mach/mach_time.h"

@interface MDBezierCurveDemoViewController ()

@end

@implementation MDBezierCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
  UIView *view = [self demoView];
  view.backgroundColor = [UIColor lightGrayColor];
  [scrollView addSubview:view];
  scrollView.contentSize = view.frame.size;
  [self.view addSubview:scrollView];
}

- (MDDemoView *)demoView {
  
  MDDemoView *demoView = [[MDDemoView alloc] initWithFrame:CGRectMake(0, 0, 3000, 5000)];
  
  MDBezierCurve *curve = [[MDBezierCurve alloc] initWithStartPointPair0:pointPairWithCoordinate(0, 20, 320, 60)
                                                             pointPair1:pointPairWithCoordinate(100, 100, 0, 160)];
  curve.isCubic = YES;
  [curve addPointPair:pointPairWithCoordinate(300, 200, 200, 250)];
  [curve addPointPair:pointPairWithCoordinate(30, 200, 20, 250)];
  [curve addPointPair:pointPairWithCoordinate(130, 20, 220, 50)];
  [curve addPointPair:pointPairWithCoordinate(320, 500, 20, 500)];
  [curve addPointPair:pointPairWithCoordinate(30, 500, 220, 203)];
  uint64_t start = mach_absolute_time();
  [curve generateLengthCache];
  uint64_t end = mach_absolute_time();
  uint64_t elapsed = end - start;
  
  mach_timebase_info_data_t info;
  if (mach_timebase_info (&info) != KERN_SUCCESS) {
    printf ("mach_timebase_info failed\n");
  }
  
  uint64_t nanosecs = elapsed * info.numer / info.denom;
  uint64_t millisecs = nanosecs / 1000000;
  NSLog(@"cache用时：%llu", millisecs);
  demoView.curve = curve;
  return demoView;
}

@end
