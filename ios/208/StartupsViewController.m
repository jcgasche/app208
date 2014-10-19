//
//  StartupsViewController.m
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "StartupsViewController.h"
#import "SWRevealViewController.h"
#import "GGDraggableView.h"
#import "XMLReader.h"

#import <QuartzCore/QuartzCore.h>

@interface StartupsViewController ()
@property (nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *aaa;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *textUI;


@property (strong, nonatomic) IBOutlet UIButton *buttonReloadJobs;

@property(strong, nonatomic) IBOutlet UIImageView *ImageViewAccept;
@property(strong, nonatomic) IBOutlet UIImageView *ImageViewDeny;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self customSetup];
    
    self.ImageViewAccept.hidden=YES;
    self.ImageViewDeny.hidden=YES;
    
    self.labelNoJobs.hidden=YES;
    self.buttonReloadJobs.hidden = YES;
    
    self.activityIndicator.hidden=YES;
    [self.activityIndicator startAnimating];
    self.activityIndicator.color = UIColorFromRGB(0x225378);
    
    [self customSetup];
    
    NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
    [self POSTwithUrl:[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id] andData:nil andParameters:nil];
    

}


- (void)customSetup
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.revealButtonItem setTarget: revealViewController];
        [self.revealButtonItem setAction: @selector( revealToggle: )];
        [self.navigationController.navigationBar addGestureRecognizer:revealViewController.panGestureRecognizer];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark XML parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{
    
    /* handle namespaces here if you want */
    NSLog(@"name = %@", elementName);
    
    if([elementName isEqualToString:@"status"]){
        currentElement = @"status";
    }else if ([elementName isEqualToString:@"email"]){
        currentElement=@"email";
    }else if ([elementName isEqualToString:@"user-id"]){
        currentElement=@"user-id";
    }
    
    else if ([elementName isEqualToString:@"startup"]){
        dicStartup = [[NSMutableDictionary alloc] init];
    }
    
    else if ([elementName isEqualToString:@"tag0"]){
        currentElement=@"tag0";
    }else if ([elementName isEqualToString:@"tag1"]){
        currentElement=@"tag1";
    }else if ([elementName isEqualToString:@"tag2"]){
        currentElement=@"tag2";
    }
    
    
    else if ([elementName isEqualToString:@"error"]){
        currentElement=@"error";
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"status"]){ //end of status
        status = currentContentforElement;
    }else if ([elementName isEqualToString:@"email"]){
        email = currentContentforElement;
    }else if ([elementName isEqualToString:@"user-id"]){

    }
    
    
    else if ([elementName isEqualToString:@"tag0"]){
        [dicStartup setObject:tag0 forKey:@"tag0"];
    }
    else if ([elementName isEqualToString:@"startup"]){
        [ArrayStartups addObject:[dicStartup copy]];
    }
    
    else if ([elementName isEqualToString:@"message-to-customer"]){

    }else if ([elementName isEqualToString:@"error"]){
        error_message = currentContentforElement;
    }else if ([elementName isEqualToString:@"user-partial-token"]){
        

    }else if ([elementName isEqualToString:@"hash"]){
        
//        [self enableFields:YES];
        
        if ([status isEqualToString:@"success"]) {
            
            
            //display all the startups
            [self createViewsForJobs];
            
            
        }else if ( [status isEqualToString:@"failure"]){
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
//                [self enableFields:YES];
                

            });
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    currentContentforElement = string;
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
            
            dispatch_sync(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                         options:XMLReaderOptionsProcessNamespaces
                                                           error:&error];
            NSLog(@"dic from server : %@", dict);
            ArrayStartups = [[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"];
            
            NSLog(@"this is the array for companies : %@", ArrayStartups);
            [self createViewsForJobs];
            });
        
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

#pragma mark - manage the frames

