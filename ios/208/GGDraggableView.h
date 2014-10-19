//
//  GGDraggableView.h
//  Cash Now
//
//  Created by amaury soviche on 09.05.14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGDraggableView : UIView

//XIB view
@property (strong, nonatomic) IBOutlet UIView *ViewXib;

@property (nonatomic) BOOL ViewDeleted;
@property (nonatomic) BOOL LoadDetailView;
@property (nonatomic) int position;
@property (nonatomic) int numeroView;

@property(nonatomic) NSString *StartupId;
@property(nonatomic) NSString *startupWebsite;

@property (nonatomic, strong) UIActivityIndicatorView *activity;

//IBOutlet ****
//@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *ImageViewStartup;

@property (strong, nonatomic) IBOutlet UILabel *LabelStartupName;
@property (strong, nonatomic) IBOutlet UILabel *HighConcept;
@property (strong, nonatomic) IBOutlet UILabel *LabelLocation;
@property (strong, nonatomic) IBOutlet UITextView *LabelStartupDescription;
@property (strong, nonatomic) IBOutlet UILabel *Market;
@property (strong, nonatomic) IBOutlet UILabel *LabelRaisedAmount;

@property (strong, nonatomic) IBOutlet UILabel *RaisingAmount;
@property (strong, nonatomic) IBOutlet UILabel *PreMoneyValuation;

//**************

-(void) StartActivity: (BOOL) isActivityLoading;
- (void)loadImageAndStyle : (UIImage *) imageJob;

@end
