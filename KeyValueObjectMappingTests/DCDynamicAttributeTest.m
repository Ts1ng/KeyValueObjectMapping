//
//  DynamicAttributeTest.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/14/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "DCDynamicAttributeTest.h"
#import "DCDynamicAttribute.h"
#import "Tweet.h"
@implementation DCDynamicAttributeTest

- (void) testDynamicAttributeForPrimitiveInt {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"Ti,R,N,Vage"
                                                                                      forKey:@"age"
                                                                                     onClass:[Tweet class]];
    XCTAssertEqual(attribute.classe, [Tweet class], @"Should be the same class");
    XCTAssertTrue([attribute isPrimitive], @"Should be a primitive attribute");
    XCTAssertFalse([attribute isIdType], @"Should not be and id type");
    XCTAssertFalse([attribute isValidObject], @"Should not be a valid object");
    XCTAssertNil(attribute.objectMapping.classReference, @"Should be nil when attribute is primitive");
    XCTAssertEqualObjects(attribute.typeName, @"i", @"Should be an integer attribute");
    XCTAssertEqualObjects(attribute.objectMapping.attributeName, @"age", @"AttributeName should be age");
}

- (void) testDynamicAttributeForNSStringType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSString\",&,N,Vadress" forKey:@"adress" onClass:[Tweet class]];
    XCTAssertEqual(attribute.classe, [Tweet class], @"Should be the same class");
    XCTAssertFalse([attribute isPrimitive], @"Should be a class");
    XCTAssertFalse([attribute isIdType], @"Should not be and id type");
    XCTAssertTrue([attribute isValidObject], @"Should not be a valid object");
    XCTAssertEqual(attribute.objectMapping.classReference, [NSString class], @"Should be NSString class");
    XCTAssertEqualObjects(attribute.typeName, @"NSString", @"Should be a NSString attribute");
    XCTAssertEqualObjects(attribute.objectMapping.attributeName, @"adress", @"AttributeName should be adress");
}

- (void) testDynamicAttributeForNSDateType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSDate\",&,N,VdataNascimento" forKey:@"dataNascimento" onClass:[Tweet class]];
    XCTAssertEqual(attribute.classe, [Tweet class], @"Should be the same class");
    XCTAssertFalse([attribute isPrimitive], @"Should be a class");
    XCTAssertFalse([attribute isIdType], @"Should not be and id type");
    XCTAssertTrue([attribute isValidObject], @"Should not be a valid object");
    XCTAssertEqual(attribute.objectMapping.classReference, [NSDate class], @"Should be NSDate class");
    XCTAssertEqualObjects(attribute.typeName, @"NSDate", @"Should be a NSDate attribute");
    XCTAssertEqualObjects(attribute.objectMapping.attributeName, @"dataNascimento", @"AttributeName should be dataNascimento");
}

- (void) testDynamicAttributeForIdType {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@,&,N,Vid" forKey:@"id" onClass:[Tweet class]];
    XCTAssertEqual(attribute.classe, [Tweet class], @"Should be the same class");
    XCTAssertFalse([attribute isPrimitive], @"Should be a class");
    XCTAssertFalse([attribute isValidObject], @"Should not be a valid object");
    XCTAssertTrue([attribute isIdType], @"Should be and id type");
    XCTAssertNil(attribute.objectMapping.classReference, @"Should be nil when attribute is id");
    XCTAssertNil(attribute.typeName, @"Should be null when attribut is id");
    XCTAssertEqualObjects(attribute.objectMapping.attributeName, @"id", @"AttributeName should be id");
}

- (void) testDynamicNotSynthetizedAttribute {
    DCDynamicAttribute *attribute = [[DCDynamicAttribute alloc] initWithAttributeDescription:@"T@\"NSString\",&,D,N" forKey:@"adress" onClass:[Tweet class] attributeName:@"adress"];
    XCTAssertEqual(attribute.classe, [Tweet class], @"Should be the same class");
    XCTAssertFalse([attribute isPrimitive], @"Should be a class");
    XCTAssertFalse([attribute isIdType], @"Should not be and id type");
    XCTAssertTrue([attribute isValidObject], @"Should not be a valid object");
    XCTAssertEqual(attribute.objectMapping.classReference, [NSString class], @"Should be NSString class");
    XCTAssertEqualObjects(attribute.typeName, @"NSString", @"Should be a NSString attribute");
    XCTAssertEqualObjects(attribute.objectMapping.attributeName, @"adress", @"AttributeName should be adress");
}
@end
