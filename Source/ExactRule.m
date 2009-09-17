//
//  ExactRule.m
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import "ExactRule.h"
#import "ValueSet.h"


@implementation ExactRule

+ (id)exactRuleWithSensor:(NSString *)sensor value:(NSObject *)value
{
	return [[[self alloc] initWithSensor:sensor value:value] autorelease];
}

- (id)initWithSensor:(NSString *)sensor value:(NSObject *)value
{
	if (!(self = [super init]))
		return nil;

	sensor_ = [sensor retain];
	value_ = [value retain];

	return self;
}

#pragma mark Rule protocol

- (NSObject *)definition
{
	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"Exact", @"type",
		sensor_, @"sensor",
		value_, @"value", nil];
}

- (BOOL)matches:(ValueSet *)valueSet
{
	return [[valueSet valuesForSensor:sensor_] containsObject:value_];
}

@end
