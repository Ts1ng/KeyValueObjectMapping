//
//  DCKeyValueObjectMappingTests.m
//  DCKeyValueObjectMappingTests
//
//  Created by Diego Chohfi on 4/13/12.
//  Copyright (c) 2012 None. All rights reserved.
//

#import "KeyValueObjectMappingTests.h"
#import "DCParserConfiguration.h"
#import "DCKeyValueObjectMapping.h"
#import "DCArrayMapping.h"
#import "DCCustomInitialize.h"
#import "DCCustomParser.h"
#import "Person.h"
#import "Tweet.h"
#import "User.h"

@interface KeyValueObjectMappingTests()

@property(nonatomic,strong) NSDictionary *plist;
@property(nonatomic,strong) NSDictionary *json;

@end
@implementation KeyValueObjectMappingTests
@synthesize plist, json;
- (void)setUp
{
    [super setUp];
    
    NSString *pathToFile = [[NSBundle bundleForClass: [self class]] pathForResource:@"plist" ofType:@"plist"];
    plist = [NSDictionary dictionaryWithContentsOfFile:pathToFile];
    
    
    NSString *caminhoJson = [[NSBundle bundleForClass: [self class]] pathForResource:@"tweet" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:caminhoJson];
    
    json = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers error:nil];
    
}

- (void) testValidPlistToPerson
{
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    configuration.datePattern = @"yyyy-MM-dd'T'hh:mm:ssZ";
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Person class] andConfiguration:configuration];
    Person *person = [parser parseDictionary:plist];
    XCTAssertEqualObjects(person.name, @"Diego Chohfi Turini", @"Should be equals name");
    XCTAssertEqualObjects(person.adress, @"Rua dos bobos, n 0", @"Should be equals adress");
    XCTAssertEqualObjects(person.phone, @"+551199999999", @"Should be equals phone");
    XCTAssertEqual(person.age, 24, @"Should be equals age");
    XCTAssertEqualObjects(person.birthDay, [NSDate dateWithTimeIntervalSince1970:565927200], @"Should be equals NSDate");
    XCTAssertNotNil(person.parents, @"Should be able to parse NSArray");
    XCTAssertTrue(person.valid, @"Person should be valid");
    XCTAssertEqualObjects(person.url, [NSURL URLWithString:@"http://dchohfi.com/"], @"Should create equals urls");
    XCTAssertEqualObjects(person.nota, [NSNumber numberWithInt:10], @"Should be equals");
    XCTAssertEqualObjects(person.dateWithString, [NSDate dateWithTimeIntervalSince1970:0], @"Should create equals NSDate");
    XCTAssertEqual((int)[person.arrayPrimitive count], 4, @"Should have same size");
    XCTAssertEqualObjects([person.arrayPrimitive objectAtIndex:0], @"hello", @"Should have hello on first position of array");
    XCTAssertEqualObjects([person.arrayPrimitive objectAtIndex:1], @"mutchaco", @"Should have muthaco on first position of array");
    XCTAssertEqualObjects([person.arrayPrimitive objectAtIndex:2], [NSNumber numberWithInt:1], @"Should have muthaco on first position of array");
    XCTAssertEqualObjects([person.arrayPrimitive objectAtIndex:3], [NSNumber numberWithDouble:3.1416], @"Should have muthaco on first position of array");
    configuration = nil;
}

-(void) testValidJsonToTweet {
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = config.datePattern;
    NSDate *data = [formatter dateFromString:@"Sat Apr 14 00:20:07 +0000 2012"];
    
    DCKeyValueObjectMapping * parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:config];
    
    Tweet *tweet = [parser parseDictionary:json];
    XCTAssertEqualObjects(tweet.idStr, @"190957570511478784", @"Should have same idStr");
    XCTAssertEqualObjects(tweet.text, @"@pedroh96 cara, comecei uma lib pra iOS, se puder dar uma olhada e/ou contribuir :D KeyValue Parse for Objective-C https://t.co/NWMMc60v", @"Should have same text");
    XCTAssertEqualObjects(tweet.source, @"<a href=\"http://www.osfoora.com/mac\" rel=\"nofollow\">Osfoora for Mac</a>", @"Should have same source");
    XCTAssertNil(tweet.inReplyToStatusIdStr, @"inRepryToStatusIdStr should be null");
    XCTAssertTrue([tweet.retweetCount isEqualToNumber:@(0)], @"RetweetCount should be equals to 0");
    XCTAssertFalse(tweet.favorited, @"favorited should be false");
    XCTAssertFalse(tweet.retweeted, @"favorited should be false");
    XCTAssertEqualObjects(tweet.createdAt, data, @"CreatedAt should be equals");
    
    data = [formatter dateFromString:@"Tue Mar 31 18:01:12 +0000 2009"];
    
    User *user = tweet.user;
    XCTAssertEqualObjects(user.idStr, @"27924446", @"Should have same idStr for user");
    XCTAssertEqualObjects(user.name, @"Diego Chohfi", @"Should have same user name");
    XCTAssertEqualObjects(user.screenName, @"dchohfi", @"Should have same user screenName");
    XCTAssertEqualObjects(user.location, @"São Paulo", @"Should have same user location");
    XCTAssertEqualObjects(user.description, @"Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.", @"Should have same user description");
    XCTAssertEqualObjects(user.url, [NSURL URLWithString:@"http://about.me/dchohfi"], @"Should have same user url");
    XCTAssertFalse(user.protected, @"User should be protected");
    XCTAssertEqual(user.followersCount, (long)380, @"Should have 380 followersCount");
    XCTAssertEqual(user.friendsCount, (long)183, @"Should have 183 friendsCount");
    XCTAssertEqualObjects(user.createdAt, data, @"Should have same createdAt date");
}

