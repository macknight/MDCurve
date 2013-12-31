//
//  MDCurve.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurve.h"

#define largeDeviation 0.01
#define middleDeviation 0.001
#define littleDeviation 0.0001
#define doubleEqual(a,b) ((a - b) < littleDeviation && (b - a) < littleDeviation)

@implementation MDCurve

- (CGPoint)pointWithUniformT:(double)t {
  return CGPointMake([self x_v:t], [self y_v:t]);
}

- (double)length {
  return [self s_t:1];
}

- (void)drawInContext:(CGContextRef)context step:(int)step {
  CGContextMoveToPoint(context, [self x:0], [self y:0]);
  for (int i = 0; i < step; i++) {
    double t = (i + 1.) / step;
    CGContextAddLineToPoint(context, [self x:t], [self y:t]);
  }
  CGContextStrokePath(context);
}

- (void)drawInCurrentContextWithStep:(int)step {
  [self drawInContext:UIGraphicsGetCurrentContext() step:step];
}

#pragma mark - math

- (double)x:(double)t {
  if (self.curveFuction) {
    return self.curveFuction(t).x;
  }
  return 0;
}

- (double)y:(double)t {
  if (self.curveFuction) {
    return self.curveFuction(t).y;
  }
  return 0;
}

- (double)dx_dt:(double)t {
  if (t < littleDeviation) {
    return ([self x:littleDeviation] - [self x:0]) / littleDeviation;
  } else if (t > 1 - littleDeviation) {
    return ([self x:1] - [self x:1 - littleDeviation]) / littleDeviation;
  } else {
    return ([self x:t + littleDeviation] - [self x:t - littleDeviation]) / littleDeviation / 2;
  }
}

- (double)dy_dt:(double)t {
  if (t < littleDeviation) {
    return ([self y:littleDeviation] - [self y:0]) / littleDeviation;
  } else if (t > 1 - littleDeviation) {
    return ([self y:1] - [self y:1 - littleDeviation]) / littleDeviation;
  } else {
    return ([self y:t + littleDeviation] - [self y:t - littleDeviation]) / littleDeviation / 2;
  }
}

- (double)gradient_t:(double)t {
  return hypot([self dx_dt:t], [self dy_dt:t]);
}

- (double)s_t:(double)t {
  if (t <= 0) {
    return 0;
  }
  if (t > 1) {
    t = 1;
  }
  if (self.lineLengthFuction) {
    return self.lineLengthFuction(t);
  }
  double res = 0.;
  double tx;
  for (tx = 0; tx < t; tx += largeDeviation) {
    res += largeDeviation * [self gradient_t:tx + largeDeviation / 2];
  }
  tx -= largeDeviation;
  res += (t - tx) * [self gradient_t:(t + tx) / 2];
  return res;
}

- (double)v_t:(double)t {
  return [self s_t:t] / [self s_t:1];
}

- (double)dv_dt:(double)t {
  if (t < littleDeviation) {
    return ([self v_t:littleDeviation] - [self v_t:0]) / littleDeviation;
  } else if (t > 1 - littleDeviation) {
    return ([self v_t:1] - [self v_t:1 - littleDeviation]) / littleDeviation;
  } else {
    return ([self v_t:t + littleDeviation] - [self v_t:t - littleDeviation]) / littleDeviation / 2;
  }
}

//用牛顿切线法求v_t的反函数
- (double)t_v:(double)v {
  if (!self.curveFuction) {
    return 0;
  }
  if (self.lineLengthInverseFunction) {
    double length = [self s_t:1];
    return self.lineLengthInverseFunction(v * length);
  }
  if (v <= 0) {
    return 0;
  }
  if (v >= 1) {
    return 1;
  }
  //牛顿切线在不动点处似乎是有问题的，所以额外给出
  if (doubleEqual([self v_t:v], v)) {
    return v;
  }
  double dv_dt, t, v_t;
  do {
    t = arc4random() % 1000 / 1000.;
    dv_dt =[self dv_dt:t];
  } while (doubleEqual(dv_dt, 0));
  
  do {
    dv_dt =[self dv_dt:t];
    v_t = [self v_t:t];
    t -= (v_t - v) / dv_dt;
  } while (!doubleEqual(v_t, v));
  return t;
}

- (double)x_v:(double)v {
  return [self x:[self t_v:v]];
}

- (double)y_v:(double)v {
  return [self y:[self t_v:v]];
}

@end