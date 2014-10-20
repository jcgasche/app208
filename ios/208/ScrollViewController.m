//
//  ScrollViewController.m
//  QRCodeReader
//
//  Created by amaury soviche on 18/05/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "ScrollViewController.h"

#import "SettingsViewController.h"
#import "StartupsViewController.h"
#import "ListViewController.h"

@interface ScrollViewController ()
@property (strong,nonatomic) SettingsViewController *vc0;
@property (strong,nonatomic) StartupsViewController *vc1;
@property (strong,nonatomic) ListViewController *vc2;

@end

@implementation ScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) resetCamera{
//    [self.vc1 startReading];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    

    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //VIEW0
    self.vc0 = [sb instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    
    [self addChildViewController:self.vc0];
    [self.scrollView addSubview:self.vc0.view];
    [self.vc0 didMoveToParentViewController:self];
    
    
    
    //VIEW2
    
    self.vc1 = [sb instantiateViewControllerWithIdentifier:@"StartupsViewController"];
    CGRect frame1 = self.vc1.view.frame;
    frame1.origin.x = 320;
    self.vc1.view.frame = frame1;
    
    

    
    [self addChildViewController:self.vc1];
    [self.scrollView addSubview:self.vc1.view];
    [self.vc1 didMoveToParentViewController:self];
    
    
    // VIEW1
    self.vc2 = (ListViewController*)[sb instantiateViewControllerWithIdentifier:@"ListViewController"];
    
    CGRect frame2 = self.vc2.view.frame;
    frame2.origin.x = 640;
    self.vc2.view.frame = frame2;
    
    [self addChildViewController:self.vc2];
    [self.scrollView addSubview:self.vc2.view];
    [self.vc2 didMoveToParentViewController:self];
    

    CGPoint cgPoint = CGPointMake(320, 0);
    
    self.scrollView.contentSize = CGSizeMake(960, self.view.frame.size.height);
    [self.scrollView setContentOffset:cgPoint animated:NO];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.bounces=NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    NSLog(@"content offset : %f", sender.contentOffset.x);
    
    self.vc1.ImageViewAccept.hidden = YES;
    self.vc1.ImageViewDeny.hidden=YES;

    //HANDLE HELP FOR FIRST CONNECTION
    if (self.firstConnection == YES && (sender.contentOffset.x == 0 || sender.contentOffset.x == 640)) {
        
//        [UIView animateWithDuration:10 animations:^{
//            self.vc1.ImageSwipeLeft.alpha = 0;
//            self.vc1.ImageSwipeRight.alpha = 0;
//        } completion:^(BOOL finished) {
//            self.vc1.ImageSwipeLeft.alpha = 1;
//            self.vc1.ImageSwipeRight.alpha = 1;
//            
//            self.vc1.ImageSwipeLeft.hidden=YES;
//            self.vc1.ImageSwipeRight.hidden = YES;
//        }];
//        self.vc1.ImageSwipeLeft.hidden=YES;
//        self.vc1.ImageSwipeRight.hidden = YES;
    
        self.firstConnection = NO;

    
    }
    
    if (sender.contentOffset.x == 640) {
        [self.vc2 refreshTableView];
    }else{

    }
    
    if (sender.contentOffset.x < 0) {
        sender.contentOffset = CGPointMake(0, sender.contentOffset.y);
    }
    
    if (sender.contentOffset.x > 640) {
        sender.contentOffset = CGPointMake(640, sender.contentOffset.y);
    }
    
}

-(void) pageLeft{
    CGRect frame = self.scrollView.frame;
    //    frame.origin.x = 0;
    frame.origin.x = self.scrollView.contentOffset.x - 320 ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

-(void) pageRight{
    CGRect frame = self.scrollView.frame;
    frame.origin.x = self.scrollView.contentOffset.x + 320 ;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
