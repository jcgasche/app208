//
//  LoginViewController.m
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LoginViewController.h"
#import "StartupsViewController.h"
#import <Parse/Parse.h>
#import "ScrollViewController.h"
#import "XMLReader.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIImageView *imageDart;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.activity.hidden = YES;
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];

//    if ([self isUserLoggedIn]) { //user is logged in : show startup VC
//        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        StartupsViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"StartupsViewController"];
//        [self presentViewController:vc1 animated:YES completion:nil];
//    }
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UITextField appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
//    [[UITextView appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
    //    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(Color_purpule_dark)];
    //    [[UITextField appearance].layer setBorderColor:UIColorFromRGB(Color_purpule_dark).CGColor];
    
}
- (IBAction)loginTwitter:(UIButton *)sender {
//    self.activity.hidden = NO;
//    [self.activity startAnimating];
    [self startLoading];
    
    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        if (error) {
//            self.activity.hidden = YES;
//            [self.activity stopAnimating];
            [self StopLoading];
        }
        else if (!user) {
            NSLog(@"Uh oh. The user cancelled the Twitter login.");
            return;
        } else if (user.isNew) {

            NSLog(@"info about user : %@", [user description]);
//            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"User signed up and logged in with Twitter!");
                    [self POSTwithUrl:[@"http://app208.herokuapp.com/login_email/" stringByAppendingString:user.username]   andData:nil andParameters:nil];
//                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                ScrollViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"ScrollViewController"];
//                [self presentViewController:vc1 animated:NO completion:nil];
//            });
        } else {
            NSLog(@"info about user : %@", [user description]);
            [self POSTwithUrl:[@"http://app208.herokuapp.com/login_email/" stringByAppendingString:user.username]   andData:nil andParameters:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSLog(@"User logged in with Twitter!");
//                UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                ScrollViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"ScrollViewController"];
//                [self presentViewController:vc1 animated:NO completion:nil];
//            });
        }
    }];
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
//                self.activity.hidden = YES;
//                [self.activity stopAnimating];
                [self StopLoading];
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
                    
//                    self.activity.hidden = YES;
//                    [self.activity stopAnimating];
                    [self StopLoading];
                    
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
//                self.activity.hidden = YES;
//                [self.activity stopAnimating];
                
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
}



-(BOOL) isUserLoggedIn{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"]) {
        return YES;
    }
    else return NO;
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

-(void) startLoading{
if ([self.imageDart.layer animationForKey:@"SpinAnimation"] == nil) {
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = 3.0f;
    animation.repeatCount = INFINITY;
    [self.imageDart.layer addAnimation:animation forKey:@"SpinAnimation"];
}
}

-(void) StopLoading{
    
    [self.imageDart.layer removeAnimationForKey:@"SpinAnimation"];
    
    
}

@end
