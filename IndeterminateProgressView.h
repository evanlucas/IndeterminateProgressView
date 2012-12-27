//
//  IndeterminateProgressView.h
//
//  Created by Evan Lucas on 12/27/12.
//  Copyright (c) 2012 curapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndeterminateProgressView : UIView

@property (nonatomic, strong) UIColor *bottomBackgroundColor;
@property (nonatomic, strong) UIColor *topBackgroundColor;
@property (nonatomic, strong) UIColor *bottomFillColor;
@property (nonatomic, strong) UIColor *topFillColor;
@property (nonatomic, strong) UIColor *stripeColor;
@property (nonatomic, assign) CGFloat stripeWidth;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL isAnimating;
- (void)startProgressing;
- (void)stopProgressing;
@end
