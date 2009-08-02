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

	crashTimer_ = updateTimer_ = nil;

	return self;
}

- (void)dealloc
{
	[crashTimer_ invalidate];
	[updateTimer_ invalidate];
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
	crashTimer_ = [NSTimer scheduledTimerWithTimeInterval:3.0
						       target:self
						     selector:@selector(crash:)
						     userInfo:nil
						      repeats:NO];
	updateTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.1
							target:self
						      selector:@selector(update:)
						      userInfo:nil
						       repeats:YES];
}

- (void)stop
{
	[crashTimer_ invalidate];
	[updateTimer_ invalidate];
	crashTimer_ = updateTimer_ = nil;
}

- (BOOL)running
{
	return crashTimer_ != nil;
}

- (NSObject *)value
{
	if (![crashTimer_ isValid])
		return nil;

	NSTimeInterval t = [[crashTimer_ fireDate] timeIntervalSinceNow];
	return [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithDouble:t], @"data",
		[NSString stringWithFormat:@"%.1f s", t], @"description", nil];
}

- (void)crash:(NSTimer *)timer
{
	// TODO: Actually crash, don't just exit.
	exit(1);
}

- (void)update:(NSTimer *)timer
{
	[self willChangeValueForKey:@"value"];
	[self didChangeValueForKey:@"value"];
}

@end
