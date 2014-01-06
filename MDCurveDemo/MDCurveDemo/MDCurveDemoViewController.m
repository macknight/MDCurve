//
//  MDCurveDemoViewController.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurveDemoViewController.h"
#import "MDDemoView.h"

@interface MDCurveDemoViewController ()

@end

@implementation MDCurveDemoViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  MDDemoView *demoView = [[MDDemoView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
  [self.view addSubview:demoView];
  
  /**
   *  edit this
   */
  demoView.curve.curveFuction = [self f0];
  
  //提供以下代码可以进一步节省CPU, 如果曲线不是f0，请注释掉
  demoView.curve.lineLengthInverseFunction = [self lineLengthInverseFunction0];
}

/**
 *  圆
 */
- (MDCurvePointFuction)f0 {
  return ^(double t) {
    return CGPointMake(160 + 50 * cos(t * 2 * M_PI), 300 + 50 * sin(t * 2 * M_PI));
  };
}

- (MDCurveFuction)lineLength0 {
  return ^(double t) {
    return 50 * 2 * M_PI * t;
  };
}

- (MDCurveFuction)lineLengthInverseFunction0 {
  return ^(double s) {
    return s / (50 * 2 * M_PI);
  };
}

/*
 *正弦曲线
 */
- (MDCurvePointFuction)f1 {
  return ^(double t) {
    return CGPointMake(320 * t, 50 * sin(t * 2 * M_PI) + 160);
  };
}

/*
 *丑陋的心型
 */
- (MDCurvePointFuction)f2 {
  return ^(double t) {
    return CGPointMake(50 * sin(t * M_PI) * sin(t * 2 * M_PI) + 160,
                       -50 * sin(t * M_PI) * cos(t * 2 * M_PI) + 300);
  };
}

/**
 *  螺旋线
 */
- (MDCurvePointFuction)f3 {
  return ^(double t) {
    return CGPointMake(50 * t * sin(t * 4 * M_PI) + 160,
                       50 * t * cos(t * 4 * M_PI) + 300);
  };
}

/**
 *  椭圆螺旋线
 */
- (MDCurvePointFuction)f4 {
  return ^(double t) {
    return CGPointMake(50 * t * sin(t * 4 * M_PI) + 160,
                       150 * t * cos(t * 4 * M_PI) + 300);
  };
}

/**
 *  8字螺旋线
 */
- (MDCurvePointFuction)f5 {
  return ^(double t) {
    return CGPointMake(50 * sin(t * 4 * M_PI) + 160,
                       50 * cos(t * 2 * M_PI) + 300);
  };
}

/**
 *  歪8字
 */
- (MDCurvePointFuction)f6 {
  return ^(double t) {
    return CGPointMake(50 * t * sin(t * 4 * M_PI) + 160,
                       50 * cos(t * 2 * M_PI) + 300);
  };
}

/**
 *  呵呵8字
 */
- (MDCurvePointFuction)f7 {
  return ^(double t) {
    return CGPointMake(50 * t * sin(t * 4 * M_PI) + 160,
                       50 * t * cos(t * 2 * M_PI) + 300);
  };
}

/**
 *  直线, 求反函数时候全是不动点
 */
- (MDCurvePointFuction)f8 {
  return ^(double t) {
    return CGPointMake(50 * t + 160,
                       50 * t + 300);
  };
}

/**
 *  分段函数
 *  PS:好复杂，画个长方形都这么烦
 */

- (MDCurvePointFuction)f9 {
  return ^(double t) {
    CGFloat x = 160;
    CGFloat y = 300;
    CGFloat width = 30;
    CGFloat height = 77;
    if (t <= 0.25) {
      return CGPointMake(x, y + t * height / 0.25);
    }
    if (t <= 0.5) {
      return CGPointMake(x + (t - .25) * width / 0.25, y + height);
    }
    if (t <= 0.75) {
      return CGPointMake(x + width, y + height - (t - 0.5) * height / 0.25);
    }
    return CGPointMake(x + width - (t - 0.75) * width / 0.25, y);
  };
}

/**
 *  不连续的曲线
 */

- (MDCurvePointFuction)f10 {
  return ^(double t) {
    if (t < 0.5) {
      return CGPointMake(160, 300 + t * 50);
    }
    return CGPointMake(200, 300 + t * 50);
  };
}

/**
 *  随机曲线。。。。。显然不行，再求导数的时候会得到奇怪的数字
 */

- (MDCurvePointFuction)f11 {
  NSLog(@"f11是一条随机曲线，运行是会出问题的");
  return ^(double t) {
    return CGPointMake(arc4random() % 100 + 80, arc4random() % 130 + 300);
  };
}

@end
