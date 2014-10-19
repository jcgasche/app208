//
//  GGDraggableView.m
//  Cash Now
//
//  Created by amaury soviche on 09.05.14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "GGDraggableView.h"
#import "GGOverlayView.h"
#import "QuartzCore/QuartzCore.h"

@interface GGDraggableView ()
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property(nonatomic, strong) GGOverlayView *overlayView;
@property(nonatomic) CGPoint originalPoint;

@property(nonatomic) CGFloat xOriginal;

@end

@implementation GGDraggableView{
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    
    #define color_red UIColorFromRGB(0xCA1C35)
    #define color_gray UIColorFromRGB(0x929292)
    #define color_gray_dark UIColorFromRGB(0x6C6c6c)
    #define color_blue UIColorFromRGB(0x338390)
    
    UIImage *imageJobLocal;
    
}

//@synthesize LabelName= _LabelName;

-(id) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    
    //1. load xib file
    [[NSBundle mainBundle] loadNibNamed:@"GGdragViewStartup" owner:self options:nil];

    //2. adjust bounds
    self.bounds = self.ViewXib.bounds;
    
    //3. add as a subview
    [self addSubview:self.ViewXib];
    
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    

    self.layer.cornerRadius = 4.0f;
    self.layer.borderWidth = 1.0f;
    self.layer.borderColor = color_blue.CGColor;
    self.clipsToBounds = YES;
    
    

//    self.LabelStartupName = [[UILabel alloc]init];
//    [self addSubview:self.LabelStartupName];
//    self.LabelStartupName.adjustsFontSizeToFitWidth = YES;
//    self.LabelStartupName.minimumFontSize = 0;
    [self.LabelStartupName setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:21]];
//    self.LabelStartupName.textColor = color_red ;
//    self.LabelStartupName.frame = CGRectMake(120, 20, self.frame.size.width - 120 - 5, 35);

//    self.HighConcept = [[UILabel alloc]init];
//    [self addSubview:self.HighConcept];
//    self.HighConcept.adjustsFontSizeToFitWidth = YES;
//    self.HighConcept.minimumFontSize = 0;
//    self.HighConcept.numberOfLines = 2;
    [self.HighConcept setFont:[UIFont fontWithName:@"ProximaNova-Semibold" size:14]];
//    self.HighConcept.textColor = color_gray ;
//    self.HighConcept.frame = CGRectMake(120, 45, 160, 40);
//    
//    self.LabelLocation = [[UILabel alloc]init];
//    [self addSubview:self.LabelLocation];
    [self.LabelLocation setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
//    self.LabelLocation.textColor = color_gray ;
//    self.LabelLocation.frame = CGRectMake(120, 85, 160, 20);
//
//    UIView *line= [[UIView alloc]init]; //******************************************************************
//    [self addSubview:line];
//    line.backgroundColor = color_red;
//    line.frame = CGRectMake(0, 115, self.frame.size.width, 1);
//    
//    //labels
//    self.LabelStartupDescription = [[UITextView alloc]init];
//    [self addSubview:self.LabelStartupDescription];
    self.LabelStartupDescription.editable=YES;
    [self.LabelStartupDescription setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14]];
    self.LabelStartupDescription.textColor = color_gray_dark;
     self.LabelStartupDescription.editable=NO;
