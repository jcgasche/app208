//
//  GGDraggableView.h
//  Cash Now
//
//  Created by amaury soviche on 09.05.14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGDraggableView : UIView

@property (nonatomic) BOOL ViewDeleted;
@property (nonatomic) BOOL LoadDetailView;
@property (nonatomic) int position;




@property (nonatomic) int numeroView;

@property (strong, nonatomic) IBOutlet UIImageView *imageJob;

@property (strong, nonatomic) IBOutlet UILabel *RaisingAmount;
@property (strong, nonatomic) IBOutlet UILabel *PreMoneyValuation;
@property (strong, nonatomic) IBOutlet UIView *ViewSingleJob;
@property (strong, nonatomic) IBOutlet UILabel *Market;

@property(nonatomic) NSString *JobID;

- (void)loadImageAndStyle : (UIImage *) imageJob;

@property (nonatomic, strong) UIActivityIndicatorView *activity;


@property (strong, nonatomic) IBOutlet UILabel *LabelName;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIView *view;



@property (strong, nonatomic) IBOutlet UITextView *LabelStartupDescription;
@property (strong, nonatomic) IBOutlet UILabel *LabelStartupName;

@property(nonatomic) NSString *StartupId;

@end
