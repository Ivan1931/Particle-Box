//
//  SmallMenuView.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/04.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallMenuView : UIView {
    @private
    UIButton *btnNextMode;
    UIButton *btnPurchase;
    UIButton *btnOpenOptions;
    UIButton *btnReset;
    UIButton *btnHelp;
    
    int modeNumber;
    
}

@property (nonatomic, strong) UIButton *btnNextMode;
@property (nonatomic, strong) UIButton *btnPurchase;
@property (nonatomic, strong) UIButton *btnOpenOptions;
@property (nonatomic, strong) UIButton *btnReset;
@property (nonatomic, strong) UIButton *btnHelp;

-(id) initWithFrame:(CGRect)frame forceMode:(int) mode;

@end
