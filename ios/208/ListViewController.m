#import "ListViewController.h"
#import "XMLReader.h"
#import "DetaillsStartupViewController.h"
#import "ScrollViewController.h"

@interface ListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ScrollViewController *stlmMainViewController;

@end


@implementation ListViewController{
    NSMutableArray *ArrayStartups;
    NSMutableDictionary *DicLikedStartups;
    NSMutableArray *sortedArrayKeys;
}
- (IBAction)Back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)goLeft:(UIButton *)sender {
    //access the parent view controller
    self.stlmMainViewController= (ScrollViewController *) self.parentViewController;
    [self.stlmMainViewController pageLeft];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//
//    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

    if((DicLikedStartups = [[[NSUserDefaults standardUserDefaults]objectForKey:@"DicLikedStartups"] mutableCopy]) != nil){
        
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.hidden = NO;
        
        NSLog(@"dic saved in userdef : %@", DicLikedStartups);
        
        //order the array of dictionary's keys
        NSArray *keys2 = [DicLikedStartups allKeys];
        sortedArrayKeys =[[NSMutableArray alloc]initWithArray:[[keys2 sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [[DicLikedStartups objectForKey:a]objectForKey:@"name"];
            NSString *second = [[DicLikedStartups objectForKey:b] objectForKey:@"name"];
            return [first compare:second];
        }] mutableCopy]];


        [self.tableView reloadData];
        
        NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
        [self POSTwithUrl:[[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id] stringByAppendingString:@"/companies"] andData:nil andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]];
        
    }else{
        self.tableView.hidden = YES;
        
        //display image to show the prefered startups will be placed here !
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"icon-dart-medium"];
        imageView.center = self.view.center;
        [self.view addSubview:imageView];
    }
//    NSMutableArray *ArrayIdLikedStartups;
//    for (NSDictionary *dicStartup in ArrayStartups) {
//        [ArrayIdLikedStartups addObject:[dicStartup objectForKey:@"id"]];
//    }
    

    
}

-(void) refreshTableView{
    NSLog(@"reload data");
    if((DicLikedStartups = [[[NSUserDefaults standardUserDefaults]objectForKey:@"DicLikedStartups"] mutableCopy]) != nil){
        
        NSLog(@"dic saved in userdef : %@", DicLikedStartups);
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.hidden = NO;
        
        //order the array of dictionary's keys
        NSArray *keys2 = [DicLikedStartups allKeys];
        sortedArrayKeys =[[NSMutableArray alloc]initWithArray:[[keys2 sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            NSString *first = [[DicLikedStartups objectForKey:a]objectForKey:@"name"];
            NSString *second = [[DicLikedStartups objectForKey:b] objectForKey:@"name"];
            return [first compare:second];
        }] mutableCopy]];
        
        [self.tableView reloadData];
        
        NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
        [self POSTwithUrl:[[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id] stringByAppendingString:@"/companies"] andData:nil andParameters:[NSString stringWithFormat:@"&token=%@", [[[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary" ] objectForKey:@"token"]]];
    }
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
            
            
            
                NSError *error = nil;
                NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                             options:XMLReaderOptionsProcessNamespaces
                                                               error:&error];
                NSLog(@"dic from server list: %@", dict);
            
            
                if ([[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"] == nil ||
                [dict objectForKey:@"html"] != nil ) {
                    
                    
                    
                    return;
                }
            
            
                NSArray *Startups = [[[dict objectForKey:@"hash"] objectForKey:@"companies"] objectForKey:@"company"];
                //                NSArray *Startups = [[dict objectForKey:@"hash"] objectForKey:@"companies"]; //returns 8 objects if 1 compynie likes !
                
                if (![Startups isKindOfClass:[NSArray class]])
                {
                    // if 'list' isn't an array, we create a new array containing our object
                    Startups = [NSArray arrayWithObject:Startups];
                }
                
                
                NSLog(@"starups from jc : %@", [Startups description]);
                
                
                for (NSDictionary *startup in Startups) {
                    
                    
                    NSString *startupId = [[startup objectForKey:@"id"] objectForKey:@"text"];
                    
                    //                if ([[DicLikedStartups objectForKey:startupId] mutableCopy] == nil) {
                    //                    continue;
                    //                }
                    
                    NSString *users_following = [[startup objectForKey:@"users-following"] objectForKey:@"text"];
                    NSString *total_views = [[startup  objectForKey:@"total-views"] objectForKey:@"text"];
                    
                    @try {
                        NSMutableDictionary *dicStartupToUpdate = [[DicLikedStartups objectForKey:startupId] mutableCopy];
                    
                        [dicStartupToUpdate setObject:users_following forKey:@"users-following"];
                        [dicStartupToUpdate setObject:total_views forKey:@"total-views"];
                    
                        [DicLikedStartups setObject:dicStartupToUpdate forKey:[dicStartupToUpdate objectForKey:@"id"]];
                        [self saveStartupsInUserDefault];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"exception : %@", [exception description]);
                        continue;
                    }
                    @finally {
                        
                    }

                }
                

            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        
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
                
//                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
            });
    }];
}

