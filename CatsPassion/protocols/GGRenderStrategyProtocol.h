//
//  GGRenderStrategyProtocol.h
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GGRenderStrategyRenderBlock) (id obj, id view);

@protocol GGRenderStrategyProtocol <NSObject>

@required
- (Class)cellClass;
- (GGRenderStrategyRenderBlock)renderBlock;
- (NSString *)reuseIdentifier;
@end
