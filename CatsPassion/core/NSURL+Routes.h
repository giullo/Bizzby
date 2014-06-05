//
//  NSURL+Routes.h
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

// Routes
extern NSString * const NSURLRouteCatGallery;
extern NSString * const NSURLRouteCatDetail;


#import <Foundation/Foundation.h>

@interface NSURL (Routes)

/**
 Returns the schema for the Cats app
 */
+ (NSString *)cp_schema;

/**
    Returns a properly configured url for the gallery route
 */
+ (NSURL *)cp_URLForCatGallery;

/**
 Returns a properly configured url for the detail route
 */
+ (NSURL *)cp_URLForCatDetailWithId:(NSString *)theId;

@end
