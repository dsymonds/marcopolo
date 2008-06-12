//
//  TimeOfDaySensor.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "TimeOfDaySensor.h"


@implementation TimeOfDaySensor

+ (NSString *)name
{
	return @"TimeOfDay";
}

+ (BOOL)isMultiValued
{
	return NO;
}

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

@end
