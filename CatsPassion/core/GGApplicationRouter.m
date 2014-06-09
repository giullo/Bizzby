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

/* screen choice */
#import "GGAnimalChoiceViewController.h"

/* animal gallery */
#import "GGAnimalGalleryViewController.h"
#import "GGGalleryRenderStrategy.h"
#import "GGAnimalCollectionViewCell.h"

/* cats gallery */
#import "GGCatsListService.h"
#import "GGCat.h"

/* Dogs gallery */
#import "GGDogsListService.h"
#import "GGDog.h"



@interface GGApplicationRouter ()
@property (nonatomic, strong) AFHTTPSessionManager *XMLSessionManager;
@property (nonatomic, strong) AFHTTPSessionManager *JSONSessionManager;
@property (nonatomic, strong) UINavigationController *rootNavigationController;
@end

@implementation GGApplicationRouter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _XMLSessionManager = [AFHTTPSessionManager manager];
        _XMLSessionManager.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        _JSONSessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)bootStrap
{
    [JLRoutes setVerboseLoggingEnabled:YES];
    NSString *schema = [NSURL cp_schema];
    JLRoutes *router = [JLRoutes routesForScheme:schema];
    /* register routes */
    
    [router addRoute:NSURLRouteCatDetail handler:^BOOL(NSDictionary *parameters) {
        [self pushViewController:[self catDetailViewControllerWithParams:parameters] options:nil];
        return YES;
    }];
    
    [router addRoute:NSURLRouteCatGallery handler:^BOOL(NSDictionary *parameters) {
        [self pushViewController:[self catGalleryViewControllerWithParams:nil] options:nil];
        return YES;
    }];
    
    [router addRoute:NSURLRouteDogGallery handler:^BOOL(NSDictionary *parameters) {
        [self pushViewController:[self dogGalleryViewControllerWithParams:nil] options:nil];
        return YES;
    }];
}

- (UIViewController *)rootViewController
{
    if (self.rootNavigationController == nil) {
        UINavigationController *ctrl = [[UINavigationController alloc] initWithRootViewController:[self animalChoiceViewController]];
        self.rootNavigationController = ctrl;
    }
    return self.rootNavigationController;
}

#pragma mark - Private

- (void)pushViewController:(UIViewController *)viewCtrl options:(NSDictionary *)opts
{
    [self.rootNavigationController pushViewController:viewCtrl animated:YES];
}

- (UIViewController *)animalChoiceViewController
{
    UIViewController *viewCtrl = [[GGAnimalChoiceViewController alloc] initWithNibName:nil bundle:nil];
    viewCtrl.title = @"Your favourite animal?";
    return viewCtrl;
}

- (UIViewController *)catGalleryViewControllerWithParams:(NSDictionary *)params
{
    GGCatsListService *catsListService = [[GGCatsListService alloc] initWithURL:[NSURL URLWithString:@"http://thecatapi.com/api/images/get?format=xml&results_per_page=200&size=small"] sessionManager:self.XMLSessionManager];
    GGModelController *modelCtrl = [[GGModelController alloc] initWithService:catsListService];
    GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:[GGAnimalCollectionViewCell class] reuseIdentifier:@"Cats" renderBlock:^(GGCat *cat, GGAnimalCollectionViewCell *view) {
        [view renderName:cat.name];
        [view renderImageWithURL:cat.thumbImageURL];
    }];
    GGAnimalGalleryViewController *viewCtrl = [[GGAnimalGalleryViewController alloc] initWithModelController:modelCtrl renderStrategy:strategy];
    viewCtrl.title = @"Cats Gallery";
    return viewCtrl;
}

- (UIViewController *)dogGalleryViewControllerWithParams:(NSDictionary *)params
{
    GGDogsListService *dogListService = [[GGDogsListService alloc] initWithURL:[NSURL URLWithString:@"http://giulianogalea.info/dogs/dogs.json"] sessionManager:self.JSONSessionManager];
    GGModelController *modelCtrl = [[GGModelController alloc] initWithService:dogListService];
    GGGalleryRenderStrategy *strategy = [[GGGalleryRenderStrategy alloc] initWithCellClass:[GGAnimalCollectionViewCell class] reuseIdentifier:@"Cats" renderBlock:^(GGDog *dog, GGAnimalCollectionViewCell *view) {
        [view renderName:dog.anotherName];
        [view renderImageWithURL:dog.URL];
    }];
    GGAnimalGalleryViewController *viewCtrl = [[GGAnimalGalleryViewController alloc] initWithModelController:modelCtrl renderStrategy:strategy];
    viewCtrl.title = @"Dogs Gallery";
    return viewCtrl;
}

- (UIViewController *)catDetailViewControllerWithParams:(NSDictionary *)params
{
    return nil;
}

@end
