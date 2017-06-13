//
//  XMLtoAtarashiiFormat.m
//  AniLibrary Sync
//
//  Created by 桐間紗路 on 2017/06/13.
//  Copyright © 2017 Atelier Shiori. All rights reserved.
//

#import "XMLtoAtarashiiFormat.h"
#import "XMLReader.h"

@implementation XMLtoAtarashiiFormat
+ (NSArray *)MALSearchXMLToAtarashiiDataFormat:(NSString *)xml {
    NSError *error = nil;
    NSDictionary *d = [XMLReader dictionaryForXMLString:xml options:XMLReaderOptionsProcessNamespaces error:&error];
    NSArray *searchresults;
    if (d[@"anime"]) {
        searchresults = d[@"anime"][@"entry"];
        if (![searchresults isKindOfClass:[NSArray class]]) {
            // Import only contains one object, put it in an array.
            searchresults = [NSArray arrayWithObject:searchresults];
        }
    }
    else {
        return @[];
    }
    NSMutableArray *output = [NSMutableArray new];
    for (NSDictionary *d in searchresults) {
        NSMutableArray *synonyms = [NSMutableArray new];
        NSString *englishtitle = @"";
        if (d[@"english"][@"text"]) {
            [synonyms addObject:d[@"english"][@"text"]];
            englishtitle = d[@"english"][@"text"];
        }
        if (d[@"synonyms"][@"text"]) {
            [synonyms addObjectsFromArray:[((NSString *)d[@"synonyms"][@"text"]) componentsSeparatedByString:@";"]];
        }
        [output addObject:@{@"id":@(((NSString *)d[@"id"][@"text"]).intValue), @"episodes":@(((NSString *)d[@"episodes"][@"text"]).intValue), @"score":@(((NSString *)d[@"score"][@"text"]).floatValue), @"status":d[@"status"][@"text"], @"start_date":[NSString stringWithFormat:@"%@",d[@"start_date"][@"text"]], @"end_date":[NSString stringWithFormat:@"%@",d[@"end_date"][@"text"]], @"synonyms": synonyms, @"synopsis":[NSString stringWithFormat:@"%@",d[@"synopsis"][@"text"]], @"type":d[@"type"][@"text"], @"title":d[@"title"][@"text"], @"english_title":englishtitle}];
    }
    return output;
}

@end
