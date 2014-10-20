//
//  StartupsViewController.h
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGDraggableView.h"
@interface StartupsViewController : UIViewController<NSURLConnectionDelegate, NSXMLParserDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIAlertViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate, GGdragableProtocol>

@property(strong, nonatomic) IBOutlet UIImageView *ImageViewAccept;
@property(strong, nonatomic) IBOutlet UIImageView *ImageViewDeny;

@property (strong, nonatomic) IBOutlet UIImageView *ImageViewLoadingDart;

@end
