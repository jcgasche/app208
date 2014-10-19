//
//  LogInEMailViewController.m
//  208
//
//  Created by amaury soviche on 12/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LogInEMailViewController.h"
#import "StartupsViewController.h"

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

#pragma mark XML parsing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{
    
    /* handle namespaces here if you want */
    NSLog(@"name = %@", elementName);
    if ([elementName isEqualToString:@"id"]){
        currentElement=@"id";
    }else if([elementName isEqualToString:@"investor"]){
        currentElement = @"investor";
    }
    else if([elementName isEqualToString:@"status"]){
        currentElement = @"status";
    }else if ([elementName isEqualToString:@"email"]){
        currentElement=@"email";
    }else if ([elementName isEqualToString:@"user-id"]){
        currentElement=@"user-id";
    }else if ([elementName isEqualToString:@"user-token"]){
        currentElement=@"user-token";
    }else if ([elementName isEqualToString:@"user-partial-token"]){
        currentElement=@"user-partial-token";
    }else if ([elementName isEqualToString:@"message-to-customer"]){
        currentElement=@"message-to-customer";
    }else if ([elementName isEqualToString:@"error"]){
        currentElement=@"error";
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"status"]){ //end of status
        status = currentContentforElement;
    }else if ([elementName isEqualToString:@"id"]){
        id_user = currentContentforElement;
    }else if ([elementName isEqualToString:@"investor"]){
        investor = currentContentforElement ;
    }
    
    else if ([elementName isEqualToString:@"email"]){
        email = currentContentforElement;
    }else if ([elementName isEqualToString:@"id"]){
        user_id = currentContentforElement;
    }else if ([elementName isEqualToString:@"user-token"]){
        token = currentContentforElement;
    }else if ([elementName isEqualToString:@"message-to-customer"]){
        message_to_customer = currentContentforElement;
    }else if ([elementName isEqualToString:@"error"]){
        error_message = currentContentforElement;
    }else if ([elementName isEqualToString:@"user-partial-token"]){
        
        partial_token = currentContentforElement;
    }else if ([elementName isEqualToString:@"hash"]){
        
        //        [self enableFields:YES];
        
        if ([status isEqualToString:@"success"]) {
            
            //go to the next viewcontroller
            NSDictionary *dicForNewUser = [NSDictionary dictionaryWithObjectsAndKeys:id_user,@"user_id",
                                           investor, @"investor"
                                           , nil];
            [[NSUserDefaults standardUserDefaults] setObject:dicForNewUser forKey:@"userDictionary"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSLog(@"dic is : %@", [[NSUserDefaults standardUserDefaults]objectForKey:@"userDictionary"]);
            
            dispatch_sync(dispatch_get_main_queue(), ^{
            UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                StartupsViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"StartupsViewController"];
                [self presentViewController:vc1 animated:YES completion:nil];
            });
            
            
            
        }else if ( [status isEqualToString:@"failure"]){
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                //                [self enableFields:YES];
                
                //                [Errors checkErrors:[NSArray arrayWithObject:error_message]];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
