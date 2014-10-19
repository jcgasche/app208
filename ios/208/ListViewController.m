//
//  ListViewController.m
//  QRCodeReader
//
//  Created by amaury soviche on 18/05/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ListViewController.h"
#import "XMLReader.h"

@interface ListViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIImageView *ImageViewDescription;

@end


@implementation ListViewController{
    NSMutableArray *ArrayStartups;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    
    NSString *user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"] objectForKey:@"user_id"];
    [self POSTwithUrl:[[@"http://app208.herokuapp.com/user/" stringByAppendingString:user_id] stringByAppendingString:@"/companies"] andData:nil andParameters:nil];
    
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
                
                [self.tableView reloadData];
                
                
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




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return [ArrayStartups count];

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    UILabel *LabelPrice = (UILabel*)[cell viewWithTag:100];
//    UITextView *textViewDescription = (UITextView*)[cell viewWithTag:101];
//    UILabel *LabelDate = (UILabel*)[cell viewWithTag:102];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:103];
//    UILabel *LabelCreditCard = (UILabel*)[cell viewWithTag:104];
    
//    LabelCreditCard.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14];
//    LabelDate.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:14];
//    LabelPrice.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17];
    
//    textViewDescription.editable = YES;
//    textViewDescription.font = [UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17];
//    textViewDescription.editable =NO;
    
//    textViewDescription.selectable = NO;
    
    
    if ([ArrayStartups count] > 0 ) {

        LabelPrice.hidden=NO;
        
        CGRect frame = imageView.frame;
        frame.origin.x = 16;
        imageView.frame = frame;

        LabelPrice.text = [NSString stringWithFormat:@"%@", [[[ArrayStartups objectAtIndex:indexPath.row ] objectForKey:@"name"]objectForKey:@"text" ]];

        //render image
    }
    


    
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
    

}


@end
