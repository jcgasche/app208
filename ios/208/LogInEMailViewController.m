//
//  LogInEMailViewController.m
//  208
//
//  Created by amaury soviche on 12/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LogInEMailViewController.h"
#import "StartupsViewController.h"
#import "XMLReader.h"
#import "ScrollViewController.h"

@interface LogInEMailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *TextFieldemail;

@end

@implementation LogInEMailViewController{
    NSString *currentElement;
    NSString *currentContentforElement;
    
    //data for card dictionary
    NSString *id_user;
    NSString *investor;
    
    //dictionary for user default
    NSMutableDictionary *dictionaryForNewUser;
    
    NSString *status;
    NSString *email;
    NSString *user_id;
    NSString *token;
    NSString *partial_token;
    NSString *message_to_customer;
    NSString *error_message;
    
    NSDictionary *dictionaryForUserDatas;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.TextFieldemail becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(UIButton *)sender {
//    [self POSTwithUrl:[@"http://app208.herokuapp.com/login_email/" stringByAppendingString:self.TextFieldemail.text] andData:nil andParameters:nil];
    
    [self POSTwithUrl:[@"http://app208.herokuapp.com/login_email/" stringByAppendingString:self.TextFieldemail.text]   andData:nil andParameters:nil];

//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://app208.herokuapp.com/login_email/%@",self.TextFieldemail.text]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"www.google.com"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//        if (!error){
//            //do something with data
//            if (!data) {
//                NSLog(@"no data rendered from server");
//                
//                dispatch_sync(dispatch_get_main_queue(), ^{
//                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your connection is too slow, try later..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                });
//            }
//            
//            
//            NSLog(@"data response : %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//            
//            
//            NSData * XMLData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUnicodeStringEncoding];
//            NSXMLParser * parser = [[NSXMLParser alloc] initWithData:XMLData];
//            [parser setDelegate:self];
//            [parser setShouldProcessNamespaces:YES]; // if you need to
//            [parser parse]; // start parsing
//        }
//        else if (error)
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSLog(@"%@",error);
//                
////                [self hideActivity:YES];
//                
//                if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."]) {
//                    
//                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[error userInfo]objectForKey:@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                    return;
//                }
//                else if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The request timed out"]) {
//                    
//                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your connection is too slow, try later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//                    return;
//                }
//                
//                [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
//            });
//    }];

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
            
            NSError *error = nil;
            NSDictionary *dict = [XMLReader dictionaryForXMLData:data
                                                         options:XMLReaderOptionsProcessNamespaces
                                                           error:&error];
            NSLog(@"dic is : %@", dict);
            
            if ([[[[dict objectForKey:@"hash"]objectForKey:@"status"] objectForKey:@"text"] isEqualToString:@"success"]) {
                
                NSDictionary *dicForNewUser = [NSDictionary dictionaryWithObjectsAndKeys:
                                               [[[dict objectForKey:@"hash"]objectForKey:@"id"] objectForKey:@"text"] , @"user_id",
                                               [[[dict objectForKey:@"hash"]objectForKey:@"investor"] objectForKey:@"text"] , @"investor",
                                               [[[dict objectForKey:@"hash"]objectForKey:@"token"] objectForKey:@"text"], @"token",
                                               nil];
                [[NSUserDefaults standardUserDefaults] setObject:dicForNewUser forKey:@"userDictionary"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ScrollViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"ScrollViewController"];
                    [self presentViewController:vc1 animated:NO completion:nil];
                });
            }
            
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