-(void)createViewsForJobs{

        
    numberOfTheCurrentView = 0;
    countAllJobs=0;
    IndexOfCurrentJob = 0;
    JobsPicturesArray = [[NSMutableArray alloc]init];
    ViewsArray = [[NSMutableArray alloc]init];
    
    self.buttonReloadJobs.hidden = YES;
    self.activityIndicator.hidden = NO;
    
    
    //handle all the views for the jobs
    
    int numberOfTheJob = 0 ;

    
    for (int i = 0; i < [ArrayStartups count]  ; i++) {
        
        //fill the view information
        NSMutableDictionary *JobOnTop = [ArrayStartups objectAtIndex:i];

        NSLog(@"job on top : %@", [JobOnTop description]);
            
//      Description = [JobOnTop objectForKey:@"description"];
        
        
            //we add a view for each job
            GGDraggableView *dragView= [[GGDraggableView alloc] initWithFrame:CGRectMake((320-280)/2, 90, 280, 463)];
            dragView.LabelStartupName.text =[[JobOnTop objectForKey:@"name"] objectForKey:@"text"];
            dragView.LabelStartupDescription.text =[[JobOnTop objectForKey:@"product-desc"] objectForKey:@"text"];
            dragView.StartupId = [[JobOnTop objectForKey:@"id"] objectForKey:@"text"];
        
        dragView.PreMoneyValuation.text =[NSString stringWithFormat:@"PreMoney Valuation : $ %@", [[JobOnTop objectForKey:@"pre-money-valuation"] objectForKey:@"text"]];
        dragView.RaisingAmount.text =[NSString stringWithFormat:@"Raising Amount : $ %@",  [[JobOnTop objectForKey:@"raising-amount"] objectForKey:@"text"]];
        dragView.Market.text =[NSString stringWithFormat:@"Markets : %@",   [[JobOnTop objectForKey:@"markets"] objectForKey:@"text"]];
        
        //load all informations

        
            if (numberOfTheJob == 0) {
                dragView.frame = CGRectMake((320-280)/2, 80, 280, 463);
            }
            
            if( numberOfTheJob < 2 ) {
                
                [self.view addSubview:dragView]; //print only 2 jobs
                
            }
               
            [ViewsArray addObject:dragView];
            
            dragView.numeroView = numberOfTheJob;
             
        
        if ([[JobOnTop objectForKey:@"logo-url"] objectForKey:@"text"]) {
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [[JobOnTop objectForKey:@"logo-url"] objectForKey:@"text"]]];

                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{

                    [dragView loadImageAndStyle:[UIImage imageWithData:data]];
                });
            });
        }
        
//            //handle startups images
//            if (JobOnTop[@"Picture"]) {
//                
//                [dragView.activity startAnimating];
//                
//                PFFile *userImageFile = JobOnTop[@"Picture"];
//                
//                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//                    if (!error) {
//                        UIImage *image = [UIImage imageWithData:imageData];
//                        [dragView.activity stopAnimating];
//                        if (image) {
//                            
//                            [JobsPicturesArray addObject:image];
//                            //placer les photos dans les vues
//                            [dragView loadImageAndStyle:[UIImage imageWithData:imageData]];
//                        }
//                        else{
//                            //error : load rand image
//                            [dragView loadImageAndStyle:[UIImage imageNamed:[@"rand_picture_" stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random()%5]]]];
//                        }
//                    }
//                }];
//            }else{
//                //no image : load rand image
//                [dragView loadImageAndStyle:[UIImage imageNamed:[@"rand_picture_" stringByAppendingString:[NSString stringWithFormat:@"%d", arc4random()%5]]]];
//            }
            
            
            
            //OBSERVE WHEN THE VIEW IS DELETED : CALLBACK BELLOW
            [dragView addObserver:self forKeyPath:@"ViewDeleted" options:NSKeyValueObservingOptionNew context:nil];
            [dragView addObserver:self forKeyPath:@"LoadDetailView" options:NSKeyValueObservingOptionNew context:nil];
            [dragView addObserver:self forKeyPath:@"position" options:NSKeyValueObservingOptionNew context:nil];
            

            
            numberOfTheJob++;
            countAllJobs++;
    }

    if ([ViewsArray count]) { // there are jobs
        GGDraggableView *dragCurrentView2 = [ViewsArray objectAtIndex: 0];
        [self.view bringSubviewToFront:dragCurrentView2];
    }else{ //no jobs
        self.buttonReloadJobs.hidden=NO;
        self.labelNoJobs.hidden=NO;
    }
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden=YES;
    self.textUI.hidden=YES;

    
}

#pragma mark KVO

