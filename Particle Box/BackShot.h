//
//  BackShot.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/05/29.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "ForceNode.h"

@interface BackShot : ForceNode {
    @private
    clock_t firedParticles;
}

@end
