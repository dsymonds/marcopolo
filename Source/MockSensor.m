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
	if (!multi_) {
		return [NSNumber numberWithInt:value_];
	} else {
		NSMutableArray *v = [NSMutableArray arrayWithCapacity:3];
		int i;
		for (i = 0; i < 3; ++i)
			[v addObject:[NSNumber numberWithInt:(value_ + i) % MOCK_VALUE_CYCLE_LEN]];
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
