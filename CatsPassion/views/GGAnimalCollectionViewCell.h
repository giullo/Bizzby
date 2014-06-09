//
//  GGAnimalCollectionViewCell.h
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGAnimalCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) NSURL *imageURL;
- (void)renderName:(NSString *)name;
- (void)renderImageWithURL:(NSURL *)URL;
@end
