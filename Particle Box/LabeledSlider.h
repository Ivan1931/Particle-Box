//
//  LabeledSlider.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/09.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>

extern const float VERT_OFFSET;
extern const float HORZ_OFFSET;
extern const float DIST_BTW_LAB_SLR; //Distance between label and slider
extern const float LAB_SHARE_HEIGHT; //Percentage of the height of the component the label will share

@interface LabeledSlider : UIView {
    UISlider *slider;
    UILabel *label;
}

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *label;

-(id) initWithFrame:(CGRect)frame withTex:(NSString *) text;

@end
