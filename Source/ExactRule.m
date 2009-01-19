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

#pragma mark NSCoding protocol

- (id)initWithCoder:(NSCoder *)decoder
{
	return [self initWithSensor:[decoder decodeObjectForKey:@"Sensor"]
			      value:[decoder decodeObjectForKey:@"Value"]];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
	[encoder encodeObject:sensor_ forKey:@"Sensor"];
	[encoder encodeObject:value_ forKey:@"Value"];
}

#pragma mark Rule protocol

- (BOOL)matches:(ValueSet *)valueSet
{
	return [[valueSet valuesForSensor:sensor_] containsObject:value_];
}

@end
