//
//  GGdraggableDetails.h
//  208
//
//  Created by amaury soviche on 14/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGdraggableDetails : UIView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *viewXib;



@property (nonatomic) BOOL ViewDeleted;
@property (nonatomic) BOOL LoadDetailView;
@property (nonatomic) int position;
@property (nonatomic) int numeroView;

@property(nonatomic) NSString *StartupId;
@property(nonatomic) NSString *startupWebsite;

@property UIImage *image;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityInvestors;
@property (nonatomic, strong) UIActivityIndicatorView *activity;

@property ( strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
@property (strong, nonatomic) IBOutlet UILabel *labelTargeted;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewLocker;

@property (strong, nonatomic) IBOutlet UILabel *LabelRating;
@property (strong, nonatomic) IBOutlet UITextView *TextViewInvestorsLiked;


//title
@property (strong, nonatomic) IBOutlet UILabel *labelTitleLocation;
@property (strong, nonatomic) IBOutlet UILabel *labelTitleRaisedAmount;
@property (strong, nonatomic) IBOutlet UILabel *labelTitleRaisingAmount;
@property (strong, nonatomic) IBOutlet UILabel *labelTitleValuation;

//**************

-(void) StartActivity: (BOOL) isActivityLoading;
-(void) shouldStartActivity : (BOOL) value;
- (void)loadImageAndStyle : (UIImage *) imageJob;


//constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ConstrainDescriptionHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintInvestorsHeight;

@end
