//
//  ELProgressView.m
//  IndeterminateProgressBar
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import "IndeterminateProgressView.h"

@interface IndeterminateProgressView ()
@property (nonatomic, strong) UIImageView *progressView;
@end

@implementation IndeterminateProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Draw Background
    UIColor *bottomColor = self.bottomBackgroundColor;
    UIColor *topColor = self.topBackgroundColor;
    CGMutablePathRef path = [self roundedRectWithRadius:self.borderRadius rect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    [self drawGradientInContext:ctx forRect:rect withBottomColor:bottomColor topColor:topColor];
    CGContextRestoreGState(ctx);
}
- (void)startProgressing {
    [self.progressView setAnimationImages:[self imagesArray]];
    [self.progressView setAnimationDuration:self.animationDuration];
    [self.progressView setAnimationRepeatCount:0];
    [self.progressView startAnimating];
    self.isAnimating = YES;
}
- (void)stopProgressing {
    [self.progressView stopAnimating];
    self.isAnimating = NO;
}

#pragma mark Setup
- (void)setup {
    [self setupDefaults];
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.progressView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, self.borderWidth, self.borderWidth)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [self.progressView setBackgroundColor:[UIColor clearColor]];
    self.progressView.opaque = NO;
    [self addSubview:self.progressView];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    if (_borderWidth == 0) {
        _borderWidth = 0.5f;
    }
    [self.progressView setFrame:CGRectInset(self.bounds, _borderWidth, _borderWidth)];
    [self setNeedsDisplay];
}
- (void)setTopBackgroundColor:(UIColor *)topBackgroundColor {
    _topBackgroundColor = topBackgroundColor;
    [self setNeedsDisplay];
}
- (void)setBottomBackgroundColor:(UIColor *)bottomBackgroundColor {
    _bottomBackgroundColor = bottomBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setupDefaults {
    if (!self.animationDuration) {
        self.animationDuration = 0.25;
    }
    if (!self.borderRadius) {
        self.borderRadius = 15.0f;
    }
    if (!self.borderWidth) {
        self.borderWidth = 2.0f;
    }
    if (!self.bottomBackgroundColor) {
        self.bottomBackgroundColor = [UIColor colorWithWhite:0.18f alpha:0.9f];
    }
    if (!self.topBackgroundColor) {
        self.topBackgroundColor = [UIColor colorWithWhite:0.23f alpha:0.9f];
    }
    if (!self.bottomFillColor) {
        self.bottomFillColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    }
    if (!self.topFillColor) {
        self.topFillColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    }
    if (!self.stripeColor) {
        self.stripeColor = [UIColor colorWithRed:8/255.0f green:111/255.0f blue:161/255.0f alpha:1.0];
    }
    if (!self.stripeWidth) {
        self.stripeWidth = 10.0f;
    }
}


#pragma mark Helpers

- (void)regenerateStripes {
    [self.progressView setAnimationImages:[self imagesArray]];
}
- (NSArray *)imagesArray {
    NSMutableArray *a = [@[] mutableCopy];
    for (int i=self.stripeWidth; i>-self.stripeWidth; i--) {
        [a addObject:[self imageForOffset:i]];
    }
    return [NSArray arrayWithArray:a];
}


- (UIImage *)imageForOffset:(CGFloat)offset {
    CGRect rect = self.progressView.bounds;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    UIColor *stripedOnColor = self.stripeColor;
    UIColor *stripedOffColor = self.bottomFillColor;
    UIColor *stripedOffColor2 = self.topFillColor;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGFloat stripeWidth = self.stripeWidth;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = [self roundedRectWithRadius:self.borderRadius-1 rect:rect];
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, stripedOffColor.CGColor);
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    [self drawGradientInContext:ctx forRect:rect withBottomColor:stripedOffColor topColor:stripedOffColor2];
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    path = [self roundedRectWithRadius:self.borderRadius-1 rect:rect];
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(ctx, stripedOnColor.CGColor);
    CGContextSetLineWidth(ctx, stripeWidth);
    NSInteger lines = width / stripeWidth;
    for (int i=0; i<lines; i++) {
        CGFloat startX = [self startPointForLineAtOffset:offset index:i].x;
        CGFloat endX = [self endPointForLineAtOffset:offset index:i].x;
        CGContextMoveToPoint(ctx, startX, height);
        CGContextAddLineToPoint(ctx, endX, 0);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}
- (CGPoint)startPointForLineAtOffset:(NSInteger)offset index:(NSInteger)index{
    CGFloat x = (self.stripeWidth*2) * index + offset;
    CGFloat y = self.progressView.bounds.size.height;
    return CGPointMake(x, y);
}
- (CGPoint)endPointForLineAtOffset:(NSInteger)offset index:(NSInteger)index{
    CGFloat x = (self.stripeWidth * 2) * index + self.stripeWidth + offset;
    CGFloat y = 0;
    return CGPointMake(x, y);
}
- (void)drawGradientInContext:(CGContextRef)ctx forRect:(CGRect)rect withBottomColor:(UIColor *)bottomColor topColor:(UIColor *)topColor {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = { 0.0, 1.0 };
    NSArray *colors = @[(__bridge id)bottomColor.CGColor, (__bridge id)topColor.CGColor];
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGContextSaveGState(ctx);
    CGContextAddRect(ctx, rect);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(ctx);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}
- (CGMutablePathRef)roundedRectWithRadius:(CGFloat)radius rect:(CGRect)rect{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect),
                        CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect),
                        CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    return path;
}
@end
