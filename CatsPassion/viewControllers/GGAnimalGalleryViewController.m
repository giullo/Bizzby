//
//  GGCatGalleryViewController.m
//  CatsPassion
//
//  Created by giullo on 06/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGAnimalGalleryViewController.h"
#import "GGModelController.h"
#import "GGGalleryRenderStrategy.h"

@interface GGAnimalGalleryViewController ()
@property (nonatomic, strong) GGModelController *modelCtrl;
@property (nonatomic, strong) GGGalleryRenderStrategy *renderStrategy;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@end

@implementation GGAnimalGalleryViewController

#pragma mark - Init

- (instancetype)initWithModelController:(id<GGModelControllerProtocol>)modelCtrl
                         renderStrategy:(id<GGRenderStrategyProtocol>)strategy
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _modelCtrl = modelCtrl;
        [_modelCtrl addDelegate:self];
        _renderStrategy = strategy;
    }
    return self;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.modelCtrl fetchDataWithRange:NSMakeRange(0, 0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GGModelControllerDelegate

- (void)modelControllerWillFetchData:(id<GGModelControllerProtocol>)modelCtrl
{
    [self.spinner startAnimating];
}

- (void)modelController:(id<GGModelControllerProtocol>)modelCtrl didReceiveData:(id)data error:(NSError *)error
{
    [self.spinner stopAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        self.collectionView.alpha = 1.0;
    }];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.modelCtrl numberOfItemsInSection:section];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.modelCtrl numberOfSections];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.renderStrategy.reuseIdentifier forIndexPath:indexPath];
    id item = [self.modelCtrl itemAtIndexPath:indexPath];
    self.renderStrategy.renderBlock(item, cell);
    return cell;
}

#pragma mark - Private

- (void)buildView
{
    if (self.collectionView) {
        return;
    }
    self.view.backgroundColor = [UIColor blackColor];
    CGSize itemSize = (DEVICE == IPAD) ? CGSizeMake(300, 300) : CGSizeMake(250, 250);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = itemSize;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.alpha = 0;
    [self.collectionView registerClass:self.renderStrategy.cellClass forCellWithReuseIdentifier:self.renderStrategy.reuseIdentifier];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    _spinner = [[UIActivityIndicatorView alloc] init];
    _spinner.hidesWhenStopped = YES;
    [_spinner stopAnimating];
    [self.view addSubview:_spinner];
    [_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

@end
