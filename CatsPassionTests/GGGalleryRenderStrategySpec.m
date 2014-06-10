//
//  GGGalleryRenderStrategySpec.m
//  CatsPassion
//
//  Created by giuliano galea on 10/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "Kiwi.h"
#import "GGGalleryRenderStrategy.h"

SPEC_BEGIN(GGGalleryRenderStrategySpec)

describe(@"GGGalleryRenderStrategy", ^{
    context(@"when created with all mandatory params", ^{
        it(@"should return a proper instance", ^{
            Class klass = [UICollectionViewCell class];
            NSString *reuse = @"reuse";
            GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:klass reuseIdentifier:reuse renderBlock:^(id obj, id view) {
                
            }];
            [[strategy should] beNonNil];
            [[strategy.cellClass should] equal:klass];
            [[strategy.renderBlock should] beNonNil];
        });
    });
    
    context(@"when created with missing parameters", ^{
        it(@"an assert should be thrown", ^{
            [[theBlock(^{
                GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:nil reuseIdentifier:@"" renderBlock:^(id obj, id view) {
                    
                }];
                strategy = nil;
            }) should] raise];
            
            [[theBlock(^{
                GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:[NSObject class] reuseIdentifier:@"" renderBlock:nil];
                strategy = nil;
            }) should] raise];
        });
    });
    
    context(@"when created with a wrong cell class that is not a UICollectionViewCell", ^{
        it(@"an assert should be thrown", ^{
            [[theBlock(^{
                GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:[NSObject class] reuseIdentifier:@"" renderBlock:^(id obj, id view) {}];
                strategy = nil;
            }) should] raise];
        });
    });
});

SPEC_END
