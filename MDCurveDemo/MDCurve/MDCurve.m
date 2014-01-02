//
//  MDCurve.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDCurve.h"

#define hugeDeviation 0.1
#define largeDeviation 0.01
#define middleDeviation 0.001
#define littleDeviation 0.0001
#define hugeDeviationDoubleEqual(a, b) ((a - b) < hugeDeviation && (b - a) < hugeDeviation)
#define largeDeviationDoubleEqual(a, b) ((a - b) < largeDeviation && (b - a) < largeDeviation)
#define middleDeviationDoubleEqual(a, b) ((a - b) < middleDeviation && (b - a) < middleDeviation)
#define doubleEqual(a,b) ((a - b) < littleDeviation && (b - a) < littleDeviation)

@interface MDCurve () {
  double _length;
}

@end

@implementation MDCurve

- (CGPoint)pointWithUniformT:(double)v {
  return CGPointMake([self x_v:v], [self y_v:v]);
}

- (double)length {
  return _length ?: [self s_t:1.];
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
  if (t == 1) {
    return 1;
  }
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
    return self.lineLengthInverseFunction(v * self.length);
  }
  if (v <= 0) {
    return 0;
  }
  if (v >= 1) {
    return 1;
  }
  //在不动点处直接返回
  if (doubleEqual([self v_t:v], v)) {
    return v;
  }
  double lastT;
  double t = 0.5, testingV = [self v_t:0.5];
  double bigT = 1.0, smallT = 0.0;
  do {
    lastT = t;
    if (testingV > v) {
      bigT = t;
    } else {
      smallT = t;
    }
    t = (bigT + smallT) / 2.;
    testingV = [self v_t:t];
    if (middleDeviationDoubleEqual(lastT, t)) {
      break;
    }
  } while (!doubleEqual(v, testingV));
  double v_t = [self v_t:t], dv_dt;
  do {
    lastT = t;
    dv_dt = [self dv_dt:t];
    t -= (v_t - v) / dv_dt;
    v_t = [self v_t:t];
    if (middleDeviationDoubleEqual(v, [self v_t:(lastT + t) / 2])) {
      return (lastT + t) / 2;
    }
  } while (!middleDeviationDoubleEqual(v_t, v));
  return t;
}

- (double)x_v:(double)v {
  return [self x:[self t_v:v]];
}

- (double)y_v:(double)v {
  return [self y:[self t_v:v]];
}

@end