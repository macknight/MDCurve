MDCurve
=======

MDCurve 用于解决曲线运算，并提供按线长比例定位的方法。

MDCurve 有三个block：

@property (nonatomic, copy) MDCurvePointFuction curveFuction;

@property (nonatomic, copy) MDCurveFuction lineLengthFuction;

@property (nonatomic, copy) MDCurveFuction lineLengthInverseFunction;

其中curveFuction提供曲线方程：

      x = x(t);

      y = y(t);

该属性必须赋值

注意：t的取值范围是0~1

lineLengthFuction是线长对t的函数：

      s = s(t);

该属性选择性赋值。

该属性如果正确赋值，能较大程度上提高运算效率，降低CPU资源消耗。

lineLengthInverseFunction是lineLengthFuction的反函数：

      t = t(s);

该属性选择性赋值。

该属性如果正确赋值，能较大程度上提高运算效率，降低CPU资源消耗。

=======

MDCurve提供四个方法：

获取曲线总长度：

- (double)length;


这个方法是MDCurve的核心方法，作用是获取曲线上某点，该点到曲线起点的曲线上距离为v乘以曲线长度，也就是说v控制了该点在曲线上的位置，并且是等比控制：

- (CGPoint)pointWithUniformT:(double)v;


在上下文context中绘制曲线

- (void)drawInContext:(CGContextRef)context step:(int)step;


在当前上下文中绘制曲线

- (void)drawInCurrentContextWithStep:(int)step;
