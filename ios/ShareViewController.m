//
//  ShareViewController.m
//  208
//
//  Created by amaury soviche on 19/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "ShareViewController.h"
//send email
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark message
- (IBAction)share_message:(UIButton *)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
//        controller.body = bodyOfMessage;
//        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissModalViewControllerAnimated:YES];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else 
                NSLog(@"Message failed");
}

#pragma mark email

- (IBAction)share_email:(id)sender {
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Feedback"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@"support@payonesnap.com"]];
        //        [mailCont setMessageBody:@"" isHTML:NO];
        
        [self presentModalViewController:mailCont animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tweeter

- (IBAction)share_tweeter:(id)sender {
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

#pragma mark fb
- (IBAction)share_facebook:(id)sender {
    
}

#pragma mark copylink
- (IBAction)share_copylink:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"paste me somewhere";
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
