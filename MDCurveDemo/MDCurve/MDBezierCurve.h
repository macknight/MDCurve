//
//  MDBezierCurve.h
//  MDCurveDemo
//
//  Created by 杨晨 on 1/2/14.
//  Copyright (c) 2014 杨晨. All rights reserved.
//

#import "MDCurve.h"
#import "MDPointPair.h"

@interface MDBezierCurve : MDCurve

@property (nonatomic, assign) BOOL isCubic;

- (id)initWithStartPointPair0:(MDPointPair *)pointPair0 pointPair1:(MDPointPair *)pointPair1;

- (void)addPointPair:(MDPointPair *)pointPair;
- (void)addPointPairs:(NSArray *)pointPairs;

@end
