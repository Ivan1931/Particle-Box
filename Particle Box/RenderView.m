//
//  RenderView.m
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/25.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import "RenderView.h"

@implementation RenderView

CGPoint origion;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void) drawImage:(UIImage*)image{
    self.layer.contents = (id)image.CGImage;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"A touch detected");
    [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"A touch detected");
    [self.nextResponder touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"A touch detected");
    [self.nextResponder touchesEnded:touches withEvent:event];
}

-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"A touch detected");
    [self.nextResponder touchesCancelled:touches withEvent:event];
}
@end
