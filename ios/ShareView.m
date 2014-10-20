//
//  ShareView.m
//  208
//
//  Created by amaury soviche on 19/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "ShareView.h"
//send email
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "DetaillsStartupViewController.h"

@implementation ShareView{

}

@synthesize delegate;
@synthesize startupName;
@synthesize hightContent;
@synthesize websiteStartup;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    
    //1. load xib file
    [[NSBundle mainBundle] loadNibNamed:@"ShareView" owner:self options:nil];
    
    //2. adjust bounds
    self.bounds = self.viewXib.bounds;
    
    //3. add as a subview
    [self addSubview:self.viewXib];
    
    
    self.viewXib.alpha = 0.9;
//    self.alpha = 0.9;
    

    return self;
}

#pragma mark message
- (IBAction)share_message:(UIButton *)sender {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
    if([MFMessageComposeViewController canSendText])
    {
        [delegate dismissCustomView:self];
        
        controller.body = self.messageToShare;
        //        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
//        [self presentModalViewController:controller animated:YES];
        [(DetaillsStartupViewController *)[self.superview nextResponder] presentViewController:controller animated:YES completion:nil];
    }
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
//    [self dismissModalViewControllerAnimated:YES];
    [(DetaillsStartupViewController *)[self.superview nextResponder] dismissViewControllerAnimated:YES completion:nil];
    
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
        [delegate dismissCustomView:self];
        
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:[NSString stringWithFormat: @"Check out %@", self.startupName]];
//        [mailCont setToRecipients:[NSArray arrayWithObject:@"support@payonesnap.com"]];
                [mailCont setMessageBody:self.messageToShare isHTML:NO];
        
//        [self presentModalViewController:mailCont animated:YES];
        [(DetaillsStartupViewController *)[self.superview nextResponder] presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [(DetaillsStartupViewController *)[self.superview nextResponder] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tweeter

- (IBAction)share_tweeter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        [delegate dismissCustomView:self];
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:self.messageToShare];
//        [tweetSheet addURL:[NSURL URLWithString:@""]];
//        [tweetSheet addImage:[UIImage imageNamed:@""]];
//        [self presentViewController:tweetSheet animated:YES completion:nil];
        [(DetaillsStartupViewController *)[self.superview nextResponder] presentViewController:tweetSheet animated:YES completion:nil];

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
    pasteboard.string = self.websiteStartup;
    
    [delegate dismissCustomView:self];
    
    
}

- (IBAction)cancel:(id)sender {
    [delegate dismissCustomView:self];
}

@end
