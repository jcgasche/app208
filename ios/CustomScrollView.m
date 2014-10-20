//
//  CustomScrollView.m
//  208
//
//  Created by amaury soviche on 20/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "CustomScrollView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

static float const fadePercentage = 0.1;

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSObject * transparent = (NSObject *) [[UIColor colorWithWhite:0 alpha:0] CGColor];
    NSObject * opaque = (NSObject *) [[UIColor colorWithWhite:0 alpha:1] CGColor];
    
    CALayer * maskLayer = [CALayer layer];
    maskLayer.frame = self.bounds;
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(self.bounds.origin.x, 0,
                                     self.bounds.size.width, self.bounds.size.height);
    
    gradientLayer.colors = [NSArray arrayWithObjects: transparent, opaque,
                            opaque, transparent, nil];
    
    // Set percentage of scrollview that fades at top & bottom
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0],
                               [NSNumber numberWithFloat:fadePercentage],
                               [NSNumber numberWithFloat:1.0 - fadePercentage],
                               [NSNumber numberWithFloat:1], nil];
    
    [maskLayer addSublayer:gradientLayer];
    self.layer.mask = maskLayer;
}

@end
