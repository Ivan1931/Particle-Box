//
//  Calculator.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Particle.h"
#import "Graviton.h"
#import "Whirl.h"
#import "Rose.h"
#import "Ribbon.h"
#import "BackShot.h"
#import "Suction.h"
#import "Spirals.h"

@interface Calculator : NSObject
{
    @private
    unsigned char* data;
    NSMutableArray *particles;
    int frameNumber;
    int bytesPerRow;
    Vec2 dims;
    BOOL reset;
    BOOL tail;
    BOOL whirls;
    ForceNode *node;
}
#pragma mark - Properties
@property (nonatomic) unsigned char *data;
@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) ForceNode *node;
#pragma mark - Methods
-(void) calculate:(CADisplayLink*)link;
-(id) initWithData:(unsigned char*)pdata andDimesions:(Vec2)xy;
-(void) spawnParticles;
-(void) moveGravity:(CGPoint)xy;

+(float) randFloatBetween:(float)low and:(float)high;

-(void) spawnNode;
-(void) spawnRose;
-(void) swawnGravity;
-(void) swawnRibbon;
-(void) spawnWhirl;
-(void) spawnSuction;
-(void) spawnBackShot;
-(void) spawnSpiral;
@end
