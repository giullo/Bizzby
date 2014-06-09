//
//  GGCatsListService.m
//  CatsPassion
//
//  Created by giullo on 05/06/2014.
//  Copyright (c) 2014 Giuliano Galea. All rights reserved.
//

#import "GGCatsListService.h"
#import "GGCat.h"

static NSString * parserResponseKey         = @"response";
static NSString * parserImageKey            = @"image";
static NSString * parserIdKey               = @"id";

@interface GGCatsListService()
@property (nonatomic, strong) NSMutableArray *cats;
@property (nonatomic, strong) GGCat *catTmp;
@property (nonatomic, strong) NSMutableString *stringBuffer;
@property (nonatomic, assign) BOOL isId;
@property (nonatomic, strong) NSString *thumbURLTemplate;
@end

@implementation GGCatsListService

- (instancetype)initWithURL:(NSURL *)url sessionManager:(AFHTTPSessionManager *)sessionManager
{
    self = [super initWithURL:url sessionManager:sessionManager];
    if (self) {
        self.sessionManager.responseSerializer = [[AFXMLParserResponseSerializer alloc] init];
        _thumbURLTemplate = [NSString stringWithFormat:@"%@://%@%@", url.scheme, url.host, [url.pathComponents componentsJoinedByString:@"/"]];
    }
    return self;
}

- (void)processResponseData:(id)response error:(NSError *)error
{
    NSXMLParser *parser = (NSXMLParser *)response;
    parser.delegate = self;
    /* execute the actual xml parsing on another thread */
    /* no need to protect the mutable variables, they are safe */
    /* if accessed always by the same thread */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        self.cats = [NSMutableArray new];
        self.stringBuffer = [NSMutableString new];
        [parser parse];
    });
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    self.isId = [elementName isEqualToString:parserIdKey];
    if ([elementName isEqualToString:parserImageKey]) {
        self.catTmp = [GGCat new];
        self.catTmp.name = [NSString stringWithFormat:@"Cat %i", self.cats.count];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.isId) {
        [self.stringBuffer appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:parserIdKey]) {
        self.catTmp.uniqueId = [self.stringBuffer copy];
        /* http://thecatapi.com/api/images/get?image_id=707 */
        NSString *fullPath = [self.thumbURLTemplate stringByAppendingFormat:@"?image_id=%@&size=small", self.catTmp.uniqueId];
        self.catTmp.thumbImageURL = [NSURL URLWithString:fullPath];
        [self.stringBuffer setString:@""];
        self.isId = NO;
    } else if ([elementName isEqualToString:parserImageKey]) {
        [self.cats addObject:self.catTmp];
    } else if ([elementName isEqualToString:parserResponseKey]) {
        /* we are done, call back to the superclass on the main thread */
        dispatch_async(dispatch_get_main_queue(), ^{
            [super processResponseData:[self.cats copy] error:nil];
        });
    }
}

@end
