//
//  DCSerializationTests.m
//  KeyValueObjectMapping
//
//  Created by Diego Chohfi on 6/13/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCSerializationTests.h"
#import "DCKeyValueObjectMapping.h"
#import "DCObjectMapping.h"
#import "DCParserConfiguration.h"
#import "Bus.h"

@interface DCSerializationTests()

@property(nonatomic, strong) DCKeyValueObjectMapping *parser;

@end

@implementation DCSerializationTests
@synthesize parser;

-(void)setUp {
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    
    DCObjectMapping *nameMapper = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Bus class]];

    [configuration addObjectMapping:nameMapper];
    
    
    parser = [DCKeyValueObjectMapping mapperForClass:[Bus class] andConfiguration:configuration];

}

- (void)testSimpleFieldSerialization {
    Location *localizacao = [[Location alloc] initWithLatitude:[NSNumber numberWithInt:10] andLongitude:[NSNumber numberWithInt:20]];
    Bus *bus = [[Bus alloc] initWithName:@"Vila carrão" andLocation:localizacao];
    
    NSDictionary *busParsed = [parser serializeObject:bus];
    XCTAssertTrue([[busParsed objectForKey:@"name"] isEqualToString:@"Vila carrão"], @"test");
    XCTAssertTrue([[busParsed objectForKey:@"name"] isEqualToString:@"Vila carrão"], @"test");
}

- (void)testSimpleFieldSerializationUsingAddMapper {
    // build localParser
    DCParserConfiguration *configutaionUsingAddMapper = [DCParserConfiguration configuration];
    DCObjectMapping *nameMapper = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Bus class]];
    [configutaionUsingAddMapper addMapper:nameMapper];
    DCKeyValueObjectMapping *localParser = [DCKeyValueObjectMapping mapperForClass:[Bus class] andConfiguration:configutaionUsingAddMapper];
    
    // serialize it
    Location *localizacao = [[Location alloc] initWithLatitude:[NSNumber numberWithInt:10] andLongitude:[NSNumber numberWithInt:20]];
    Bus *bus = [[Bus alloc] initWithName:@"Vila carrão" andLocation:localizacao];
    
    NSDictionary *busParsed = [localParser serializeObject:bus];
    XCTAssertTrue([[busParsed objectForKey:@"name"] isEqualToString:@"Vila carrão"], @"test");
    XCTAssertTrue([[busParsed objectForKey:@"name"] isEqualToString:@"Vila carrão"], @"test");
}

- (void)testInvalidAddMapperSerialization {
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    DCObjectMapping *nameMapper = [DCObjectMapping mapKeyPath:@"name" toAttribute:@"name" onClass:[Bus class]];
    
    XCTAssertNoThrow([configuration addMapper:nameMapper], @"correct use of AddMapper should not throw exception");
    XCTAssertThrowsSpecificNamed([configuration addMapper:[NSObject new]],
                                NSException,
                                NSInternalInconsistencyException,
                                @"incorrect use of AddMapper: should throw NSInternalInconsistencyException");
}

@end
