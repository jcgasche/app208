//
//  DetaillsStartupViewController.h
//  208
//
//  Created by amaury soviche on 14/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareView.h"

@interface DetaillsStartupViewController : UIViewController<UIWebViewDelegate, MyUIViewDelegate>{
    ShareView* shareView;
}
@property (nonatomic, retain) IBOutlet ShareView* shareView;


@property (nonatomic) NSString *startupId;

@property (nonatomic) NSString *rate;

@end
