//
//  NSURL+Routes.m
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "NSURL+Routes.h"

NSString * const GGCatsScheme = @"cats";

// Routes
NSString * const NSURLRouteCatGallery              = @"/cat-gallery";
NSString * const NSURLRouteCatDetail               = @"/cat-detail/:id";

@implementation NSURL (Routes)

+ (NSString *)cp_schema
{
    return GGCatsScheme;
}

+ (NSURL *)cp_URLForCatGallery
{
    return [self cp_URLForPath:NSURLRouteCatGallery params:nil];
}

+ (NSURL *)cp_URLForCatDetailWithId:(NSString *)theId
{
    NSParameterAssert(theId);
    return [self cp_URLForPath:NSURLRouteCatDetail params:@{@":id" : theId}];
}

#pragma mark - Private

+ (NSURL *)cp_URLForPath:(NSString *)path params:(NSDictionary *)params
{
    NSParameterAssert(path);
    __block NSString *pathForValues = path;
    [params enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        pathForValues = [pathForValues stringByReplacingOccurrencesOfString:key withString:value];
    }];
    NSString *urlPath = [NSString stringWithFormat:@"%@:/%@", [self cp_schema], pathForValues];
    return [NSURL URLWithString:urlPath];
}

@end
