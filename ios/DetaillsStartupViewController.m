//
//  DetaillsStartupViewController.m
//  208
//
//  Created by amaury soviche on 14/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "DetaillsStartupViewController.h"
#import "GGdraggableDetails.h"
#import "XMLReader.h"
#import "ScrollViewController.h"
#import "ShareViewController.h"
#import "ShareView.h"

@interface DetaillsStartupViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end



@implementation DetaillsStartupViewController{
    GGdraggableDetails *dragView;
}
@synthesize shareView;

-(void) viewWillAppear:(BOOL)animated{
//    CGRect frame = self.segmentControl.frame;
//    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
//    self.segmentControl.frame = frame;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont fontWithName:@"ProximaNova-Regular" size:14], UITextAttributeFont, nil];
    [self.segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSDictionary *DicStartup = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicLikedStartups"] objectForKey:self.startupId];
    
    self.webView.hidden=YES;
    self.webView.frame = CGRectMake(0, 0, 0, 0);

    
    if ( ! [DicStartup objectForKey:@"website"]) {
//        self.segmentControl.enabled = NO;
//        [self.segmentControl setTitle:@"No website" forSegmentAtIndex:1];
        self.segmentControl.hidden = YES;
        
    }
    
    //we add a view for each job
    
    NSLog(@"dic for startups : %@", [DicStartup description]);
    
    dragView= [[GGdraggableDetails alloc] init];
//    dragView.center = CGPointMake(self.view.center.x, self.view.center.y);
    dragView.center = self.view.center;
    
    CGRect  frame = dragView.frame;
    frame.origin.y = 25;
    dragView.frame = frame;
    
    dragView.LabelStartupName.text = [DicStartup objectForKey:@"name"] ;
    dragView.LabelStartupDescription.text = [DicStartup objectForKey:@"description"];
//    NSLog(@"good size for uitextview %@", NSStringFromCGSize([[DicStartup objectForKey:@"description"] sizeWithFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14] constrainedToSize:dragView.LabelStartupDescription.frame.size lineBreakMode:NSLineBreakByWordWrapping]   ));
    
    dragView.StartupId = [DicStartup objectForKey:@"id"];
    dragView.startupWebsite = [DicStartup objectForKey:@"website"];
    dragView.HighConcept.text = [DicStartup objectForKey:@"highConcept"];
    dragView.LabelRaisedAmount.text = [DicStartup objectForKey:@"raisedAmount"];
    NSLog(@"raised label : %@", dragView.LabelRaisedAmount.text);
//    dragView.RaisingAmount.text = [DicStartup objectForKey:@"raising-amount"];
    dragView.LabelLocation.text = [DicStartup objectForKey:@"location"];
    dragView.LabelRating.text =[NSString stringWithFormat:@"Upvotes : %@/%@", [DicStartup objectForKey:@"users-following"],
                                [DicStartup objectForKey:@"total-views"]];
    
    dragView.LabelRating.text =[NSString stringWithFormat:@"%@ ",[DicStartup objectForKey:@"users-following"]];
    
    if ( [[DicStartup objectForKey:@"users-following"] integerValue] == 1) {
        dragView.LabelRating.text = [dragView.LabelRating.text stringByAppendingString:@"upvote"];
    }else{
        dragView.LabelRating.text = [dragView.LabelRating.text stringByAppendingString:@"upvotes"];
    }
    
    
    dragView.PreMoneyValuation.text =[NSString stringWithFormat:@"%@", [DicStartup objectForKey:@"preMoneyValuation"]];
    dragView.RaisingAmount.text =[NSString stringWithFormat:@"%@",  [DicStartup objectForKey:@"raisingAmount"]];
    dragView.Market.text  = [@"Markets : " stringByAppendingString: [NSString stringWithFormat:@"%@", [DicStartup objectForKey:@"market"]]] ;
    dragView.TextViewInvestorsLiked.text = @"";

    //set image
    NSString *theImagePath = [DicStartup objectForKey:@"imagePath"];
    UIImage *customImage = [UIImage imageWithContentsOfFile:theImagePath];
    [dragView loadImageAndStyle:customImage];
    
    [self.view addSubview:dragView];
    
    [self defineLayoutXibCard];
    
    
    //add investors :
    if ([[[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"investor"] boolValue] == NO  ) {
        dragView.TextViewInvestorsLiked.hidden = YES;
        //        dragView.labelTargeted.hidden = YES;
        dragView.imageViewLocker.hidden = NO;
        dragView.activityInvestors.hidden = YES;
    }else{
        dragView.imageViewLocker.hidden = YES;
        
        NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
        [self POSTwithUrl:[[[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id]
                            stringByAppendingString:@"/company/"]
                           stringByAppendingString:self.startupId]
                  andData:nil
            andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]];
    }

}

-(int) bottomCoordinateForView : (UIView*) view{
    return view.frame.origin.y + view.frame.size.height;
}

-(void) defineLayoutXibCard{
    //layout
    
    //->define somewhere else the size of the scroll for investors
    
    
    
    // get the size of the UITextView based on what it would be with the text
    CGFloat fixedWidth = dragView.LabelStartupDescription.frame.size.width;
    CGSize newSize = [dragView.LabelStartupDescription sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = dragView.LabelStartupDescription.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    newFrame.origin.y = [self bottomCoordinateForView:dragView.TextViewInvestorsLiked];
    NSLog(@"new size : %@", NSStringFromCGSize(newFrame.size));
    dragView.LabelStartupDescription.frame = newFrame;
    
    #define SPACE_IN_BETWEEN 5
    
    CGRect frame = dragView.Market.frame;
    frame.origin.y = [self bottomCoordinateForView:dragView.LabelStartupDescription] + SPACE_IN_BETWEEN ;
    dragView.Market.frame = frame;
    NSLog(@"frame for markets : %@", NSStringFromCGRect(frame));
    
    //Location
    frame = dragView.LabelLocation.frame;
    frame.origin.y = [self bottomCoordinateForView:dragView.Market];
    dragView.LabelLocation.frame = frame;
    
    frame = dragView.labelTitleLocation.frame;
    frame.origin.y = dragView.LabelLocation.frame.origin.y;
    dragView.labelTitleLocation.frame = frame;

    //Raised
    frame = dragView.LabelRaisedAmount.frame;
    frame.origin.y = [self bottomCoordinateForView:dragView.LabelLocation];
    dragView.LabelRaisedAmount.frame = frame;
    
    frame = dragView.labelTitleRaisedAmount.frame;
    frame.origin.y = dragView.LabelRaisedAmount.frame.origin.y;
    dragView.labelTitleRaisedAmount.frame = frame;
    
    //Raising
    frame = dragView.RaisingAmount.frame;
    frame.origin.y = [self bottomCoordinateForView:dragView.LabelRaisedAmount];
    dragView.RaisingAmount.frame = frame;
    
    frame = dragView.labelTitleRaisingAmount.frame;
    frame.origin.y = dragView.RaisingAmount.frame.origin.y;
    dragView.labelTitleRaisingAmount.frame = frame;
    
    //valuation
    frame = dragView.PreMoneyValuation.frame;
    frame.origin.y = [self bottomCoordinateForView:dragView.RaisingAmount];
    dragView.PreMoneyValuation.frame = frame;
    
    frame = dragView.labelTitleValuation.frame;
    frame.origin.y = dragView.PreMoneyValuation.frame.origin.y;
    dragView.labelTitleValuation.frame = frame;
    

    
    dragView.scrollView.contentSize = CGSizeMake(300, [self bottomCoordinateForView:dragView.PreMoneyValuation] + 20);
    

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
    
//    request.timeoutInterval = 15;
    [dragView shouldStartActivity:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        if (!error){
            //do something with data
            if (!data) {
                NSLog(@"no data rendered from server");
                //                [self enableFields:YES];
                //                [self.activityIndicator stopAnimating];
                //                self.activityIndicator.hidden=YES;
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                             options:XMLReaderOptionsProcessNamespaces
                                                               error:&error];
                NSLog(@"dic from server : %@", dict);
//                ArrayStartups = [[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"];
                
                //update the investors in the view
                
                if ([[[dict objectForKey:@"hash"] objectForKey:@"investor-followers"] objectForKey:@"investor-follower"] == nil) {
                    return;
                }
                
                NSMutableArray *investors = [[[dict objectForKey:@"hash"] objectForKey:@"investor-followers"] objectForKey:@"investor-follower"];
                if (![investors isKindOfClass:[NSArray class]])
                {
                    // if 'list' isn't an array, we create a new array containing our object
                    investors = [NSMutableArray arrayWithObject:investors];
                }
                
                NSString *names = @"";
                int compte = 0;
                for (NSDictionary *investor in investors) {
                
                    names = [names stringByAppendingString:[investor objectForKey:@"text"]] ;
                    
                    if (compte == ([investors count] - 1)){
                        NSLog(@"virgule");
                        names = [names stringByAppendingString:@"."];
                    }
                    else {
                        names = [names stringByAppendingString:@", "];
                        NSLog(@"point");
                    }
                    
                    compte++;
                }
                NSLog(@"names : %@", names );
                
                NSLog(@"invertors are : %@", [investors description]);
                dragView.TextViewInvestorsLiked.text = names;
                
                
                // get the size of the UITextView based on what it would be with the text
                CGFloat fixedWidth = dragView.TextViewInvestorsLiked.frame.size.width;
                CGSize newSize = [dragView.TextViewInvestorsLiked sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
                CGRect newFrame = dragView.TextViewInvestorsLiked.frame;
                newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
                NSLog(@"new size : %@", NSStringFromCGSize(newFrame.size));
                dragView.TextViewInvestorsLiked.frame = newFrame;
                
                [self defineLayoutXibCard];
                
                [dragView shouldStartActivity:NO];
            });
            
            NSLog(@"data response : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            
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
                
                [dragView shouldStartActivity:NO];
                
//                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error : %@", [error description]);
}

- (IBAction)SegmentValueChanged:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"0");
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.webView.frame = CGRectMake(0, 0, 10, 10);
            
        } completion:^(BOOL finished) {
            self.webView.hidden = YES;
        }];
        
    }else{
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        //show the website !
        NSString *websiteUrl = dragView.startupWebsite;
//        NSString *websiteUrl = @"http://www.google.com";
        self.webView.hidden=NO;
        [self.view bringSubviewToFront:self.webView];
        [self.activity startAnimating];
        self.activity.hidden = NO;
        [self.webView addSubview:self.activity];
        self.activity.center = self.webView.center;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);

            self.activity.center = self.webView.center;
            
            
        } completion:^(BOOL finished) {
            
        }];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:websiteUrl]];
        
        
        //acces the url to add a card
        self.webView.delegate=self;
        [self.webView loadRequest:request];
        
    }
}
- (IBAction)valueChanged:(UIBarButtonItem *)sender {
}

