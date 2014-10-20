//
//  AppDelegate.m
//  208
//
//  Created by amaury soviche on 11/10/14.
//  Copyright (c) 2014 Amaury Soviche. All rights reserved.
//

#import "AppDelegate.h"
#import "ScrollViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self chooseFirstViewController];
    
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [Parse setApplicationId:@"5Vlwz4wUFJa3WGpvl21csxEckUUGRDoqYtrn7rOG"
                  clientKey:@"McPWIZZwPX6omFwRqHCLxYoWsCKJIL5hhmTfzg4O"];
    [PFTwitterUtils initializeWithConsumerKey:@"K917OOOpGUbCIo2MmxVBrggcT"
                               consumerSecret:@"Uo4k9Ui9wqjd5symgcPZSBImEWTpfkhGR4JBICG2efMHIBLn24"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];


    if ([self isUserLoggedIn]) { //user is logged in : show startup VC

        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScrollViewController* loginViewController = [mainstoryboard      instantiateViewControllerWithIdentifier:@"ScrollViewController"];
        [self.window makeKeyAndVisible];
        [self.window.rootViewController presentViewController:loginViewController animated:NO completion:NULL];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
//    [[UITextField appearance] setFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17.0]];
//    [[UITextView appearance] setFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17.0]];
//    [[UILabel appearance] setFont:[UIFont fontWithName:@"AvenirNextLTPro-Regular" size:17.0]];
//    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(Color_purpule_dark)];
//    [[UITextField appearance].layer setBorderColor:UIColorFromRGB(Color_purpule_dark).CGColor];

    return YES;
}

-(BOOL) isUserLoggedIn{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userDictionary"]) {
        return YES;
    }
    else return NO;
}


-(void) chooseFirstViewController{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
