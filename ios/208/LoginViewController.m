//
//  LoginViewController.m
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "LoginViewController.h"
#import "StartupsViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    if ([self isUserLoggedIn]) { //user is logged in : show startup VC
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        StartupsViewController *vc1 = [sb instantiateViewControllerWithIdentifier:@"StartupsViewController"];
        [self presentViewController:vc1 animated:NO completion:nil];
    }
    
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UITextField appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
    [[UITextView appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
    [[UILabel appearance] setFont:[UIFont fontWithName:@"JosefinSans-Regular" size:17.0]];
    //    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(Color_purpule_dark)];
    //    [[UITextField appearance].layer setBorderColor:UIColorFromRGB(Color_purpule_dark).CGColor];
    
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

@end