- (IBAction)back:(UIButton *)sender {
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)share:(id)sender {
    NSDictionary *DicStartup = [[[NSUserDefaults standardUserDefaults] objectForKey:@"DicLikedStartups"] objectForKey:self.startupId];
    
    NSLog(@"dic to share : %@", [DicStartup description]);
    
    
    shareView = [[ShareView alloc]init];
    shareView.center = self.view.center;
    shareView.hidden = NO;
    shareView.delegate = self;
    shareView.hightContent = [DicStartup objectForKey:@"highConcept"];
    shareView.websiteStartup =[DicStartup objectForKey:@"website"];
    shareView.startupName = [DicStartup objectForKey:@"name"];
    shareView.messageToShare =  [NSString stringWithFormat:@"%@: %@, via @app208 \n%@", shareView.startupName,
                                                     shareView.hightContent,
                                                     shareView.websiteStartup];
    [self.view addSubview:shareView];
}

#pragma mark custom view delegate

-(void) dismissCustomView:(ShareView *)myUIView{
//    shareView.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = shareView.frame;
        frame.origin.y = self.view.frame.size.height;
        shareView.frame = frame;
    } completion:^(BOOL finished) {
        shareView.hidden = YES;
    }];
}


#pragma mark webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"1");
    
    [self.activity stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error : %@",error);
    
    [self.activity stopAnimating];
    
    if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."]) {
        

        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[error userInfo]objectForKey:@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView{
    
}
@end
