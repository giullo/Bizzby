//
//  GGRenderStrategy.h
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRenderStrategyProtocol.h"

@interface GGGalleryRenderStrategy : NSObject <GGRenderStrategyProtocol>

- (instancetype)initWithCellClass:(Class)cellClass
                  reuseIdentifier:(NSString *)reuseIdentifier
                      renderBlock:(GGRenderStrategyRenderBlock)renderBlock;

@property (nonatomic, strong, readonly) Class cellClass;
@property (nonatomic, strong, readonly) NSString *reuseIdentifier;
@property (nonatomic, copy, readonly) GGRenderStrategyRenderBlock renderBlock;
@end
