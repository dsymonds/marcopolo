//
//  SensorStub.m
//  MarcoPolo
//
//  Created by David Symonds on 13/03/09.
//

#import "SensorLoader.h"
#import "SensorStub.h"


@interface SensorStub (Private)

- (void)processInput:(NSObject *)object meta:(BOOL)meta;

@end

#pragma mark -

@implementation SensorStub

+ (void)initialize
{
	[self setKeys:[NSArray arrayWithObject:@"value"] triggerChangeNotificationsForDependentKey:@"valueSummary"];
}

+ (id)sensorStubWithSensorInBundle:(NSBundle *)bundle
{
	return [[[self alloc] initWithSensorInBundle:bundle] autorelease];
}

- (id)initWithSensorInBundle:(NSBundle *)bundle
{
	if (!(self = [super init]))
		return nil;

	sensor_ = [[SensorLoader sensorFromBundle:bundle] retain];
	running_ = NO;
	value_ = nil;

	// Find the sensor runner
	sensorRunnerPath_ = [[[NSBundle mainBundle] pathForAuxiliaryExecutable:@"SensorRunner"] copy];
	if (!sensorRunnerPath_) {
		NSLog(@"Argh! Couldn't find SensorRunner!");
		return nil;
	}
	bundlePath_ = [[bundle bundlePath] copy];

	return self;
}

- (void)dealloc
{
	if (task_)
		[self stop];

	[sensor_ release];
	[sensorRunnerPath_ release];
	[bundlePath_ release];
	[value_ release];
	[super dealloc];
}

#pragma mark -

- (NSString *)name
{
	return [sensor_ name];
}

- (BOOL)isMultiValued
{
	return [sensor_ isMultiValued];
}

- (void)start
{
	if (task_)
		return;

	// Start sensor in a separate task
	task_ = [[NSTask alloc] init];
	[task_ setLaunchPath:sensorRunnerPath_];
	[task_ setArguments:[NSArray arrayWithObject:bundlePath_]];
	[task_ setStandardInput:[NSPipe pipe]];
	[task_ setStandardOutput:[NSPipe pipe]];

	endpoint_ = [[SensorProtocolEndpoint alloc] init];
	[endpoint_ setInputProcessor:self selector:@selector(processInput:meta:)];
	[endpoint_ setInput:[[task_ standardOutput] fileHandleForReading]];
	[endpoint_ setOutput:[[task_ standardInput] fileHandleForWriting]];

	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(sensorDied:)
						     name:NSTaskDidTerminateNotification
						   object:task_];
	[task_ launch];

	[endpoint_ writeLine:@"START"];
}

- (void)stop
{
	if (!task_)
		return;

	[[NSNotificationCenter defaultCenter] removeObserver:self
							name:NSTaskDidTerminateNotification
						      object:task_];

	[endpoint_ writeLine:@"STOP"];

	[task_ terminate];
	[task_ release];
	[endpoint_ release];
	task_ = nil;
	endpoint_ = nil;

	[self willChangeValueForKey:@"running"];
	running_ = NO;
	[self didChangeValueForKey:@"running"];

	[self willChangeValueForKey:@"value"];
	[value_ autorelease];
	value_ = nil;
	[self didChangeValueForKey:@"value"];
}

- (BOOL)running
{
	return running_;
}

- (NSObject *)value
{
	return value_;
}

- (NSObject *)valueSummary
{
	// TODO
	return @"NYI";
}

#pragma mark -

- (void)processInput:(NSObject *)object meta:(BOOL)meta
{
	if (meta) {
		NSString *line = (NSString *) object;
		BOOL started = [line isEqualToString:@"STARTED"];
		BOOL stopped = [line isEqualToString:@"STOPPED"];
		if (started || stopped) {
			[self willChangeValueForKey:@"running"];
			running_ = started;
			[self didChangeValueForKey:@"running"];
			if (stopped)
				[self processInput:nil meta:NO];
		}
	} else {
		[self willChangeValueForKey:@"value"];
		[value_ autorelease];
		value_ = [object retain];
		[self didChangeValueForKey:@"value"];
	}
}

- (void)sensorDied:(id)dummy
{
	NSLog(@"oh NOES!");
	[task_ autorelease];
	task_ = nil;
	[self processInput:@"STOPPED" meta:YES];

	// TODO: Consider restarting the task here.
}

@end
