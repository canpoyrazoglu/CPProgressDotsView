//
//  CPProgressDotsView.h
//  CPProgressDotsView
//
//  Created by Can Poyrazoğlu on 15.05.2018.
//  Copyright © 2018 Can. All rights reserved.
//

@import UIKit;


IB_DESIGNABLE
@interface CPProgressDotsView : UIView

/// Number of dots to display.
@property(nonatomic) IBInspectable int dotCount;

/// Color of the dots when not animating.
@property(nonatomic) IBInspectable UIColor *dotColor;

/// Color of a dot when animating.
@property(nonatomic) IBInspectable UIColor *animatingDotColor;

/// Distance between two individual dots.
@property(nonatomic) IBInspectable float distanceBetweenDots;

/// Scaling to apply for animation. Note that dots will be at this scale by default, and will fill the container's available area when animating.
@property(nonatomic) IBInspectable float animationScaleFactor;

/// Total duration of one full animation cycle.
@property(nonatomic) IBInspectable float animationDuration;

/// Delay between animating two consecutive dots. Setting this to zero causes all dots to animate simultaneously.
@property(nonatomic) IBInspectable float animationDelayBetweenDots;

/// Time to wait between each full animation cycle.
@property(nonatomic) IBInspectable float delayBetweenAnimationCycles;

@end