- (void) testValidJsonToArrayOfTweets{
    Class tweetClass = [Tweet class];
    
    NSArray *arrayTweets = [NSArray arrayWithObjects:json, json, json, nil];
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    configuration.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:tweetClass andConfiguration:configuration];
    NSArray *parsedArray = [parser parseArray:arrayTweets];
    
    XCTAssertEqual((int)[parsedArray count], 3, @"Should have same size of tweets");
    XCTAssertTrue([parsedArray isKindOfClass:[NSArray class]], @"Should be a NSArray");
    XCTAssertFalse([parsedArray isKindOfClass:[NSMutableArray class]], @"Should not be a NSMutableArray");
    
    [parsedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(tweetClass, [obj class], @"Should be a Tweet");
    }];
}

- (void) testValidJsonToUserWithMultipleTweetsAsProperty{
    Class tweetClass = [Tweet class];
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"user"]];
    
    NSArray *tweetsForUser = [NSArray arrayWithObjects:json, json, nil];
    [userDictionary setObject:tweetsForUser forKey:@"tweets"];
    
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    configuration.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
    
    [configuration addArrayMapper:[DCArrayMapping mapperForClassElements:[Tweet class]
                                                            forAttribute:@"tweets"
                                                                 onClass:[User class]]];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class]
                                                             andConfiguration:configuration];
    User *user = [parser parseDictionary:userDictionary];
    XCTAssertEqual((int)[user.tweets count], 2, @"Should have same Tweets array size");
    
    [user.tweets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XCTAssertEqual(tweetClass, [obj class], @"Should be a Tweet");
        Tweet *tweet = (Tweet *) obj;
        XCTAssertNotNil(tweet.user, @"Should contain user on Tweet");
    }];
}

- (void) testObjectMappingForNameAttribute {
    NSMutableDictionary *userDictionary = [NSMutableDictionary dictionaryWithDictionary:[json objectForKey:@"user"]];
    NSString *name = [userDictionary objectForKey:@"name"];
    
    [userDictionary removeObjectForKey:@"name"];
    [userDictionary setObject:name forKey:@"borba"];
    
    DCObjectMapping *mapping = [DCObjectMapping mapKeyPath:@"borba" toAttribute:@"name" onClass:[User class]];
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addObjectMapping:mapping];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class] andConfiguration:configuration];
    
    User *user = [parser parseDictionary:userDictionary];
    XCTAssertEqualObjects(name, user.name, @"Should be able to use value on borba key and set it to user name property");
    
}

- (void) testNullValuesPassed
{
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Person class]];
    Person *person = [parser parseDictionary:nil];
    XCTAssertNil(person, @"Should be nill when dictionary is nil");
    
    NSArray *persons = [parser parseArray:nil];
    XCTAssertNil(persons, @"Should be nill when array is nil");
    
    parser = [DCKeyValueObjectMapping mapperForClass:nil];
    person = [parser parseDictionary:[NSDictionary dictionary]];
    XCTAssertNil(person, @"Should be nill when class is nil");
    
    persons = [parser parseArray:[NSArray array]];
    XCTAssertNotNil(persons, @"Should not be when class is nil");
    XCTAssertEqual((int)[persons count], 0, @"Should return empty array when class is nil");
}

-(void) testShouldUseCustomInitializeForPropertyClasses {
    NSString *customText = @"custom text to be on attribute";
    DCCustomInitializeBlock block = ^id(__weak Class classToGenerate, __weak NSDictionary *values, id parentObject){
        XCTAssertEqual(classToGenerate, [User class], @"classToGenerate should be a user");
        XCTAssertEqualObjects([values objectForKey:@"name"], @"Diego Chohfi", @"Should have same user name");
        User *user = [[classToGenerate alloc] init];
        user.customText = customText;
        return user;
    };
    DCCustomInitialize *customInitialize = [[DCCustomInitialize alloc] initWithBlockInitialize:block
                                                                                      forClass:[User class]];
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addCustomInitializersObject:customInitialize];
    
    DCKeyValueObjectMapping * parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:config];
    
    Tweet *tweet = [parser parseDictionary:json];
    User *user = tweet.user;
    XCTAssertEqualObjects(customText, user.customText, @"should be equals to customText");
}

