//
//  GGdraggableDetails.h
//  208
//
//  Created by amaury soviche on 14/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGdraggableDetails : UIView

@property (strong, nonatomic) IBOutlet UIView *viewXib;



@property (nonatomic) BOOL ViewDeleted;
@property (nonatomic) BOOL LoadDetailView;
@property (nonatomic) int position;
@property (nonatomic) int numeroView;

@property(nonatomic) NSString *StartupId;
@property(nonatomic) NSString *startupWebsite;

@property UIImage *image;

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

@property (strong, nonatomic) IBOutlet UILabel *LabelRating;
@property (strong, nonatomic) IBOutlet UITextView *TextViewInvestorsLiked;
//**************

-(void) StartActivity: (BOOL) isActivityLoading;
- (void)loadImageAndStyle : (UIImage *) imageJob;

@end
