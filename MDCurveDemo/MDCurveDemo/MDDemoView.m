//
//  MDDemoView.m
//  MDCurveDemo
//
//  Created by 杨晨 on 12/27/13.
//  Copyright (c) 2013 杨晨. All rights reserved.
//

#import "MDDemoView.h"
#import "MDCurve.h"

@implementation MDDemoView

@synthesize curve = _curve;

- (MDCurve *)curve {
  return _curve ?: (_curve = [[MDCurve alloc] init]);
}

- (void)setCurve:(MDCurve *)curve {
  _curve = curve;
  [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  [self.curve drawInCurrentContextWithStep:100];
  for (int i = 0; i < 100; i++) {
    CGPoint p = [self.curve pointWithUniformT:(i + 1.) / 10];
    [self drawPointAtPoint:p];
  }
}

- (void)drawPointAtPoint:(CGPoint)point {
  CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(point.x - 2, point.y - 2, 4, 4));
}

@end
