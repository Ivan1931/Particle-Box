//
//  Engine.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "RenderView.h"
#include "Calculator.h"
#include "Timer.h"


@interface Engine : NSObject
{
    @public
    RenderView *view;
    Calculator *calc;
    CADisplayLink *renderLink;
    CADisplayLink *calculateLink;
    @private
    
    UIImage *image;
    unsigned char* data;
    NSUInteger len;
    
    CGColorSpaceRef colorSpace;
    
    uint width;
    uint height;
    
    
    
}

@property (nonatomic,retain) RenderView *view;
@property (nonatomic,retain) Calculator *calc;
@property (nonatomic,retain) CADisplayLink *renderLink;
@property (nonatomic,retain) CADisplayLink *calculateLink;
+ (Byte*) arrayOfBytesFromData:(NSData*) data;
+(UIImage*)blankImage:(CGSize)_size withColor:(UIColor*)_color; //Builds blank image with specified color

-(id) initWithSize:(CGRect)size andColor:(UIColor*)color;
-(void) updateImage;
-(void) render:(CADisplayLink*) link ;
-(void) clearRaster:(CADisplayLink*) link;
@end
