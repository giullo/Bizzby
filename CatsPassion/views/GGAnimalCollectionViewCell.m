//
//  GGAnimalCollectionViewCell.m
//  CatsPassion
//
//  Created by giullo on 09/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGAnimalCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface GGAnimalCollectionViewCell ()
@property (nonatomic, strong) UIView *labelBGView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation GGAnimalCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        _labelBGView = [[UIView alloc] init];
        _labelBGView.backgroundColor = [UIColor blackColor];
        _labelBGView.alpha = 0.8;
        [self addSubview:_labelBGView];
        [_labelBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView);
            make.height.equalTo(@25);
            make.bottom.equalTo(self.contentView);
        }];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        _nameLabel.textColor = [UIColor lightTextColor];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.labelBGView);
        }];
        
        _spinner = [[UIActivityIndicatorView alloc] init];
        [_spinner hidesWhenStopped];
        [_spinner stopAnimating];
        [self.contentView addSubview:_spinner];
        [_spinner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
        }];
        
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView);
            make.trailing.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)dealloc
{
    [self.imageView cancelImageRequestOperation];
}

- (void)renderImageWithURL:(NSURL *)url
{
    /* to avoid flickering during fast scrolling i save the url of the image */
    /* and then in the block i check that the url is still the same before */
    /* setting the actual image */
    [self.spinner startAnimating];
    self.imageURL = url;
    NSURL *currentURL = self.imageURL;
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    __block __typeof(self)weakSelf = self;
    [self.imageView setImageWithURLRequest:req placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        __typeof(weakSelf)strongSelf = weakSelf;
        if ([currentURL isEqual:weakSelf.imageURL]) {
            strongSelf.imageView.image = image;
        }
        [strongSelf.spinner stopAnimating];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        __typeof(weakSelf)strongSelf = weakSelf;
        /* a code of -999 means the request has been cancelled because the cell was reused */
        /* we don't display any error in this case and still show the spinner */
        if (error.code != -999) {
            [strongSelf.spinner stopAnimating];
            strongSelf.statusLabel.text = @"Could not load image";
        }
    }];
}

- (void)renderName:(NSString *)name
{
    self.nameLabel.text = name;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
    [self.spinner stopAnimating];
    self.statusLabel.text = @"";
}

@end
