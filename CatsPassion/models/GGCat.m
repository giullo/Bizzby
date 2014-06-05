//
//  GGCat.m
//  CatsPassion
//
//  Created by giullo on 06/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGCat.h"

@implementation GGCat

- (NSString *)description
{
    return [NSString stringWithFormat:@"{%@ - %@}", self.name, self.uniqueId];
}

@end