//observe when the view is deleted
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"value changed");
    
    
    if ([keyPath isEqualToString:@"LoadDetailView"]) {
        
//        NSMutableDictionary *job = JobsArray[numberOfTheCurrentView];
//        PFUser *user = job[@"Author"];
//        
//        //load the detail view of the profile
//        
//        [self performSegueWithIdentifier:@"next" sender:user];
        
    }
    else if ([keyPath isEqualToString:@"position"])
    {
        
        GGDraggableView *o = object;
        int pos = o.position;
        
        static int factor = 2;
        
        //position < 0 : deny view
        if (pos <= 0) {
            
            self.ImageViewDeny.hidden=NO;
            [self.view bringSubviewToFront:self.ImageViewDeny];
            
            if (pos <= -150/factor) {
                self.ImageViewDeny.frame = CGRectMake(-15, _ImageViewDeny.frame.origin.y, _ImageViewDeny.frame.size.width, _ImageViewDeny.frame.size.height);
            }else{
                self.ImageViewDeny.frame = CGRectMake(-90 + factor*(-pos/150.0)*30, _ImageViewDeny.frame.origin.y, _ImageViewDeny.frame.size.width, _ImageViewDeny.frame.size.height);
            }
            
            self.ImageViewAccept.frame = CGRectMake(320, _ImageViewAccept.frame.origin.y, _ImageViewAccept.frame.size.width, _ImageViewAccept.frame.size.height);
        }
        //position >0  : accept view
        if (pos >= 0){
            
            self.ImageViewAccept.hidden=NO;
            [self.view bringSubviewToFront:self.ImageViewAccept];
            
            if (pos >= 150/factor) {
                self.ImageViewAccept.frame = CGRectMake(240, _ImageViewAccept.frame.origin.y, _ImageViewAccept.frame.size.width, _ImageViewAccept.frame.size.height);
            }else{
                NSLog(@"change");
                self.ImageViewAccept.frame = CGRectMake(240 + 80 - factor*(pos/150.0)*80, _ImageViewAccept.frame.origin.y, _ImageViewAccept.frame.size.width, _ImageViewAccept.frame.size.height);
            }
            
            self.ImageViewDeny.frame = CGRectMake(-90, _ImageViewDeny.frame.origin.y, _ImageViewDeny.frame.size.width, _ImageViewDeny.frame.size.height);
        }
    }
    else{
        GGDraggableView *dragCurrentView = [ViewsArray objectAtIndex: numberOfTheCurrentView ];
        NSLog(@"description of the array : %@", [ViewsArray description]);
        [dragCurrentView removeObserver:self forKeyPath:@"ViewDeleted"];
        [dragCurrentView removeObserver:self forKeyPath:@"LoadDetailView"];
        [dragCurrentView removeObserver:self forKeyPath:@"position"];
        [dragCurrentView removeFromSuperview];
        dragCurrentView=nil;
        
        if (numberOfTheCurrentView + 1 == countAllJobs) {
            self.buttonReloadJobs.hidden = NO;
            self.buttonReloadJobs.hidden=NO;
        }
        
        numberOfTheCurrentView++;
        
        if (numberOfTheCurrentView + 1 < countAllJobs ) { //countalljobs - 1 : array begins at 0 !
            NSLog(@"nb all jobs : %d", countAllJobs);
            
            GGDraggableView *dragView = [ViewsArray objectAtIndex: (numberOfTheCurrentView + 1)];
            [self.view addSubview:dragView];
            
            GGDraggableView *dragCurrentView2 = [ViewsArray objectAtIndex: numberOfTheCurrentView ];
            [self.view bringSubviewToFront:dragCurrentView2];
            
            [UIView animateWithDuration:0.1 animations:^{
                dragCurrentView2.frame = CGRectMake((320-291)/2, 80, 291, 463);
            }];
        }
        
        //handle the view on the side : green/red
        
        self.ImageViewDeny.frame = CGRectMake(-90, _ImageViewDeny.frame.origin.y, _ImageViewDeny.frame.size.width, _ImageViewDeny.frame.size.height);
        self.ImageViewAccept.frame = CGRectMake(320, _ImageViewAccept.frame.origin.y, _ImageViewAccept.frame.size.width, _ImageViewAccept.frame.size.height);
    }
}


@end
