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

#pragma mark NSCoder protocol

- (id)initWithCoder:(NSCoder *)coder
{
	return [self initWithSensor:[coder decodeObjectForKey:@"Sensor"]
			      value:[coder decodeObjectForKey:@"Value"]];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:sensor_ forKey:@"Sensor"];
	[coder encodeObject:value_ forKey:@"Value"];
}

#pragma mark Rule protocol

- (BOOL)matches:(ValueSet *)valueSet
{
	return [[valueSet valuesForSensor:sensor_] containsObject:value_];
}

@end
