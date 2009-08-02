//
//  WiFiSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import "WiFiSensor.h"


@implementation WiFiSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	// TODO

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)name
{
	return @"WiFi";
}

- (BOOL)isMultiValued
{
	return YES;
}

- (void)start
{
	// TODO
}

- (void)stop
{
	// TODO
}

- (BOOL)running
{
	// TODO
	return NO;
}

- (NSObject *)value
{
	// TODO
	return nil;
}

@end
