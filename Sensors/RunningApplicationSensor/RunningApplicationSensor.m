//
//  RunningApplicationSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 1/08/09.
//

#import "RunningApplicationSensor.h"


@interface RunningApplicationSensor (Private)

- (void)update;
- (void)setApps:(NSArray *)apps;

@end

#pragma mark -

@implementation RunningApplicationSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	lock_ = [[NSLock alloc] init];
	apps_ = [[NSMutableArray alloc] init];

	return self;
}

- (void)dealloc
{
	[lock_ release];
	[apps_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"RunningApplication";
}

- (BOOL)isMultiValued
{
	return YES;
}

- (void)start
{
	[[[NSWorkspace sharedWorkspace] notificationCenter]
	 addObserver:self
	 selector:@selector(update)
	 name:NSWorkspaceDidLaunchApplicationNotification
	 object:nil];
	[[[NSWorkspace sharedWorkspace] notificationCenter]
	 addObserver:self
	 selector:@selector(update)
	 name:NSWorkspaceDidTerminateApplicationNotification
	 object:nil];
	running_ = YES;

	[self update];
}

- (void)stop
{
	[[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self
								      name:nil
								    object:nil];
	running_ = NO;

	[self willChangeValueForKey:@"value"];
	[self setApps:[NSArray array]];
	[self didChangeValueForKey:@"value"];
}

- (BOOL)running
{
	return running_;
}

- (NSObject *)value
{
	[lock_ lock];

	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[apps_ count]];
	NSEnumerator *en = [apps_ objectEnumerator];
	NSDictionary *app;
	while ((app = [en nextObject])) {
		[array addObject:app];
	}

	[lock_ unlock];

	return array;
}

- (void)update
{
	NSArray *runningApps = [[NSWorkspace sharedWorkspace] launchedApplications];
	NSMutableArray *apps = [[NSMutableArray alloc] initWithCapacity:[runningApps count]];
	NSEnumerator *en = [runningApps objectEnumerator];
	NSDictionary *dict;
	while ((dict = [en nextObject])) {
		NSString *ident = [dict valueForKey:@"NSApplicationBundleIdentifier"];
		NSString *desc = [NSString stringWithFormat:@"%@ (%@)",
				  [dict valueForKey:@"NSApplicationName"], ident];
		[apps addObject:[NSDictionary dictionaryWithObjectsAndKeys:
				 ident, @"data", desc, @"description", nil]];
	}

	[self setApps:apps];
}

- (void)setApps:(NSArray *)apps
{
	[self willChangeValueForKey:@"value"];
	[lock_ lock];
	[apps_ setArray:apps];
	[lock_ unlock];
	[self didChangeValueForKey:@"value"];
}

@end
