//
//  GGNSURLRoutesSpec.m
//  CatsPassion
//
//  Created by giuliano galea on 10/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "Kiwi.h"
#import "NSURL+Routes.h"

SPEC_BEGIN(NSURLRoutesSpec)

describe(@"NSURL+Routes", ^{
    context(@"when creating URLs", ^{
        it(@"should return proper urls", ^{
            NSURL *screenChoiceURL = [NSURL cp_URLForScreenChoice];
            NSURL *catGalleryURL = [NSURL cp_URLForCatGallery];
            NSURL *dogGalleryURL = [NSURL cp_URLForDogGallery];
            NSString *scheme = [NSURL cp_schema];
            [[screenChoiceURL should] equal:[NSURL URLWithString:@"cats://screen-choice"]];
            [[catGalleryURL should] equal:[NSURL URLWithString:@"cats://cat-gallery"]];
            [[dogGalleryURL should] equal:[NSURL URLWithString:@"cats://dog-gallery"]];
            [[scheme should] equal:@"cats"];
        });
    });
});

SPEC_END
