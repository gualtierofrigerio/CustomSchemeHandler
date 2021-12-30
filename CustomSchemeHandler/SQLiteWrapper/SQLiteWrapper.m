//
//  SQLiteWrapper.m
//  CustomSchemeHandler
//
//  Created by Gualtiero Frigerio on 24/12/21.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

#import "SQLiteWrapper.h"

@interface SQLiteWrapper()
{
    sqlite3 *_database;
}

- (sqlite3 *) openDatabase;

@end

@implementation SQLiteWrapper

- (id) initWithPath:(NSString *)path {
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

- (NSArray *)performQuery:(NSString *)query {
    sqlite3 *database = [self openDatabase];
    if (database == nil) {
        return nil;
    }
    
    int error;
    const char *sqlStatement = [query UTF8String];
    sqlite3_stmt *compiledStatement;
    NSMutableArray *results = nil;
    
    error = sqlite3_prepare_v2(database,
                               sqlStatement,
                               -1,
                               &compiledStatement,
                               NULL);
    
    if (error == SQLITE_OK) {
        results = [[NSMutableArray alloc] init];
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
        {
            NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
            int count = sqlite3_column_count(compiledStatement);
            
            for (int i = 0; i < count; i++) {
                @try {
                    NSString *name = [NSString stringWithUTF8String:(char *) sqlite3_column_name(compiledStatement, i)];
                    NSString *value = [NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, i)];
                    if (name && value) {
                        [dictionary setValue:value forKey:name];
                    }
                }
                @catch (id exception) {
                    NSLog(@"exception %@", exception);
                }
            }
            
            [results addObject:dictionary];
        }
    }
    sqlite3_finalize(compiledStatement);
    
    return results;
}

#pragma mark Private

- (sqlite3 *)openDatabase {
    sqlite3 *database;
    if (_database != nil) {
        return _database;
    }
    
    int error = sqlite3_open([_path UTF8String], &database);
    if(error == SQLITE_OK)
    {
        _database = database;
        return database;
    }
    
    return nil;
}

@end