//    self.LabelStartupDescription.frame = CGRectMake(17, 135, 257,115);
//
//    
//    self.Market = [[UILabel alloc]init];
//    [self addSubview:self.Market];
//    self.Market.numberOfLines = 2;
    [self.Market setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
//    self.Market.frame = CGRectMake(20, 270, 257,40);
//    self.Market.textColor = color_gray;
//
//    
//    self.LabelRaisedAmount = [[UILabel alloc]init];
//    [self addSubview:self.LabelRaisedAmount];
    [self.LabelRaisedAmount setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
//    self.LabelRaisedAmount.frame = CGRectMake(20, 328, 257,46);
//    self.LabelRaisedAmount.textColor = color_gray;
//    
//    
//    
//    self.RaisingAmount = [[UILabel alloc]init];
//    [self addSubview:self.RaisingAmount];
    [self.RaisingAmount setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
//    self.RaisingAmount.frame = CGRectMake(20, 374, 257,46);
//    self.RaisingAmount.textColor = color_red;
//    
//
//
//    self.PreMoneyValuation = [[UILabel alloc]init];
//    [self addSubview:self.PreMoneyValuation];
    [self.PreMoneyValuation setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:15]];
//    self.PreMoneyValuation.frame = CGRectMake(20, 414, 257,46);
//    self.PreMoneyValuation.textColor = color_red;
//
//    self.activity = [[UIActivityIndicatorView alloc]init];
//    self.activity.color = color_red;
//    self.activity.center = CGPointMake(55, 50);
//    self.activity.hidden = YES;
//    [self addSubview:self.activity];
    
    return self;
}

-(void) StartActivity: (BOOL) isActivityLoading{
    self.activity.hidden = !isActivityLoading;
    if (isActivityLoading) {
        [self.activity startAnimating];
    }else {
        [self.activity stopAnimating];
    }
}

-(void) tapped: (UITapGestureRecognizer *) tapGestureRecognizer {
    
    self.LoadDetailView = YES;
}

- (void)loadImageAndStyle : (UIImage *) imageJob
{
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:imageJob];
    imageJobLocal = imageJob;
    self.ImageViewStartup.image = imageJob;
//    imageView.clipsToBounds = YES;
//    [self addSubview:imageView];
//    imageView.frame = CGRectMake(20, 20, 77, 77);
    
    self.ImageViewStartup.clipsToBounds=YES;
    self.ImageViewStartup.layer.cornerRadius=3;
    
    [self StartActivity:NO];
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
                    
                    [self DoNotFollowStartup];
                    
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

#pragma mark - follow / unfollow

-(void) FollowStartup{
    
   
    
    [self POSTwithUrl:[NSString stringWithFormat:@"http://app208.herokuapp.com/user/%@/company/%@/follow", [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"]objectForKey:@"user_id"] , self.StartupId] andData:nil andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"] ]];
    
    
    //save the startup info in plist
    
//     dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSMutableDictionary * dicStartupToSave = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                  self.LabelStartupDescription.text, @"description",
                                                  self.LabelLocation.text , @"location",
                                                  self.startupWebsite , @"website",
                                                  self.HighConcept.text, @"highConcept",
                                                  self.LabelRaisedAmount.text, @"raisedAmount",
                                                  self.LabelStartupName.text, @"name",
                                                  self.StartupId, @"id",
                                                  self.PreMoneyValuation.text, @"preMoneyValuation",
                                                  self.RaisingAmount.text, @"raisingAmount",
                                                  self.Market.text, @"market", nil];
        
        NSLog(@"dic to save : %@", [dicStartupToSave description]);
        
        NSLog(@"image : %@", [imageJobLocal description]);

    NSData *imageData = UIImagePNGRepresentation(imageJobLocal);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.StartupId]];
    [dicStartupToSave setObject:imagePath forKey:@"imagePath"];
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog(@"Failed to cache image data to disk");
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
    
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//        NSString *docs = [paths objectAtIndex:0];
//        NSString* path =  [docs stringByAppendingFormat:[NSString stringWithFormat:@"/%@.jpg",self.StartupId]];
//        [dicStartupToSave setObject:path forKey:@"imagePath"];
//        NSData* imageData = [NSData dataWithData:UIImageJPEGRepresentation(imageJobLocal, .8)];
//        NSError *writeError = nil;
//        
//        if(![imageData writeToFile:path options:NSDataWritingAtomic error:&writeError]) {
//            NSLog(@"%@: Error saving image: %@", [self class], [writeError localizedDescription]);
//        }
//        
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                             NSUserDomainMask, YES);
//        [dicStartupToSave setObject:paths forKey:@"imagePath"];
//        
//        NSString *documentsDirectory = [paths objectAtIndex:0];
//        NSString* path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%@.png",self.StartupId] ];
//        NSData* data = UIImagePNGRepresentation(imageJobLocal);
//        [data writeToFile:path atomically:YES];
    

        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DicLikedStartups"] == nil) {

            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary dictionaryWithObject:dicStartupToSave forKey:[dicStartupToSave objectForKey:@"id"]] forKey:@"DicLikedStartups"];
        }else{
            NSMutableDictionary *ArrayLikedStartups = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicLikedStartups"] mutableCopy];
            [ArrayLikedStartups setObject:dicStartupToSave forKey:[dicStartupToSave objectForKey:@"id"]];
            [[NSUserDefaults standardUserDefaults] setObject:ArrayLikedStartups forKey:@"DicLikedStartups"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"nsuser def startups : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"DicLikedStartups"]);
        
//    });
}

-(void) DoNotFollowStartup{
    
    NSLog(@"files : %@ and %@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"user_id"], self.StartupId );
    
    [self POSTwithUrl:[NSString stringWithFormat:@"http://app208.herokuapp.com/user/%@/company/%@/notfollow", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"user_id"], self.StartupId] andData:nil andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"] ]];
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

            
//            NSData * XMLData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUnicodeStringEncoding];
//            NSXMLParser * parser = [[NSXMLParser alloc] initWithData:XMLData];
//            [parser setDelegate:self];
//            [parser setShouldProcessNamespaces:YES]; // if you need to
//            [parser parse]; // start parsing
            
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
