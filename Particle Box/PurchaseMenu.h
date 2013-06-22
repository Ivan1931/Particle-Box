//
//  PurchaseMenu.h
//  Particle Box
//
//  Created by Jonah Hooper on 2013/06/14.
//  Copyright (c) 2013 Jonah Hooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseMenu : UIView {
    UIButton *btnPurchase;
    UIButton *btnRestore;
    UILabel *labPurchase;
    UILabel *labRestore;
}

@property (nonatomic, retain) UIButton *btnPurchase;
@property (nonatomic, retain) UIButton *btnRestore;
@property (nonatomic, retain) UILabel *labPurchase;
@property (nonatomic, retain) UILabel *labRestore;

@end
