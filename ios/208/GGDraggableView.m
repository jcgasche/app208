//
//  GGDraggableView.m
//  Cash Now
//
//  Created by amaury soviche on 09.05.14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "GGDraggableView.h"
#import "GGOverlayView.h"


@interface GGDraggableView ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property(nonatomic, strong) GGOverlayView *overlayView;
@property(nonatomic) CGPoint originalPoint;

@property(nonatomic) CGFloat xOriginal;

@end

@implementation GGDraggableView{
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    
}

@synthesize LabelName= _LabelName;

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setup{
    [[NSBundle mainBundle] loadNibNamed:@"ViewStartup" owner:self options:nil];
    [self addSubview:self.view];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    

    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    //    [self loadImageAndStyle];
    
    self.overlayView = [[GGOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    
    
    //    UIColor *colorRed2 = [UIColor colorWithRed:0.796 green:0.3019 blue:0.3607 alpha:1];
    self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = [UIColorFromRGB(0xEB5745) CGColor];
    

    
//
//    
    self.LabelStartupName = [[UILabel alloc]init];
    [self addSubview:self.LabelStartupName];
//    [self.LabelDateJob setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    self.LabelStartupName.frame = CGRectMake(115, 55, 190, 20);
//    self.LabelDateJob.textColor = UIColorFromRGB(0x225378);
    
    
    //labels
    self.LabelStartupDescription = [[UITextView alloc]init];
    [self addSubview:self.LabelStartupDescription];
    self.LabelStartupDescription.editable=YES;
    [self.LabelStartupDescription setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:16]];
     self.LabelStartupDescription.editable=NO;
    self.LabelStartupDescription.frame = CGRectMake(10, 140, 270,100);
//    self.LabelDescriptionJob.textColor = UIColorFromRGB(0x225378);

//
    self.Market = [[UILabel alloc]init];
    [self addSubview:self.Market];
        [self.Market setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    self.Market.frame = CGRectMake(10, 260, 270,20);
    //    self.DistanceToUser.textColor = UIColorFromRGB(0x225378);
    
    self.RaisingAmount = [[UILabel alloc]init];
    [self addSubview:self.RaisingAmount];
    [self.RaisingAmount setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    self.RaisingAmount.frame = CGRectMake(10, 290, 280,20);
//    self.LabelPriceJob.textColor = UIColorFromRGB(0x225378);
//
    self.PreMoneyValuation = [[UILabel alloc]init];
    [self addSubview:self.PreMoneyValuation];
    [self.PreMoneyValuation setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    self.PreMoneyValuation.frame = CGRectMake(10, 320, 280,20);
//    self.LabelHourJob.textColor = UIColorFromRGB(0x225378);
//

//
//    
//    //ICONS
//    
//    UIImageView *iconLoc = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"icon-location"]];
//    [self addSubview:iconLoc];
//    iconLoc.contentMode = UIViewContentModeScaleAspectFit;
//    iconLoc.frame = CGRectMake(10, 10, 30,35);
//
//    UIImageView *iconCal = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"icon-calendar"]];
//    [self addSubview:iconCal];
//    iconCal.contentMode = UIViewContentModeScaleAspectFit;
//    iconCal.frame = CGRectMake(95, 390, 28,31);
//    
//    UIImageView *iconClock = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"icon-clock"]];
//    [self addSubview:iconClock];
//    iconClock.contentMode = UIViewContentModeScaleAspectFit;
//    iconClock.frame = CGRectMake(160, 390, 30,30);
//    
//    UIImageView *iconDollar = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"icon-dollar"]];
//    [self addSubview:iconDollar];
//    iconDollar.contentMode = UIViewContentModeScaleAspectFit;
//    iconDollar.frame = CGRectMake(225, 390, 30,30);
//    
//    
//    //lines
//    UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"line_grey"]];
//    [self addSubview:line2];
//    line2.contentMode = UIViewContentModeScaleAspectFit;
//    line2.frame = CGRectMake(80, 240, 130,5);
//    
//    UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"line_grey"]];
//    [self addSubview:line1];
//    line1.contentMode = UIViewContentModeScaleAspectFit;
//    line1.frame = CGRectMake(80, 350, 130,30);
    
    //launch loading
//    self.activity = [[UIActivityIndicatorView alloc]init];
//    [self.activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
//    [self.activity setCenter:CGPointMake( frame.size.width / 2 - self.activity.frame.size.width/2, 150)];
//    [self addSubview:self.activity];
//    self.activity.hidesWhenStopped = YES;
    
    return self;
}

-(void) tapped: (UITapGestureRecognizer *) tapGestureRecognizer {
    
    self.LoadDetailView = YES;
}

- (void)loadImageAndStyle : (UIImage *) imageJob
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageJob];
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    imageView.frame = CGRectMake(25, 25, 77, 77);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.clipsToBounds=YES;
    imageView.layer.cornerRadius=3;
}


- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    
    NSLog(@"position drag : %f",xDistance);
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            self.originalPoint = self.center;

            self.xOriginal = [gestureRecognizer locationInView:self].x;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            
//            if (self.xOriginal > 80) {
            
                self.position = xDistance;
                
                CGFloat rotationStrength = MIN(xDistance / 320, 1);
                CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
                CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
                CGFloat scale = MAX(scaleStrength, 0.93);
                CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
                CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
                self.transform = scaleTransform;
                self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
                
                
                NSLog(@"ori point : %f",self.xOriginal);
                
//        }
            
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
//            if (self.xOriginal > 80) {
                if (xDistance > 150   ) { //like
                    
                    [self FollowStartup];
                    
                    [self deallocTheView];
                    
                }else if (xDistance < -150){ //don't like
                    [self deallocTheView];
                }
                else{//pas assez loin
                    self.position=0;
                    [self resetViewPositionAndTransformations];
                }
                NSLog(@"distance : %f and %f", xDistance , yDistance);
//            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

-(void) FollowStartup{
    [self POSTwithUrl:[NSString stringWithFormat:@"http://app208.herokuapp.com/user/%@/company/%@/follow", [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"]objectForKey:@"user_id"] , self.StartupId] andData:nil andParameters:nil];
    

//    http://app208.herokuapp.com
}

-(void) DoNotFollowStartup{
    [self POSTwithUrl:[NSString stringWithFormat:@"http://app208.herokuapp.com/user/%@/company/%@/notfollow", [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"], self.StartupId] andData:nil andParameters:nil];
}

- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = GGOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = GGOverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / 100, 0.4);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                         self.overlayView.alpha = 0;
                     }];
}



- (void)deallocTheView
{
    
    NSLog(@"numero de la vue deleted : %d",self.numeroView);
    self.ViewDeleted = YES;
    [self removeGestureRecognizer:self.panGestureRecognizer];
    
    //the view is removed in the viewcontroller.m with KVO
}



#pragma mark - follow / unfollow



#pragma mark connection

-(void) POSTwithUrl:(NSString*)url andData:(NSData*)data andParameters:(NSString*)post{
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    //    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //    [self enableFields:NO];
    
    request.timeoutInterval = 15;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!error){
            //do something with data
            if (!data) {
                NSLog(@"no data rendered from server");
                //                [self enableFields:YES];
                //                [self.activityIndicator stopAnimating];
                //                self.activityIndicator.hidden=YES;
            }
            
            NSLog(@"data response : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
            NSData * XMLData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUnicodeStringEncoding];
            NSXMLParser * parser = [[NSXMLParser alloc] initWithData:XMLData];
            [parser setDelegate:self];
            [parser setShouldProcessNamespaces:YES]; // if you need to
            [parser parse]; // start parsing
            
        }
        else if (error)
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%@",error);
                //                [self enableFields:YES];
                //                [self.activityIndicator stopAnimating];
                //                self.activityIndicator.hidden=YES;
                
                if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."]) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[error userInfo]objectForKey:@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    return;
                }
                else if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request timed out"]) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your connection is too slow, try later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    return;
                }
                
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error : %@", [error description]);
}





@end
