//
//  ValueSet.m
//  MarcoPolo
//
//  Created by David Symonds on 1/07/08.
//

#import "ValueSet.h"


@implementation ValueSet

+ (id)valueSet
{
	return [[[self alloc] init] autorelease];
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	values_ = [[NSMutableDictionary alloc] init];

	return self;
}

- (void)dealloc
{
	[values_ release];
	[super dealloc];
}

- (NSArray *)valuesForSensor:(NSString *)sensorName
{
	NSArray *obj = (NSArray *) [values_ objectForKey:sensorName];
	if (obj)
		return obj;
	else
		return [NSArray array];
}

- (NSEnumerator *)valueEnumeratorForSensor:(NSString *)sensorName
{
	return [[self valuesForSensor:sensorName] objectEnumerator];
}

- (void)setValueForSensor:(NSString *)sensorName value:(NSObject *)value
{
	[self setValuesForSensor:sensorName
			  values:[NSArray arrayWithObject:value]];
}

- (void)setValuesForSensor:(NSString *)sensorName values:(NSArray *)values
{
	[values_ setValue:values forKey:sensorName];
}

@end
