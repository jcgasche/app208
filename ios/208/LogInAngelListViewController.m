//
//  LogInAngelListViewController.m
//  208
//
//  Created by amaury soviche on 12/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LogInAngelListViewController.h"

#import "StartupsViewController.h"

@interface LogInAngelListViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@end

@implementation LogInAngelListViewController{
    NSData *webdata;
    
    //data for card dictionary
    NSString *id_user;
    BOOL investor;
    
    //dictionary for user default
    NSMutableDictionary *dictionaryForNewUser;
    
    //parse xml
    NSString *currentElement;
    NSString *currentContentforElement;
    NSString *status;
    NSString *message_to_customer;
    NSString *error_message;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self hideActivity:NO];
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://www.payonesnap.com/add_credit_card_spreedly_from_iphone/%@/%@",token,userId]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
//    
//    request.timeoutInterval = 15;
//    
//    
//    //acces the url to add a card
//    self.webView.delegate=self;
//    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideActivity:(BOOL)hideActivity{
    
    self.activity.hidden = hideActivity;
    
    if (hideActivity) {
        [self.activity stopAnimating];
    }else{
        [self.activity startAnimating];
    }
}

#pragma mark webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"1");
    
    [self hideActivity:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"error : %@",error);
    
    if ([[[error userInfo]objectForKey:@"NSLocalizedDescription"] isEqualToString:@"The Internet connection appears to be offline."]) {
        
        [self hideActivity:YES];
        
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:[[error userInfo]objectForKey:@"NSLocalizedDescription"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"url : %@", [[request URL] absoluteString]);
    if ( !( [[[request URL] absoluteString] hasPrefix:@"https://www.payonesnap.com/add_credit_card_spreedly_from_iphone"] || [[[request URL] absoluteString] hasPrefix:@"https://www.payonesnap.com/save_secure_for_iphone"] ) ){
        [self hideActivity:NO];
    }
    
    
    if ([[[request URL] absoluteString] hasPrefix:@"https://www.payonesnap.com/save_secure_for_iphone"]) { //recognize the change of url
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (!error){
                //do something with data
                if (!data) {
                    NSLog(@"no data rendered from server");
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your connection is too slow, try later..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
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
                    
                    [self hideActivity:YES];
                    
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
        
        return NO;
        //hide the webview
        
    }
    return YES;
}


#pragma mark XML parse

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict{
    
    /* handle namespaces here if you want */
    NSLog(@"name = %@", elementName);
    
    if ([elementName isEqualToString:@"id"]){
        currentElement=@"id";
    }else if([elementName isEqualToString:@"investor"]){
        currentElement = @"investor";
    }else if ([elementName isEqualToString:@"status"]){
        currentElement=@"status";
    }
//    else if ([elementName isEqualToString:@"hash"]){
//        currentElement=@"hash";
//    }else if ([elementName isEqualToString:@"error"]){
//        currentElement=@"error";
//    }else if ([elementName isEqualToString:@"card-number"]){
//        currentElement=@"card-number";
//    }else if ([elementName isEqualToString:@"card-type"]){
//        currentElement=@"card-type";
//    }else if ([elementName isEqualToString:@"card-last-four-digits"]){
//        currentElement=@"card-last-four-digits";
//    }else if ([elementName isEqualToString:@"message-to-customer"]){
//        currentElement=@"message-to-customer";
//    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"status"]){ //end of status
        status = currentContentforElement;
    }else if ([elementName isEqualToString:@"id"]){
        id_user = currentContentforElement;
    }else if ([elementName isEqualToString:@"investor"]){
        investor = [currentContentforElement boolValue];
    }
//    else if ([elementName isEqualToString:@"card-description"]){
//        
//    }else if ([elementName isEqualToString:@"card-number"]){
//        
//    }else if ([elementName isEqualToString:@"message-to-customer"]){
//        message_to_customer = currentContentforElement;
//        
//    }else if ([elementName isEqualToString:@"card-type"]){
//        card_description = currentContentforElement;
//    }else if ([elementName isEqualToString:@"card-last-four-digits"]){
//        card_number = currentContentforElement;
//    }
    else if ([elementName isEqualToString:@"error"]){
        error_message = currentContentforElement;
    }
    else if ([elementName isEqualToString:@"hash"]){
        //end of document
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if ([status isEqualToString:@"success"]) {
                
                //go to the next viewcontroller
                NSDictionary *dicForNewUser = [NSDictionary dictionaryWithObjectsAndKeys:id_user,@"id",
                                                                                        investor, @"investor"
                                                                                        , nil];
                [[NSUserDefaults standardUserDefaults] setObject:dictionaryForNewUser forKey:@"userDictionary"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
               
                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                StartupsViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"StartupsViewController"];
                [self presentViewController:vc1 animated:NO completion:nil];
                
                [self hideActivity:YES];
                
            }else if ([status isEqualToString:@"failure"]){
                
                [self hideActivity:YES];
                
                 //show there is a problem with the login
            }
            
        });
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    currentContentforElement = string;
}

-(void)handleErrorMessage:(NSString*) error{
    if ([error isEqualToString:@"invalidCredentials"]) {
        [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Account blocked, please re-login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    
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
