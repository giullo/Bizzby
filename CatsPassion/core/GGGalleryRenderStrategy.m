//
//  GGRenderStrategy.m
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGGalleryRenderStrategy.h"

@implementation GGGalleryRenderStrategy

- (instancetype)initWithCellClass:(Class)cellClass
                  reuseIdentifier:(NSString *)reuseIdentifier
                      renderBlock:(GGRenderStrategyRenderBlock)renderBlock
{
    NSParameterAssert(cellClass);
    NSParameterAssert(renderBlock);
    self = [super init];
    if (self) {
        _cellClass = cellClass;
        _reuseIdentifier = reuseIdentifier;
        _renderBlock = renderBlock;
    }
    return self;
}

@end
