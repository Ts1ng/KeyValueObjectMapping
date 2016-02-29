//
//  DCPropertyFinderTests.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/17/12.
//  Copyright (c) 2012 dchohfi. All rights reserved.
//

#import "DCPropertyFinderTests.h"
#import "DCPropertyFinder.h"
#import "User.h"
#import "Person.h"
@interface DCPropertyFinderTests()

@property(nonatomic, strong) DCPropertyFinder *finder;

@end

@implementation DCPropertyFinderTests
@synthesize finder;

- (void)setUp {
    finder = [DCPropertyFinder finderWithKeyParser:[DCReferenceKeyParser parserForToken:@"_"]];  
}

- (void) testFindPropertyNameOnUser {
    DCDynamicAttribute *dynamicProperty = [finder findAttributeForKey:@"name" onClass:[User class]];
    XCTAssertNotNil(dynamicProperty, @"Should be able to find name property on User class");
    XCTAssertEqualObjects(@"name", dynamicProperty.objectMapping.attributeName, @"Attribute name should be equals to name");
    XCTAssertEqualObjects(@"name", dynamicProperty.objectMapping.keyReference, @"Keyreference should be equals to name");
}

- (void) testFindPropertyIdStrOnUser {
    DCDynamicAttribute *dynamicProperty = [finder findAttributeForKey:@"id_str" onClass:[User class]];
    XCTAssertNotNil(dynamicProperty, @"Should be able to find idStr property on User class");
    XCTAssertEqualObjects(@"idStr", dynamicProperty.objectMapping.attributeName, @"Attribute should be equals to idStr");
    XCTAssertEqualObjects(@"id_str", dynamicProperty.objectMapping.keyReference, @"Keyreference should be equals to id_str");
}

- (void) testUnknowAttributeNameForKey {
    DCDynamicAttribute *dynamicProperty = [finder findAttributeForKey:@"borba" onClass:[User class]];
    XCTAssertNil(dynamicProperty, @"Should be nill when a unknow key is passed");
}

- (void) testOverrideAttributeFinderForNameOnUser {
    DCObjectMapping *mapping = [DCObjectMapping mapKeyPath:@"borba" toAttribute:@"name" onClass:[User class]];
    [finder setMappers:[NSArray arrayWithObject:mapping]];
 
    DCDynamicAttribute *dynamicProperty = [finder findAttributeForKey:@"borba" onClass:[User class]];
    XCTAssertNotNil(dynamicProperty, @"Should be able to find name property on User class");
    XCTAssertEqualObjects(@"name", dynamicProperty.objectMapping.attributeName, @"Attribute name should be equals to name");
    XCTAssertEqualObjects(@"borba", dynamicProperty.objectMapping.keyReference, @"Keyreference should be equals to borba");
}
@end
