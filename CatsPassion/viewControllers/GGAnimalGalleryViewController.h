//
//  GGCatGalleryViewController.h
//  CatsPassion
//
//  Created by giullo on 06/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGModelControllerProtocol.h"
#import "GGRenderStrategyProtocol.h"

@interface GGAnimalGalleryViewController : UIViewController <
                                                            GGModelControllerDelegate,
                                                            UICollectionViewDataSource,
                                                            UICollectionViewDelegate,
                                                            UICollectionViewDelegateFlowLayout
                                                        >

- (instancetype)initWithModelController:(id <GGModelControllerProtocol>)modelCtrl
                         renderStrategy:(id <GGRenderStrategyProtocol>)strategy;
@end
