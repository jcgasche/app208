//
//  StartupsViewController.m
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "StartupsViewController.h"
#import "SWRevealViewController.h"
#import "XMLReader.h"
#import <QuartzCore/QuartzCore.h>
#import "ScrollViewController.h"


@interface StartupsViewController ()

@property (nonatomic, strong) ScrollViewController *stlmMainViewController;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) IBOutlet UILabel *textUI;


@property (strong, nonatomic) IBOutlet UIButton *buttonReloadJobs;
@property (strong, nonatomic) IBOutlet UILabel *labelNoJobs;

@end

@implementation StartupsViewController{
    NSString *currentElement;
    NSString *currentContentforElement;
    
    NSString *status;
    NSString *email;
    
    
    NSString *tag0;
    NSString *tag1;
    NSString *tag2;
    NSString *error_message;
    
    NSDictionary *dictionaryForUserDatas;
    
    //
    NSMutableArray *ArrayStartups;
    NSMutableDictionary* dicStartup;
    
    //views datas

//    NSArray *JobsArray;//list of all the jobs
    NSMutableArray *ViewsArray; //list of all the DragViews
    NSMutableArray *JobsPicturesArray;


    int numberOfTheCurrentView;
    NSInteger IndexOfCurrentJob;
    __block int countAllJobs;
    
    
    
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
}



-(void) viewWillDisappear:(BOOL)animated{
    
//    [self removeAllObserversForDragViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.ImageViewAccept.hidden=YES;
    self.ImageViewDeny.hidden=YES;
    
    self.labelNoJobs.hidden=YES;
    self.buttonReloadJobs.hidden = YES;
    
   
    
    
    [self StartLoading];
    
    [self reloadStartups:nil];
}

- (void)rotate360WithDuration:(CGFloat)duration repeatCount:(float)repeatCount
{
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((360 * M_PI) / 180)];
    fullRotation.duration = duration;
    if (repeatCount == 0)
        fullRotation.repeatCount = MAXFLOAT;
    else
        fullRotation.repeatCount = repeatCount;
    
    [self.ImageViewLoadingDart.layer addAnimation:fullRotation forKey:@"360"];
}

-(void)viewWillAppear:(BOOL)animated{
    //OBSERVE WHEN THE VIEW IS DELETED : CALLBACK BELLOW
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSLog(@"DESC ARRAY : %@", [ViewsArray description]);
    
    if ([ViewsArray count] == 0 ) {
        [self StartLoading];
    }
}

-(void) StartLoading{
    
    self.ImageViewLoadingDart.hidden = NO;
    self.textUI.hidden = NO;
    self.buttonReloadJobs.hidden = YES;
    self.labelNoJobs.hidden=YES;
    
    if ([self.ImageViewLoadingDart.layer animationForKey:@"SpinAnimation"] == nil) {
        CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.0f];
        animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
        animation.duration = 3.0f;
        animation.repeatCount = INFINITY;
        [self.ImageViewLoadingDart.layer addAnimation:animation forKey:@"SpinAnimation"];
    }
}

-(void) StopLoading{
    
    [self.ImageViewLoadingDart.layer removeAnimationForKey:@"SpinAnimation"];

    self.textUI.hidden = YES;
    
}



- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (IBAction)goLeft:(UIButton *)sender {
    //access the parent view controller
    self.stlmMainViewController= (ScrollViewController *) self.parentViewController;
    [self.stlmMainViewController pageLeft];
}
- (IBAction)goRight:(UIButton*)sender {
    //access the parent view controller
    self.stlmMainViewController= (ScrollViewController *) self.parentViewController;
    [self.stlmMainViewController pageRight];
}


- (IBAction)reloadStartups:(UIButton *)sender {
    
    NSLog(@"reload !");
    
    NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
    NSLog(@"TOKEN PASSED : %@", [NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]);
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"] != nil) {
        
        
        [self POSTwithUrl:[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id] andData:nil andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]];
    }
    else{ //no token !
        
    }
    NSLog(@"user dictionary : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ]);
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
    [self StartLoading];
    
//    request.timeoutInterval = 15;
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!error){
            //do something with data
            if (!data) {
                [self StopLoading];
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                             options:XMLReaderOptionsProcessNamespaces
                                                               error:&error];
                NSLog(@"dic from server : %@", dict);
                

                if ([[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"] == nil ||
                         [dict objectForKey:@"html"] != nil ) {
//                    [self reloadStartups:nil];
                    self.labelNoJobs.hidden = NO;
                    self.buttonReloadJobs.hidden = NO;
                    self.ImageViewLoadingDart.hidden = YES;
                    [self StopLoading];
                    NSLog(@"BUG");
                    return ;
                }
                
                ArrayStartups = [[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"];
                if (![ArrayStartups isKindOfClass:[NSArray class]])
                {
                    // if 'list' isn't an array, we create a new array containing our object
                    ArrayStartups = [NSMutableArray arrayWithObject:ArrayStartups];
                }
                NSLog(@"this is the array for companies : %@", ArrayStartups);
                
                [self createViewsForJobs];
                [self StopLoading];
            });
            
        }
        else if (error)
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSLog(@"%@",error);
//                [self enableFields:YES];
//                [self.activityIndicator stopAnimating];
//                self.activityIndicator.hidden=YES;
                [self StopLoading];
                
                if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."]) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[error userInfo]objectForKey:@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    return;
                }
                else if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request timed out"]) {
                    
                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your connection is too slow, try later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                    return;
                }
                
