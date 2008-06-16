//
//  MockSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 16/06/08.
//

#import "MockSensor.h"


#define MOCK_VALUE_CYCLE_LEN 5

@implementation MockSensor

#pragma mark -
#pragma mark Sensor protocol methods

- (id)init
{
	if (!(self = [super init]))
		return nil;

	multi_ = NO;
	started_ = NO;
	value_ = 0;

	return self;
}

- (NSString *)name
{
	return @"Mock";
}

- (BOOL)isMultiValued
{
	return multi_;
}

- (BOOL)start
{
	if (!started_) {
		started_ = YES;
		return YES;
	} else
		return NO;
}

- (BOOL)stop
{
	if (started_) {
		started_ = NO;
		return YES;
	} else
		return NO;
}

- (NSObject *)value
{
	if (!started_)
		return nil;

	if (!multi_) {
		return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:value_], @"data",
			[NSString stringWithFormat:@"<%d>", value_], @"description", nil];
	} else {
		NSMutableArray *v = [NSMutableArray arrayWithCapacity:3];
		int i;
		for (i = 0; i < 3; ++i) {
			NSNumber *d = [NSNumber numberWithInt:(value_ + i) % MOCK_VALUE_CYCLE_LEN];
			[v addObject:[NSDictionary dictionaryWithObjectsAndKeys:
				      d, @"data",
				      [NSString stringWithFormat:@"<%@>", d], @"description", nil]];
		}
		return v;
	}
}

#pragma mark -
#pragma mark Mock controls

- (void)setMulti:(BOOL)multi
{
	multi_ = multi;
}

- (void)changeValue
{
	[self willChangeValueForKey:@"value"];
	value_ = (value_ + 1) % MOCK_VALUE_CYCLE_LEN;
	[self didChangeValueForKey:@"value"];
}

@end
