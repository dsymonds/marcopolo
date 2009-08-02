//
//  CrashSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import "CrashSensor.h"


@interface CrashSensor (Private)

- (void)crash:(NSTimer *)timer;

@end

#pragma mark -

@implementation CrashSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	timer_ = nil;

	return self;
}

- (void)dealloc
{
	[timer_ invalidate];
	[timer_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"Crash";
}

- (BOOL)isMultiValued
{
	return NO;
}

- (void)start
{
	timer_ = [[NSTimer scheduledTimerWithTimeInterval:3.0
						   target:self
						 selector:@selector(crash:)
						 userInfo:nil
						  repeats:NO] retain];

	[NSTimer scheduledTimerWithTimeInterval:0.1
					 target:self
				       selector:@selector(update:)
				       userInfo:nil
					repeats:YES];
}

- (void)stop
{
	[timer_ invalidate];
	[timer_ release];
	timer_ = nil;
}

- (BOOL)running
{
	return timer_ != nil;
}

- (NSObject *)value
{
	if (![timer_ isValid])
		return nil;

	NSTimeInterval t = [[timer_ fireDate] timeIntervalSinceNow];
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithDouble:t], @"data",
		[NSString stringWithFormat:@"%.1f s", t], @"description", nil];
}

- (void)crash:(NSTimer *)timer
{
	// TODO: Actually crash, not just exit.
	exit(1);
}

- (void)update:(NSTimer *)timer
{
	[self willChangeValueForKey:@"value"];
	[self didChangeValueForKey:@"value"];
}

@end