//                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error : %@", [error description]);
    [self StopLoading];
}


#pragma mark - manage the frames

-(void)createViewsForJobs{
    
    
    numberOfTheCurrentView = 0;
    countAllJobs=0;
    IndexOfCurrentJob = 0;
    JobsPicturesArray = [[NSMutableArray alloc]init];
    
//    [self removeAllObserversForDragViews];
    ViewsArray = [[NSMutableArray alloc]init];
    
    self.buttonReloadJobs.hidden = YES;
    self.labelNoJobs.hidden=YES;
    
    //handle all the views for the jobs
    
    int numberOfTheJob = 0 ;
    
    
    for (int i = 0; i < [ArrayStartups count]  ; i++) {
        
        //fill the view information
        NSMutableDictionary *JobOnTop = [ArrayStartups objectAtIndex:i];
        
        //we add a view for each job
        GGDraggableView *dragView= [[GGDraggableView alloc] init];
        dragView.delegate = self;
        
        dragView.frame =CGRectMake((320-290)/2, 25, 290, 496);
        
        dragView.LabelStartupName.text =[[JobOnTop objectForKey:@"name"] objectForKey:@"text"];
        dragView.LabelStartupDescription.text =[[JobOnTop objectForKey:@"product-desc"] objectForKey:@"text"];
        dragView.StartupId = [[JobOnTop objectForKey:@"id"] objectForKey:@"text"];
        dragView.startupWebsite = [[JobOnTop objectForKey:@"website-url"] objectForKey:@"text"];
        

        if ( [[JobOnTop objectForKey:@"markets"] objectForKey:@"text"] == nil ||
             [[[JobOnTop objectForKey:@"markets"] objectForKey:@"text"] isEqualToString:@""]) {
            dragView.Market.text =@"Markets : N/A";
        }else
            dragView.Market.text =[NSString stringWithFormat:@"Markets : %@",   [[JobOnTop objectForKey:@"markets"] objectForKey:@"text"]];
        
        dragView.HighConcept.text =[NSString stringWithFormat:@"%@",   [[JobOnTop objectForKey:@"high-concept"] objectForKey:@"text"]];
        dragView.LabelLocation.text =[NSString stringWithFormat:@"%@",   [[JobOnTop objectForKey:@"location"] objectForKey:@"text"]];
        
        if ([[[JobOnTop objectForKey:@"pre-money-valuation"] objectForKey:@"text"] integerValue] == 0)
            dragView.PreMoneyValuation.text =@"N/A";
        else
            dragView.PreMoneyValuation.text =[NSString stringWithFormat:@"$ %@", [self thousandsSeparator:[[JobOnTop objectForKey:@"pre-money-valuation"] objectForKey:@"text"]]];
        
        if ([[[JobOnTop objectForKey:@"raising-amount"] objectForKey:@"text"] integerValue] == 0) {
            dragView.RaisingAmount.text = @"N/A";
        }else
            dragView.RaisingAmount.text =[NSString stringWithFormat:@"$ %@",[self thousandsSeparator:[[JobOnTop objectForKey:@"raising-amount"] objectForKey:@"text"]] ];
        
        if ([[[JobOnTop objectForKey:@"raised-amount"] objectForKey:@"text"] integerValue] == 0) {
            dragView.LabelRaisedAmount.text = @"N/A";
        }else
            dragView.LabelRaisedAmount.text =[NSString stringWithFormat:@"$ %@",  [self thousandsSeparator:[[JobOnTop objectForKey:@"raised-amount"] objectForKey:@"text"]] ];
        
        
        dragView.numeroView = numberOfTheJob;
        
        [dragView setUserInteractionEnabled:NO];
        
        if (numberOfTheJob == 0){
            dragView.frame = CGRectMake((320-300)/2, 15, 300, 496);
            [dragView setUserInteractionEnabled:YES];
        }
        
        if( numberOfTheJob < 2 )
            [self.view addSubview:dragView]; //print only 2 jobs
        
        [ViewsArray addObject:dragView];
        
        if ([[JobOnTop objectForKey:@"logo-url"] objectForKey:@"text"]) {
            [dragView StartActivity:YES];
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[JobOnTop objectForKey:@"logo-url"] objectForKey:@"text"]]];
                
                if ( data == nil ){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [dragView StartActivity:NO];
                    });
                    
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [dragView loadImageAndStyle:[UIImage imageWithData:data]];
                    
                });
            });
        }
        
        //OBSERVE WHEN THE VIEW IS DELETED : CALLBACK BELLOW
