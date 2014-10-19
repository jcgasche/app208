//
//  ShareView.h
//  208
//
//  Created by amaury soviche on 19/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyUIViewDelegate;

@interface ShareView : UIView

@property (nonatomic, assign) id<MyUIViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIView *viewXib;
@property (strong,nonatomic) NSString * hightContent;
@property (strong,nonatomic) NSString * startupName;
@property (strong,nonatomic) NSString * websiteStartup;
@property (strong,nonatomic) NSString * messageToShare;



@end

@protocol MyUIViewDelegate <NSObject>
- (void)dismissCustomView:(ShareView*)myUIView;
@end
