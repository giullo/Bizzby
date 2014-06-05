//
//  GGApplicationBuilder.m
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGApplicationRouter.h"
#import "NSURL+Routes.h"
#import <JLRoutes/JLRoutes.h>
#import "GGModelController.h"

/* cats gallery */
#import "GGCatsListService.h"
#import "GGCatGalleryViewController.h"


@interface GGApplicationRouter ()
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end

@implementation GGApplicationRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
    }
    return self;
}

- (void)bootStrap
{
    [JLRoutes setVerboseLoggingEnabled:YES];
    /* register routes */
    [[JLRoutes routesForScheme:[NSURL cp_schema]] addRoute:NSURLRouteCatDetail handler:^BOOL(NSDictionary *parameters) {
        
        return YES;
    }];
}

- (UIViewController *)rootViewController
{
    return [self catGalleryViewController];
}

#pragma mark - Private

- (UIViewController *)catGalleryViewController
{
    GGCatsListService *catsListService = [[GGCatsListService alloc] initWithURL:[NSURL URLWithString:@"http://thecatapi.com/api/images/get?format=xml&results_per_page=200&size=small"] sessionManager:self.sessionManager];
    GGModelController *modelCtrl = [[GGModelController alloc] initWithService:catsListService];
    GGCatGalleryViewController *viewCtrl = [[GGCatGalleryViewController alloc] initWithModelController:modelCtrl];
    return viewCtrl;
}

@end
