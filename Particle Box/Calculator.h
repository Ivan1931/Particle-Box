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
@interface Calculator : NSObject
{
    @private
    unsigned char* data;
    NSMutableArray *particles;
    NSMutableArray *forces;
    int frameNumber;
    int bytesPerRow;
    Vec2 dims;
    BOOL reset;
    BOOL tail;
    BOOL whirls;
}
#pragma mark - Properties
@property (nonatomic) unsigned char *data;
@property (nonatomic, strong) NSMutableArray *particles;
@property (nonatomic, strong) NSMutableArray *forces;
#pragma mark - Methods
-(void) calculate:(CADisplayLink*)link;
-(id) initWithData:(unsigned char*)pdata andDimesions:(Vec2)xy;
-(void) spawn1000Particles;
-(void) moveGravity:(CGPoint)xy;
-(void) LineBresenhamwithX1:(int)x1 andX2:(int)x2 andY1:(int)y1 andY2:(int)y2 andColor:(Color)col;
+(float) randFloatBetween:(float)low and:(float)high;
@end