- (void) testShouldUseBlocksToParseValues {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    DCCustomParserBlock parserBlock = ^id(NSDictionary *dictionary, NSString *__weak attributeName, __weak Class destinationClass, __weak id value) {
        XCTAssertTrue([@"08/12/1987" isEqualToString:value], @"The value inside the block should be equals to the value on the source");
        XCTAssertTrue([@"data" isEqualToString:attributeName], @"The attribute should be the same that is mapped for");
        XCTAssertEqual(destinationClass, [Tweet class], @"The destionation class should be the same that is mapped for");
        return [dateFormatter dateFromString:value];
    };
    DCCustomParser *customParser = [[DCCustomParser alloc] initWithBlockParser:parserBlock
                                                              forAttributeName:@"data"
                                                            onDestinationClass:[Tweet class]];
    
    DCParserConfiguration *config = [DCParserConfiguration configuration];
    [config addCustomParsersObject:customParser];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class]
                                                             andConfiguration:config];
    
    Tweet *tweet = [parser parseDictionary:json];
    XCTAssertTrue([tweet.data isEqualToDate:[dateFormatter dateFromString:@"08/12/1987"]], @"test");
}

-(void) testCustomMap {
    NSMutableDictionary *tweet1 = [NSMutableDictionary dictionary];
    [tweet1 setValue:@"First Value" forKey:@"property"];
    [tweet1 setValue:@"Frist Tweet" forKey:@"text"];
    
    NSMutableDictionary *tweet2 = [NSMutableDictionary dictionary];
    [tweet2 setValue:@"Second Value" forKey:@"title"];
    [tweet2 setValue:@"Second Tweet" forKey:@"text"];
    
    NSMutableDictionary *userValues = [NSMutableDictionary dictionary];
    [userValues setValue:@"Diego" forKey:@"name"];
    [userValues setValue:[NSArray arrayWithObjects:tweet1, tweet2, nil] forKey:@"tweets"];
    
    
    DCArrayMapping *arrayMapper = [DCArrayMapping mapperForClassElements:[Tweet class]
                                                            forAttribute:@"tweets"
                                                                 onClass:[User class]];
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    [configuration addArrayMapper:arrayMapper];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[User class]
                                                             andConfiguration:configuration];
    
    User *user = [parser parseDictionary:userValues];
    XCTAssertEqualObjects(@"Diego", [user name], @"");
    XCTAssertEqual(2, (int)[user.tweets count], @"Should have two tweet");
}

- (void)testNestedProperties{
    NSDictionary *source = @{@"idStr" : @"12345" , @"tweet" : @{@"text" : @"Some text"}};
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    
    DCObjectMapping *nestedMapping = [DCObjectMapping mapKeyPath:@"tweet.text" toAttribute:@"text" onClass:[Tweet class]];
    [configuration addObjectMapping:nestedMapping];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:configuration];
    Tweet *tweet = [parser parseDictionary:source];
    XCTAssertEqualObjects(tweet.idStr, @"12345", @"wrong id string");
    XCTAssertEqualObjects(tweet.text, @"Some text", @"wrong text string");
}

- (void)testDeeplyNestedProperties{
    NSDictionary *source = @{@"idStr" : @"12345" , @"tweet" : @{@"key1" : @{@"key2" : @{@"text" : @"Some text"}}}};
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    
    DCObjectMapping *nestedMapping = [DCObjectMapping mapKeyPath:@"tweet.key1.key2.text" toAttribute:@"text" onClass:[Tweet class]];
    [configuration addObjectMapping:nestedMapping];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:configuration];
    Tweet *tweet = [parser parseDictionary:source];
    XCTAssertEqualObjects(tweet.idStr, @"12345", @"wrong id string");
    XCTAssertEqualObjects(tweet.text, @"Some text", @"wrong text string");
}

- (void)testObjectUpdateWithDictionary{
    NSDictionary *source = @{@"idStr" : @"12345", @"text" : @"Text 1"};
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class]];
    Tweet *tweet = [parser parseDictionary:source];
    
    NSDictionary *newSource = @{@"idStr" : @"67890", @"text" : @"New Text"};
    
    [parser updateObject:tweet withDictionary:newSource];
    
    XCTAssertEqualObjects(tweet.idStr, @"67890", @"wrong id string");
    XCTAssertEqualObjects(tweet.text, @"New Text", @"wrong text string");
}

- (void)textObjectUpdateWithNestedDictionary{
    NSDictionary *source = @{@"idStr" : @"12345", @"tweet" : @{@"text" : @"Text 1"}};
    
    DCParserConfiguration *configuration = [DCParserConfiguration configuration];
    
    DCObjectMapping *nestedMapping = [DCObjectMapping mapKeyPath:@"tweet.text" toAttribute:@"text" onClass:[Tweet class]];
    [configuration addObjectMapping:nestedMapping];
    
    DCKeyValueObjectMapping *parser = [DCKeyValueObjectMapping mapperForClass:[Tweet class] andConfiguration:configuration];
    Tweet *tweet = [parser parseDictionary:source];
    
    NSDictionary *newSource = @{@"idStr" : @"67890", @"tweet" : @{@"text" : @"New Text"}};
    
    [parser updateObject:tweet withDictionary:newSource];
    
    XCTAssertEqualObjects(tweet.idStr, @"67890", @"wrong id string");
    XCTAssertEqualObjects(tweet.text, @"New Text", @"wrong text string");
}
@end
