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

- (NSString *)name
{
	return @"Crash";
}

- (BOOL)isMultiValued
{
	return NO;
}

- (BOOL)start
{
	timer_ = [[NSTimer scheduledTimerWithTimeInterval:3.0
						   target:self
						 selector:@selector(crash:)
						 userInfo:nil
						  repeats:NO] retain];
	return YES;
}

- (BOOL)stop
{
	[timer_ invalidate];
	[timer_ release];
	timer_ = nil;
	return YES;
}

- (NSObject *)value
{
	return nil;
}

- (void)crash:(NSTimer *)timer
{
	// TODO: Actually crash, not just exit.
	exit(1);
}

@end
