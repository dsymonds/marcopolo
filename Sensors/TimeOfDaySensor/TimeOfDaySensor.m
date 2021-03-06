//
//  TimeOfDaySensor.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "TimeOfDaySensor.h"


@interface TimeOfDaySensor (Private)

- (void)tick:(NSTimer *)timer;

@end

@implementation TimeOfDaySensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	timer_ = nil;
	value_ = nil;

	return self;
}

- (void)dealloc
{
	[timer_ release];
	[value_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"TimeOfDay";
}

- (BOOL)isMultiValued
{
	return NO;
}

- (void)start
{
	[self tick:nil];
}

- (void)stop
{
	[timer_ invalidate];
	[timer_ release];
	timer_ = nil;

	[self willChangeValueForKey:@"value"];
	[value_ autorelease];
	value_ = nil;
	[self didChangeValueForKey:@"value"];
}

- (BOOL)running
{
	return timer_ != nil;
}

- (void)tick:(NSTimer *)timer
{
	[self willChangeValueForKey:@"value"];
	[value_ autorelease];
	value_ = [[NSCalendarDate alloc] init];
	[self didChangeValueForKey:@"value"];

	// Schedule the timer for one second after the next whole minute.
	[timer_ autorelease];
	NSTimeInterval intv = 61 - [value_ secondOfMinute];
	timer_ = [[NSTimer scheduledTimerWithTimeInterval:intv
						   target:self
						 selector:@selector(tick:)
						 userInfo:nil
						  repeats:NO] retain];
}

- (NSObject *)value
{
	if (!value_)
		return nil;

	// Ignore seconds
	NSDate *date = [value_ dateByAddingYears:0 months:0 days:0
					   hours:0 minutes:0 seconds:-[value_ secondOfMinute]];
	return [NSDictionary dictionaryWithObjectsAndKeys:
		date, @"data",
		[date description], @"description", nil];
}

@end
