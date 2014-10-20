//
//  LogInAngelListViewController.m
//  208
//
//  Created by amaury soviche on 12/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LogInAngelListViewController.h"
#import "XMLReader.h"
#import "StartupsViewController.h"
#import "ScrollViewController.h"

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface LogInAngelListViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@property ACAccount* facebookAccount;
@end

@implementation LogInAngelListViewController{
    NSData *webdata;
    
    //data for card dictionary
    NSString *id_user;
    NSString *token;
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
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://angel.co/api/oauth/authorize?client_id=88382b671bafbc2f58f8d6cc75a2ddb2&scope=message%20email%20comment%20talent&response_type=code"] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.activity.center = self.view.center;
    [self.activity startAnimating];
    self.activity.hidden = NO;
    [self.webView bringSubviewToFront:self.activity];
    
    
//    request.timeoutInterval = 15;
    
    
    //acces the url to add a card
    self.webView.delegate=self;
    [self.webView loadRequest:request];
}

-(void) viewWillAppear:(BOOL)animated{

}

- (IBAction)postMessage:(id)sender { //post a message on facebook : ask for 2 permissions : review via FB !
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountTypeFacebook =
    [accountStore accountTypeWithAccountTypeIdentifier:
     ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"1476845325882616",
                              ACFacebookPermissionsKey: @[@"publish_stream",
                                                          @"publish_actions"],
                              ACFacebookAudienceKey: ACFacebookAudienceFriends
                              };
    
    [accountStore requestAccessToAccountsWithType:accountTypeFacebook
                                          options:options
                                       completion:^(BOOL granted, NSError *error) {
                                           
                                           if(granted) {
                                               
                                               NSArray *accounts = [accountStore
                                                                    accountsWithAccountType:accountTypeFacebook];
                                               _facebookAccount = [accounts lastObject];
                                               
                                               NSDictionary *parameters =
                                               @{@"access_token":_facebookAccount.credential.oauthToken,
                                                 @"message": @"test message"};
                                               
                                               NSURL *feedURL = [NSURL
                                                                 URLWithString:@"https://graph.facebook.com/me/feed"];
                                               
                                               SLRequest *feedRequest =
                                               [SLRequest
                                                requestForServiceType:SLServiceTypeFacebook
                                                requestMethod:SLRequestMethodPOST
                                                URL:feedURL
                                                parameters:parameters];
                                               
                                               [feedRequest 
                                                performRequestWithHandler:^(NSData *responseData,
                                                                            NSHTTPURLResponse *urlResponse, NSError *error)
                                                {
                                                    NSLog(@"Request failed, %@", 
                                                          [urlResponse description]);
                                                }];
                                           } else {
                                               NSLog(@"Access Denied");
                                               NSLog(@"[%@]",[error localizedDescription]);
                                           }
                                       }];
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
    
//    if ( !( [[[request URL] absoluteString] hasPrefix:@"https://www.payonesnap.com/add_credit_card_spreedly_from_iphone"] || [[[request URL] absoluteString] hasPrefix:@"https://www.payonesnap.com/save_secure_for_iphone"] ) ){
//        [self hideActivity:NO];
//    }
    
    
    
    if ([[[request URL] absoluteString] hasPrefix:@"https://app208.herokuapp.com/angel_callback"]) { //recognize the change of url
        
//        NSLog(@"redirect to our servers ");
//        NSError *error;
//        NSString *googlePage = [NSString stringWithContentsOfURL:[NSURL URLWithString:[[request URL] absoluteString]]
//                                                        encoding:NSASCIIStringEncoding
//                                                           error:&error];
//        NSLog(@"pages : %@", googlePage);
        
        NSLog(@"should do the request ");
        
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
                
//                NSData * XMLData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] dataUsingEncoding:NSUnicodeStringEncoding];
//                NSXMLParser * parser = [[NSXMLParser alloc] initWithData:XMLData];
//                [parser setDelegate:self];
//                [parser setShouldProcessNamespaces:YES]; // if you need to
//                [parser parse]; // start parsing
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
                    
//                    [[[UIAlertView alloc] initWithTitle:@"Alert" message:@"An error occured, please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                });
        }];
        
        return NO;
        //hide the webview
        
    }
    return YES;
}



@end
