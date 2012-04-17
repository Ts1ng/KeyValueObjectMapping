Introduction
=========================

KeyValueObjectMapping is a framework that provides an easy way to deal with any key/value type, as JSON, plist and even a common NSDictionary.

It's made to be used with NSJSONSerialization and other resources, and the main goal is to avoid the tedious work when you need to deal with key/value types.

Usage
-------------------------

KeyValueObjectMapping is a simple object, all you need to do is create a new object and start to transform a dictionary to any classes.

Let's assume that you have some JSON like that:
<pre>
{
	"id_str": "27924446",
	"name": "Diego Chohfi",
	"screen_name": "dchohfi",
	"location": "São Paulo",
	"description": "Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.",
	"url": "http://about.me/dchohfi",
	"protected": false,
	"created_at": "Tue Mar 31 18:01:12 +0000 2009"
}
</pre>

And your User model looks like:
<pre>
#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) BOOL protected;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSDate *createdAt;
@end
</pre>

Using any JSON parser you need to transform this NSString to a NSDictionary representation:
<pre>
NSError *error;
NSDictionary *jsonParsed = [NSJSONSerialization JSONObjectWithData:jsonData
	                              options:NSJSONReadingMutableContainers 
																error:&error];
</pre>

If you don't use KeyValueObjectMapping you need to create an instance of User type, and set all the properties with the same key name on the dictionary. And transform it when needed.

<pre>
User *user = [[User alloc] init];
[user setIdStr: [jsonParsed objectForKey: @"id_str"]];
[user setName: [jsonParsed objectForKey: @"name"]];
[user setScreenName: [jsonParsed objectForKey: @"screen_name"]];

NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
formatter.dateFormat = @"eee MMM dd HH:mm:ss ZZZZ yyyy";
NSDate *date = [formatter dateFromString:@"Sat Apr 14 00:20:07 +0000 2012"];

[user setCreatedAt: date];
</pre>

Boring job, don't you think? So, if you use KeyValueObjectMapping you just need to give the dictionary and the class that you want to create, and everthing else will be made automatically. And you can configure the parser to behave like you want, giving some pattern for NSDate parser, the character that separate the keys (on example we have used an '_' character, which is the default), and so on.

<pre>
ParserConfiguration *config = [[ParserConfiguration alloc] init];
config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

KeyValueObjectMapping * parser = [[KeyValueObjectMapping alloc] initWithConfiguration:config];

Tweet *tweet = [parser parseDictionary:jsonParsed forClass:[Tweet class]];
NSLog(@"%@ - %@", tweet.idStr, tweet.name);
</pre>

Pretty easy, hã?

Parsing NSArray properties
-------------------------

Since Objective-C don't support typed collections like Java and other static language we can't figure out what it the type of elements inside a collection. 
But KeyValueObjectMapping can be configured to learn what is the type of elements that will be added to the collection on the specific attribute for the class.

So, if the model User have many Tweets:
<pre>
#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *screenName;
@property(nonatomic, strong) NSString *location;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSURL *url;
@property(nonatomic, strong) BOOL protected;
@property(nonatomic, strong) NSNumber *followersCount;
@property(nonatomic, strong) NSDate *createdAt;

@property(nonatomic, strong) NSArray *tweets;

@end
</pre>

The Tweet looks like:
<pre>
#import <Foundation/Foundation.h>

@interface Tweet : NSObject
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSDate *createdAt;

@end
</pre>

And the JSON looks like:
<pre>
{
    "id_str": "27924446",
    "name": "Diego Chohfi",
    "screen_name": "dchohfi",
    "location": "São Paulo",
    "description": "Instrutor na @Caelum, desenvolvedor de coração, apaixonado por música e cerveja, sempre cerveja.",
    "url": "http://about.me/dchohfi",
    "protected": false,
    "created_at": "Tue Mar 31 18:01:12 +0000 2009",
		"tweets" : [
			{
				"created_at" : "Sat Apr 14 00:20:07 +0000 2012",
				"id_str" : 190957570511478784,
				"text" : "Tweet text"
			},
			{
				"created_at" : "Sat Apr 14 00:20:07 +0000 2012",
				"id_str" : 190957570511478784,
				"text" : "Tweet text"
			}
		]
}
</pre>

Using DCObjectMappingForArray and adding it to the configuration, you tell to the KeyValueObjectMapping how to parse this specific attribute.

<pre>
DCObjectMappingForArray *mapper = [[DCObjectMappingForArray alloc] initWithClassForElements:[Tweet class] forKeyAndAttributeName:@"tweets"] inClass:[User class]];
											
DCParserConfiguration *config = [[DCParserConfiguration alloc] init];
[config addMapper:mapper];
config.datePattern = @"eee MMM dd HH:mm:ss ZZZZ yyyy";

DCKeyValueObjectMapping *parser = [[DCKeyValueObjectMapping alloc] initWithConfiguration:configuration];
User *user = [parser parseDictionary:jsonParsed forClass:[User class]];
</pre>