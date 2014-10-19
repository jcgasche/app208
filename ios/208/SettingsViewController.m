//
//  SettingsViewController.m
//  208
//
//  Created by amaury soviche on 14/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

//send email
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "ScrollViewController.h"

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface SettingsViewController ()
@property (nonatomic, strong) ScrollViewController *stlmMainViewController;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Back:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)goRight:(id)sender {
    //access the parent view controller
    self.stlmMainViewController= (ScrollViewController *) self.parentViewController;
    [self.stlmMainViewController pageRight];
}
- (IBAction)tweet:(UIButton *)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"test"];
        [tweetSheet addURL:[NSURL URLWithString:@""]];
        [tweetSheet addImage:[UIImage imageNamed:@""]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
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

- (IBAction)logout:(UIButton *)sender {
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:vc1 animated:YES completion:nil];
    
}

#pragma mark send mail
- (IBAction)ActionContactUs:(id)sender {
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Feedback"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"mail@app208.com"]];
        //        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
