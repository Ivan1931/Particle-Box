//
//  AppDelegate.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize controller;
@synthesize engine;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES) {
        // RETINA DISPLAY
        screenSize.size.width = screenSize.size.width * [[UIScreen mainScreen] scale];
        screenSize.size.height = screenSize.size.height * [[UIScreen mainScreen] scale];
    }
    self.window = [[UIWindow alloc] initWithFrame:screenSize];
    // Override point for customization after application launch
    
    engine = [[Engine alloc] initWithSize:screenSize andColor:[UIColor blueColor]];
    self.window.rootViewController = engine;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/*
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:[engine view]];
    NSLog(@"Touch at x: %f and y: %f",point.x, point.y);
    [engine moveForces:point];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:[engine view]];
    NSLog(@"Touch at x: %f and y: %f",point.x, point.y);
    [engine moveForces:point];
}
*/
@end
