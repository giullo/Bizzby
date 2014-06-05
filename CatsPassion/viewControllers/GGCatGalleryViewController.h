//
//  GGCatGalleryViewController.h
//  CatsPassion
//
//  Created by giullo on 06/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGModelController.h"

@interface GGCatGalleryViewController : UIViewController <GGModelControllerDelegate>

- (instancetype)initWithModelController:(id <GGModelControllerProtocol>)modelCtrl;
@end
