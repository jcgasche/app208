//
//  MyCustomSeguePushForward.m
//  208
//
//  Created by amaury soviche on 19/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "MyCustomSeguePushForward.h"

@implementation MyCustomSeguePushForward
-(void) perform {
    
    UIView *preV = ((UIViewController *)self.sourceViewController).view;
    UIView *newV = ((UIViewController *)self.destinationViewController).view;
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    newV.center = CGPointMake(preV.center.x - preV.frame.size.width, newV.center.y);
    [window insertSubview:newV aboveSubview:preV];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         newV.center = CGPointMake(preV.center.x, newV.center.y);
                         preV.center = CGPointMake(0- preV.center.x, newV.center.y);}
                     completion:^(BOOL finished){
                         [preV removeFromSuperview];
                         window.rootViewController = self.destinationViewController;
                     }];
}
@end
