//
//  Calculator.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/03/26.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Calculator : NSObject
{
    @private
    unsigned char* data;
    NSMutableArray *particles;
}
#pragma mark - Properties
@property (nonatomic) unsigned char *data;
@property (nonatomic, strong) NSMutableArray *particles;
#pragma mark - Methods
-(void) calculate:(CADisplayLink*)link;

@end
