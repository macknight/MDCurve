//
//  MDCurve.h
//  MDCurveDemo
//
//  Created by 杨晨 on 12/26/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef CGPoint(^MDCurvePointFuction)(double v);
typedef double(^MDCurveFuction)(double x);

@interface MDCurve : NSObject

/**
 *  给出线长函数反函数的时候，性能最高，其次是给线长函数，如果只给曲线函数，性能比较低。
 */
@property (nonatomic, copy) MDCurvePointFuction curveFuction;
@property (nonatomic, copy) MDCurveFuction lineLengthInverseFunction;

@property (nonatomic, readonly) double length;

- (CGPoint)pointWithUniformT:(double)v;
- (void)drawInContext:(CGContextRef)context step:(int)step;
- (void)drawInCurrentContextWithStep:(int)step;
- (void)generateLengthCache;

@end
