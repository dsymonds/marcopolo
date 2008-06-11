//
//  SensorData.m
//  MarcoPolo
//
//  Created by David Symonds on 11/06/08.
//

#import "SensorData.h"


@implementation SensorData

+ (id)sensorDataWithType:(NSString *)type value:(id)value
{
	return [[[self alloc] initWithType:type value:value] autorelease];
}

- (id)initWithType:(NSString *)type value:(id)value
{
	if (!(self = [super init]))
		return nil;

	type_ = [type retain];
	value_ = [value retain];

	return self;
}

- (void)dealloc
{
	[type_ release];
	[value_ release];
	[super dealloc];
}

- (NSString *)type
{
	return type_;
}

- (id)value
{
	return value_;
}

@end
