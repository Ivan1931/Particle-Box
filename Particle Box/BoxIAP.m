//
//  BoxIAP.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/11.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "BoxIAP.h"

@implementation BoxIAP

+(BoxIAP *) sharedInstance{
    static dispatch_once_t once;
    static BoxIAP * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.jonah.Particle_Box.BuyExtraFeatures",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}
@end