//        [dragView addObserver:self forKeyPath:@"ViewDeleted" options:NSKeyValueObservingOptionNew context:nil];
//        [dragView addObserver:self forKeyPath:@"LoadDetailView" options:NSKeyValueObservingOptionNew context:nil];
//        [dragView addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
        
        numberOfTheJob++;
        countAllJobs++;
    }
    
    NSLog(@"array startups : %@", ArrayStartups);
    NSLog(@"array views : %@", ViewsArray);
    
    if ([ViewsArray count]) { // there are jobs
        GGDraggableView *dragCurrentView2 = [ViewsArray objectAtIndex: 0];
        [self.view bringSubviewToFront:dragCurrentView2];
    }else{ //no jobs
        self.buttonReloadJobs.hidden=NO;
        self.labelNoJobs.hidden=NO;
    }
    
    self.textUI.hidden=YES;
}

#pragma mark ggdraggable delegate

-(void) PositionGGdraggableViewChanged : (int) position{
    NSLog(@"position delegate  : %d", position);
    
    int pos = position;
    
    static int factor = 2;
    
#define VIEW_WIDTH self.view.frame.size.width
    
    
    if (pos < 0) { //position < 0 : deny view
        
        self.ImageViewDeny.hidden=NO;
        [self.view bringSubviewToFront:self.ImageViewDeny];
        
        CGRect frame_deny = self.ImageViewDeny.frame;
        frame_deny.origin.x =  - frame_deny.size.width + 30*factor*(-pos/frame_deny.size.width);
        if (frame_deny.origin.x > 0) {
            frame_deny.origin.x = 0;
        }
        self.ImageViewDeny.frame = frame_deny;
        
        CGRect frame_accept = self.ImageViewAccept.frame;
        frame_accept.origin.x = VIEW_WIDTH;
        self.ImageViewAccept.frame = frame_accept;
    }
    
    if (pos > 0){ //position >0  : accept view
        
        self.ImageViewAccept.hidden=NO;
        [self.view bringSubviewToFront:self.ImageViewAccept];
        
        CGRect frame_accept = self.ImageViewAccept.frame;
        frame_accept.origin.x = VIEW_WIDTH - 30*factor*(pos/frame_accept.size.width);
        if (frame_accept.origin.x <= VIEW_WIDTH - frame_accept.size.width) {
            frame_accept.origin.x = self.view.frame.size.width - frame_accept.size.width;
        }
        self.ImageViewAccept.frame = frame_accept;
        
        CGRect frame_deny = self.ImageViewDeny.frame;
        frame_deny.origin.x = - VIEW_WIDTH;
        self.ImageViewDeny.frame = frame_deny;
    }
    else if (pos == 0){
        self.ImageViewAccept.hidden=YES;
        self.ImageViewDeny.hidden=YES;
    }
    
}

-(void) GGdraggableViewWasSwiped : (GGDraggableView*)view{
    NSLog(@"view right delegate : %@", [view description]);
    
    GGDraggableView *dragCurrentView = [ViewsArray objectAtIndex: numberOfTheCurrentView ];

    [dragCurrentView removeFromSuperview];
    dragCurrentView=nil;
    
    if (numberOfTheCurrentView + 1 == countAllJobs) {
        [self StartLoading];
        [self reloadStartups:nil];
    }
    
    numberOfTheCurrentView++;
    
    if (numberOfTheCurrentView + 1 < countAllJobs ) { //countalljobs - 1 : array begins at 0 !
        NSLog(@"nb all jobs : %d", countAllJobs);
        
        GGDraggableView *dragView = [ViewsArray objectAtIndex: (numberOfTheCurrentView + 1)];
        [self.view addSubview:dragView];
        if (numberOfTheCurrentView + 2 == countAllJobs) {
            [dragView setUserInteractionEnabled:YES];
        }
        
        GGDraggableView *dragCurrentView2 = [ViewsArray objectAtIndex: numberOfTheCurrentView ];
        [self.view bringSubviewToFront:dragCurrentView2];
        [dragCurrentView2 setUserInteractionEnabled:YES];
        
        [UIView animateWithDuration:0.1 animations:^{
            dragCurrentView2.frame =  CGRectMake((320-300)/2, 15, 300, 496);
        }];
    }
    
    //handle the view on the side : green/red
    CGRect frame_accept = self.ImageViewAccept.frame;
    frame_accept.origin.x = VIEW_WIDTH +  frame_accept.size.width;;
    self.ImageViewAccept.frame = frame_accept;
    
    CGRect frame_deny = self.ImageViewDeny.frame;
    frame_deny.origin.x =  - frame_deny.size.width;;
    self.ImageViewDeny.frame = frame_deny;

}

#pragma mark other

-(NSString *) thousandsSeparator : (NSString*) stringValueForInt{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    //        [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    //        [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.groupingSeparator = @"'";
    numberFormatter.groupingSize = 3;
    NSString *numberString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger: [stringValueForInt integerValue]]];
    return numberString;
}




@end
