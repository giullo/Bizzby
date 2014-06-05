//
//  GGCatGalleryViewController.m
//  CatsPassion
//
//  Created by giullo on 06/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGCatGalleryViewController.h"

@interface GGCatGalleryViewController ()
@property (nonatomic, strong) GGModelController *modelCtrl;
@end

@implementation GGCatGalleryViewController

- (instancetype)initWithModelController:(id<GGModelControllerProtocol>)modelCtrl
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _modelCtrl = modelCtrl;
        [_modelCtrl addDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.modelCtrl fetchDataWithRange:NSMakeRange(0, 0)];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GGModelControllerDelegate

- (void)modelControllerWillFetchData:(id<GGModelControllerProtocol>)modelCtrl
{
    
}

- (void)modelController:(id<GGModelControllerProtocol>)modelCtrl didReceiveData:(id)data error:(NSError *)error
{
    
}

@end
