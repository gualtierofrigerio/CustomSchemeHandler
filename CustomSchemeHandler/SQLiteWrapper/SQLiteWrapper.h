//
//  SQLiteWrapper.h
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

#ifndef SQLiteWrapper_h
#define SQLiteWrapper_h

#import <Foundation/Foundation.h>

@interface SQLiteWrapper: NSObject
{
    NSString *_path;
}

- (id) initWithPath:(NSString *) path;
- (NSArray *) performQuery:(NSString *) query;

@end

#endif /* SQLiteWrapper_h */
