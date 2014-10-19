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

@interface DetaillsStartupViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;


@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end

@implementation DetaillsStartupViewController{
    GGdraggableDetails *dragView;
}

-(void) viewWillAppear:(BOOL)animated{
    CGRect frame = self.segmentControl.frame;
    frame.origin.y = self.view.frame.size.height - frame.size.height - 10;
    self.segmentControl.frame = frame;
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
    //dragView.frame = CGRectMake((320-280)/2, 31, 280, 463);
    dragView.center = self.view.center;
    
    CGRect  frame = dragView.frame;
    frame.origin.y = 25;
    dragView.frame = frame;
    
    dragView.LabelStartupName.text = [DicStartup objectForKey:@"name"] ;
    dragView.LabelStartupDescription.text = [DicStartup objectForKey:@"description"];
    dragView.StartupId = [DicStartup objectForKey:@"id"];
    dragView.startupWebsite = [DicStartup objectForKey:@"website"];
    dragView.HighConcept.text = [DicStartup objectForKey:@"highConcept"];
    dragView.LabelRaisedAmount.text = [DicStartup objectForKey:@"raisedAmount"];
    NSLog(@"raised label : %@", dragView.LabelRaisedAmount.text);
//    dragView.RaisingAmount.text = [DicStartup objectForKey:@"raising-amount"];
    dragView.LabelLocation.text = [DicStartup objectForKey:@"location"];
    dragView.LabelRating.text =[NSString stringWithFormat:@"Upvotes : %@/%@", [DicStartup objectForKey:@"users-following"],
                                                                                [DicStartup objectForKey:@"total-views"]];
    
    dragView.PreMoneyValuation.text =[NSString stringWithFormat:@"%@", [DicStartup objectForKey:@"preMoneyValuation"]];
    dragView.RaisingAmount.text =[NSString stringWithFormat:@"%@",  [DicStartup objectForKey:@"raisingAmount"]];
    dragView.Market.text =[NSString stringWithFormat:@"%@",   [DicStartup objectForKey:@"market"]];

    //set image
    NSString *theImagePath = [DicStartup objectForKey:@"imagePath"];
    UIImage *customImage = [UIImage imageWithContentsOfFile:theImagePath];
    [dragView loadImageAndStyle:customImage];
    
    [self.view addSubview:dragView];
    
    //add invesotrs :
    NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
    [self POSTwithUrl:[[[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id]
                                                                stringByAppendingString:@"/company/"]
                                                                stringByAppendingString:self.startupId]
        andData:nil
        andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]];
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
                
                NSMutableArray *investors = [[[dict objectForKey:@"hash"] objectForKey:@"investor-followers"] objectForKey:@"investor-follower"];
                if (![investors isKindOfClass:[NSArray class]])
                {
                    // if 'list' isn't an array, we create a new array containing our object
                    investors = [NSMutableArray arrayWithObject:investors];
                }
                NSString *names ;
                for (NSDictionary *investor in investors) {
                    [names stringByAppendingString:[[investor objectForKey:@"name,"]objectForKey:@"text"]];
                }
                NSLog(@"names : %@", names );
                
                NSLog(@"invertors are : %@", [investors description]);
                dragView.TextViewInvestorsLiked.text = names;
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
                
                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
    }];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"error : %@", [error description]);
}

- (IBAction)SegmentValueChanged:(UISegmentedControl*)sender {
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"0");
        
        [UIView animateWithDuration:0.2 animations:^{
            self.webView.frame = CGRectMake(0, 0, 10, 10);
            
        } completion:^(BOOL finished) {
            self.webView.hidden = YES;
        }];
        
    }else{
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
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)share:(id)sender {
    
    NSLog(@"share");
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
