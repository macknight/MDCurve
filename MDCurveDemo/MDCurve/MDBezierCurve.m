//
//  MDBezierCurve.m
//  MDCurveDemo
//
//  Created by 杨晨 on 1/2/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDBezierCurve.h"

@interface MDBezierCurve ()

@property (nonatomic, strong) NSMutableArray *pointPairs;

@end

@implementation MDBezierCurve

#pragma mark - method forbidden

- (void)setCurveFuction:(MDCurvePointFuction)curveFuction {
  NSLog(@"method %s is forbidden in MDBezierCurve", __FUNCTION__);
  assert(NO);
}

- (void)setLineLengthFuction:(MDCurveFuction)lineLengthFuction {
  NSLog(@"method %s is forbidden in MDBezierCurve", __FUNCTION__);
  assert(NO);
}

- (void)setLineLengthInverseFunction:(MDCurveFuction)lineLengthInverseFunction {
  NSLog(@"method %s is forbidden in MDBezierCurve", __FUNCTION__);
  assert(NO);
}

#pragma mark - method

- (NSMutableArray *)pointPairs {
  return _pointPairs ?: (_pointPairs = [NSMutableArray array]);
}

- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1 {
  if (self = [super init]) {
    self.pointPairs = [NSMutableArray arrayWithObjects:pointPair0, pointPair1, nil];
    [self updateMethod];
  }
  return self;
}

- (void)addPointPair:(MDPointPair *)pointPair {
  [self.pointPairs addObject:pointPair];
  [self updateMethod];
}

- (void)addPointPairs:(NSArray *)pointPairs {
  [self.pointPairs addObjectsFromArray:pointPairs];
  [self updateMethod];
}

- (void)updateMethod {
  if (_pointPairs.count < 2) {
    return;
  }
  int number = self.pointPairs.count - 1;
  super.curveFuction = ^(double t) {
    if (t >= 1) {
      return [self pointWithT:1. inIndex:number - 1];
    }
    t = t * number;
    int index = (int)t;
    t = t - index;
    return [self pointWithT:t inIndex:index];
  };
}

#pragma mark - calculate method

- (CGPoint)pointWithT:(CGFloat)t inIndex:(int)index {
  if (index > _pointPairs.count - 2) {
    return CGPointZero;
  }
  t = MAX(0, MIN(1, t));
  MDPointPair *pointPair0 = _pointPairs[index];
  MDPointPair *pointPair1 = _pointPairs[index + 1];
  CGPoint p0 = pointPair0.startPoint;
  CGPoint p1 = pointPair0.controlPoint;
  CGPoint p2 = pointPair1.reverseControlPoint;
  CGPoint p3 = pointPair1.startPoint;
  
  CGFloat it = 1 - t;
  
  CGFloat x, y;
  if (self.isCubic) {
    x =
    p0.x * it * it * it +
    3 * p1.x * t * it * it +
    3 * p2.x * t * t * it +
    p3.x * t * t * t;
    
    y =
    p0.y * it * it * it +
    3 * p1.y * t * it * it +
    3 * p2.y * t * t * it +
    p3.y * t * t * t;
  } else {
    x =
    p0.x * it * it +
    2 * p1.x * it * t +
    p3.x * t * t;
    
    y =
    p0.y * it * it +
    2 * p1.y * it * t +
    p3.y * t * t;
  }
  return CGPointMake(x, y);
}

//- (double)lineLengthWithT:(CGFloat)t inIndex:(int)index {
//  if (index > _pointPairs.count - 2) {
//    return 0;
//  }
//  t = MAX(0, MIN(1, t));
//  MDPointPair *pointPair0 = _pointPairs[index];
//  MDPointPair *pointPair1 = _pointPairs[index + 1];
//  CGPoint p0 = pointPair0.startPoint;
//  CGPoint p1 = pointPair0.controlPoint;
//  CGPoint p2 = pointPair1.reverseControlPoint;
//  CGPoint p3 = pointPair1.startPoint;
//  
//  
//}

@end
