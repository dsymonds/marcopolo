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
	NSString *sensorRunnerPath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"SensorRunner"];
	if (!sensorRunnerPath) {
		NSLog(@"Argh! Couldn't find SensorRunner!");
		return nil;
	}

	// Start sensor in a separate task
	// TODO: Move this to -start
	task_ = [[NSTask alloc] init];
	[task_ setLaunchPath:sensorRunnerPath];
	[task_ setArguments:[NSArray arrayWithObject:[bundle bundlePath]]];
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

	return self;
}

- (void)dealloc
{
	// TODO: terminate task gracefully?
	[[NSNotificationCenter defaultCenter] removeObserver:self
							name:NSTaskDidTerminateNotification
						      object:task_];
	[task_ terminate];
	[task_ release];

	[sensor_ release];
	[endpoint_ release];
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
	[endpoint_ writeLine:@"START"];
}

- (void)stop
{
	[endpoint_ writeLine:@"STOP"];
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
	[self processInput:@"STOPPED" meta:YES];

	// TODO: move task launch/termination into -start and -stop,
	// and then we can consider restarting the task here.
}

@end
