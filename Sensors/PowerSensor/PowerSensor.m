//
//  PowerSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 19/06/08.
//

#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSkeys.h>
#import "PowerSensor.h"


#pragma mark -

@interface PowerSensor (Private)

- (void)update;

@end

#pragma mark -
#pragma mark C callback

static void sourceChange(void *info)
{
	PowerSensor *s = (PowerSensor *) info;

	[s update];
}

#pragma mark -

@implementation PowerSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	state_ = kUnknown;
	runLoopSource_ = nil;

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

- (NSString *)name
{
	return @"Power";
}

- (BOOL)isMultiValued
{
	return NO;
}

- (void)start
{
	// register for notifications
	runLoopSource_ = IOPSNotificationCreateRunLoopSource(sourceChange, self);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource_, kCFRunLoopDefaultMode);

	[self update];
}

- (void)stop
{
	// remove notification registration
	CFRunLoopRemoveSource(CFRunLoopGetCurrent(), runLoopSource_, kCFRunLoopDefaultMode);
	CFRelease(runLoopSource_);
	runLoopSource_ = nil;

	[self willChangeValueForKey:@"value"];
	state_ = kUnknown;
	[self didChangeValueForKey:@"value"];
}

- (BOOL)running
{
	return runLoopSource_ != nil;
}

- (NSObject *)value
{
	NSString *data, *desc;

	switch (state_) {
		case kUnknown:
			return nil;
		case kBattery:
			data = @"battery";
			desc = @"On Battery";
			break;
		case kAC:
			data = @"ac";
			desc = @"On A/C";
			break;
	}

	return [NSDictionary dictionaryWithObjectsAndKeys:
		data, @"data",
		desc, @"description", nil];
}

- (void)update
{
	CFTypeRef blob = IOPSCopyPowerSourcesInfo();
	NSArray *list = (NSArray *) IOPSCopyPowerSourcesList(blob);
	[list autorelease];

	BOOL onBattery = YES;
	NSEnumerator *en = [list objectEnumerator];
	CFTypeRef source;
	while ((source = [en nextObject])) {
		NSDictionary *dict = (NSDictionary *) IOPSGetPowerSourceDescription(blob, source);
		if ([[dict valueForKey:@kIOPSPowerSourceStateKey] isEqualToString:@kIOPSACPowerValue])
			onBattery = NO;
	}
	CFRelease(blob);

	[self willChangeValueForKey:@"value"];
	state_ = onBattery ? kBattery : kAC;
	[self didChangeValueForKey:@"value"];
}

@end
