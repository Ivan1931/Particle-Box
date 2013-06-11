//
//  AppDelegate.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "Engine.h"
#import "BoxIAP.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Engine *engine;
@property (strong, nonatomic) UIViewController *controller;
@end
