//
//  Graviton.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/27.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForceNode.h"
@interface Graviton : ForceNode

-(void) influenceParticle:(Particle *)particle;
@end
