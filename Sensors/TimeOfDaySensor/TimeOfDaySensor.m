//
//  TimeOfDaySensor.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "TimeOfDaySensor.h"


@implementation TimeOfDaySensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	return self;
}

- (void)dealloc
{
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

- (BOOL)start
{
	// TODO
	NSLog(@"TODO: -[%@ %s]", [self class], _cmd);
	return YES;
}

- (BOOL)stop
{
	// TODO
	NSLog(@"TODO: -[%@ %s]", [self class], _cmd);
	return YES;
}

@end
