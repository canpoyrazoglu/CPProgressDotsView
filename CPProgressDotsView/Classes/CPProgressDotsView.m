//
//  CPProgressDotsView.m
//  CPProgressDotsView
//
//  Created by Can Poyrazoğlu on 15.05.2018.
//  Copyright © 2018 Can. All rights reserved.
//

#import "CPProgressDotsView.h"

@implementation CPProgressDotsView{
    float dotWidth;
}


- (void)drawRect:(CGRect)rect {
    if(!self.layer.sublayers.count){
        [self recreateLayers];
    }
}

-(void)addSubview:(UIView *)view{
    NSAssert(NO, @"Subviews inside CPProgressDotsView are not supported.");
}

-(void)setAnimationScaleFactor:(float)animationScaleFactor{
    if(!animationScaleFactor){
        animationScaleFactor = 1;
    }
    _animationScaleFactor = animationScaleFactor;
    [self invalidateLayers];
}

-(void)setDelayBetweenAnimationCycles:(float)delayBetweenAnimationCycles{
    _delayBetweenAnimationCycles = delayBetweenAnimationCycles;
    [self invalidateLayers];
}

-(void)recreateLayers{
    float totalWidthOccupiedByDistance = self.distanceBetweenDots * (_dotCount - 1);
    float availableWidth = self.bounds.size.width - totalWidthOccupiedByDistance;
    float availableHeight = self.bounds.size.height;
    float width = availableWidth;
    dotWidth = width / _dotCount;
    float xOffset = 0;
    float yOffset = 0;
    if(dotWidth > availableHeight){
        dotWidth = availableHeight;
        xOffset = (self.bounds.size.width - totalWidthOccupiedByDistance - (availableHeight * _dotCount)) / 2;
        
    }else if(dotWidth < availableHeight){
        yOffset = (availableHeight - dotWidth) / 2;
    }
    
    for (int i = 0; i < _dotCount; i++) {
        float x = xOffset + (dotWidth * i) + (_distanceBetweenDots * i);
        float y = yOffset;
        CGRect circleRect = CGRectMake(x, y, dotWidth, dotWidth);
        CALayer *layer = [[CALayer alloc] init];
        layer.backgroundColor = _dotColor.CGColor;
        layer.frame = circleRect;
        CAShapeLayer *circularMask = [[CAShapeLayer alloc] init];
        circularMask.path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, dotWidth, dotWidth), nil);
        circularMask.fillColor = [UIColor whiteColor].CGColor;
        layer.mask = circularMask;
        [self.layer addSublayer:layer];
        
        
        
        
#if TARGET_INTERFACE_BUILDER
        CATransform3D transform = [self transformForScaledCircle];
        if(i){
            layer.transform = transform;
        }
#else
        [self animateSublayers];
#endif
    }
}

-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if(hidden){
        for (CALayer *layer in self.layer.sublayers) {
            [layer removeAllAnimations];
        }
    }else{
        [self animateSublayers];
    }
}

-(void)animateSublayers{
    if(!_animationDuration || self.isHidden){
        return;
    }
    CATransform3D scaleTransform = [self transformForScaledCircle];
    float singleDuration = (_animationDuration - ((_dotCount - 1) * _animationDelayBetweenDots)) / _dotCount;
    UIColor *highlightColor = _animatingDotColor;
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        CAShapeLayer *layer = (CAShapeLayer*)self.layer.sublayers[i];
        layer.transform = scaleTransform;
        float animationStartDelay = i * _animationDelayBetweenDots;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationStartDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CATransaction begin];
            //scale animation
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
            scaleAnimation.duration = singleDuration;
            scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
            scaleAnimation.autoreverses = YES;
            [layer addAnimation:scaleAnimation forKey:@"scaleAnimation"];
            //color animation
            if(highlightColor){
                CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
                colorAnimation.duration = singleDuration;
                colorAnimation.toValue = (id)highlightColor.CGColor;
                colorAnimation.autoreverses = YES;
                [layer addAnimation:colorAnimation forKey:@"colorAnimation"];
            }
            
            [CATransaction commit];
        });
    }
    float delay = _animationDuration + _delayBetweenAnimationCycles;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animateSublayers];
    });
}

-(CATransform3D)transformForScaledCircle{
    float scaleFactor = _animationScaleFactor ? _animationScaleFactor : 1;
    CATransform3D transform = CATransform3DIdentity;
    // transform = CATransform3DTranslate(transform, dotWidth / scaleFactor / 2, dotWidth / scaleFactor / 2, 0);
    transform = CATransform3DScale(transform, scaleFactor, scaleFactor, 1);
   // transform = CATransform3DTranslate(transform, -dotWidth / 2, -dotWidth / 2, 0);
    
    return transform;
}

-(void)invalidateLayers{
    NSArray *layers = self.layer.sublayers.copy;
    for (CALayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
}

-(void)setDistanceBetweenDots:(float)distanceBetweenDots{
    _distanceBetweenDots = distanceBetweenDots;
    [self invalidateLayers];
}

-(void)setAnimatingDotColor:(UIColor *)animatingDotColor{
    _animatingDotColor = animatingDotColor;
    [self invalidateLayers];
}

-(void)setDotColor:(UIColor *)dotColor{
    if(!dotColor){
        dotColor = [UIColor grayColor];
    }
    _dotColor = dotColor;
    [self invalidateLayers];
}

-(void)setDotCount:(int)dotCount{
    if(!dotCount){
        dotCount = 3;
    }
    _dotCount = dotCount;
    [self invalidateLayers];
}


@end