-(void)saveStartupsInUserDefault{
    [[NSUserDefaults standardUserDefaults] setObject:DicLikedStartups forKey:@"DicLikedStartups"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    NSLog(@"nsuserdefault : %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"DicLikedStartups"]);
}

#pragma mark tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [DicLikedStartups count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor clearColor];
//    }
    
    UILabel *LabelPrice = (UILabel*)[cell viewWithTag:100];
    UILabel *LabeLikes = (UILabel*)[cell viewWithTag:333];
    UILabel *labelWebsite = (UILabel*)[cell viewWithTag:777];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag:555];
    UITextView *desc = (UITextView*)[cell viewWithTag:222];
    desc.editable=YES;
    [desc setFont:[UIFont fontWithName:@"ProximaNova-Regular" size:14]];
    desc.editable=NO;
    
    UIActivityIndicatorView *activity = (UIActivityIndicatorView*)[cell viewWithTag:666];

//    NSArray *keys = [DicLikedStartups allKeys];
    NSLog(@"sorted array supposed saved : %@", [sortedArrayKeys description]);
    NSDictionary *startupForCell = [DicLikedStartups objectForKey:[sortedArrayKeys objectAtIndex:indexPath.row]];
    
    LabelPrice.text = [startupForCell objectForKey:@"name"];
    desc.text = [startupForCell objectForKey:@"highConcept"];
    
    //Website
    if ([startupForCell objectForKey:@"website"] == nil ||
        [[startupForCell objectForKey:@"website"] isEqualToString:@""]) {
        labelWebsite.text = @"";
    }else{
        NSArray *myWords = [[startupForCell objectForKey:@"website"] componentsSeparatedByString:@"http://"];
        if ([myWords objectAtIndex:1] != nil) {
            labelWebsite.text = [myWords objectAtIndex:1];
        }
        else{
            labelWebsite.text = [startupForCell objectForKey:@"website"];
        }
    }
    
    if ([startupForCell objectForKey:@"users-following"] == nil) {
        LabeLikes.text = @"Loading rate...";
        
        activity.hidden = NO;
        [activity startAnimating];
    }
    else{
        
        LabeLikes.text =[NSString stringWithFormat:@"%@ ", [startupForCell objectForKey:@"users-following"]];
        
        if ( [[startupForCell objectForKey:@"users-following"] integerValue] == 1) {
            LabeLikes.text = [LabeLikes.text stringByAppendingString:@"upvote"];
        }else{
            LabeLikes.text = [LabeLikes.text stringByAppendingString:@"upvotes"];
        }

        activity.hidden = YES;
        [activity stopAnimating];
    }
    

    
    NSString *theImagePath = [startupForCell objectForKey:@"imagePath"];
    NSLog(@"imagepath : %@", theImagePath);
    UIImage *customImage = [UIImage imageWithContentsOfFile:theImagePath];
    NSLog(@"image desc : %@", [customImage description]);
    imageView.image = customImage;
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                         NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSLog(@"image path in memory : %@", [startupForCell objectForKey:@"imagePath"]);
//    NSString* path = [documentsDirectory stringByAppendingPathComponent:[startupForCell objectForKey:@"imagePath"]];
//    UIImage* image = [UIImage imageWithContentsOfFile:path];
//    imageView.image =  image;
    
//ionaryWithObjectsAndKeys:self.LabelStartupDescription.text, @"description",
//    self.LabelStartupName.text, @"name",
//    self.StartupId, @"id",
//    self.PreMoneyValuation.text, @"preMoneyValuation",
//    self.RaisingAmount.text, @"raisingAmount",
//    self.Market.text, @"market", nil];
    
//    if ([ArrayStartups count] > 0 ) {
//
//        LabelPrice.hidden=NO;
//
//        CGRect frame = imageView.frame;
//        frame.origin.x = 16;
//        imageView.frame = frame;
//
//        LabelPrice.text = [NSString stringWithFormat:@"%@", [[[ArrayStartups objectAtIndex:indexPath.row] objectForKey:@"name"]objectForKey:@"text" ]];
//        
//        desc.text = [NSString stringWithFormat:@"%@", [[[ArrayStartups objectAtIndex:indexPath.row] objectForKey:@"high-concept"]objectForKey:@"text" ]];
//        
//        LabelMarketTags.text = [NSString stringWithFormat:@"%@", [[[ArrayStartups objectAtIndex:indexPath.row] objectForKey:@"markets"]objectForKey:@"text" ]];
//        LabelMarketTags.numberOfLines = 2;
//        
//        LabeLikes.text = [NSString stringWithFormat:@"Likes : %@/%@", [[[ArrayStartups objectAtIndex:indexPath.row] objectForKey:@"users-following"]objectForKey:@"text" ],[[[ArrayStartups objectAtIndex:indexPath.row] objectForKey:@"total-views"]objectForKey:@"text" ] ];
//
//        //render image
//        
//        
//    }

    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath {
    //transition to the detail of the startup !
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetaillsStartupViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"DetaillsStartupViewController"];
    vc1.startupId = [sortedArrayKeys objectAtIndex:indexPath.row];
    
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel *LabeLikes = (UILabel*)[cell viewWithTag:333];

    
    [self presentViewController:vc1 animated:YES completion:nil];
}


@end
