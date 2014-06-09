//
//  GGDogsListService.m
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGDogsListService.h"
#import "GGDog.h"

@implementation GGDogsListService

- (instancetype)initWithURL:(NSURL *)url sessionManager:(AFHTTPSessionManager *)sessionManager
{
    self = [super initWithURL:url sessionManager:sessionManager];
    if (self) {
        
    }
    return self;
}

- (void)processResponseData:(id)response error:(NSError *)error
{
    NSArray *results = [response objectForKey:@"dogs"];
    NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:results.count];
    for (NSDictionary *dogDict in results) {
        GGDog *dog = [GGDog new];
        dog.anotherName = dogDict[@"name"];
        dog.URL = [NSURL URLWithString:dogDict[@"url"]];
        [tmp addObject:dog];
    }
    [super processResponseData:[tmp copy] error:error];
}

@end
