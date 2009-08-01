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
	started_ = NO;
	value_ = nil;

	// Find the sensor runner
	NSString *sensorRunnerPath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:@"SensorRunner"];
	if (!sensorRunnerPath) {
		NSLog(@"Argh! Couldn't find SensorRunner!");
		return nil;
	}

	// Start sensor in a separate task
	task_ = [[NSTask alloc] init];
	[task_ setLaunchPath:sensorRunnerPath];
	[task_ setArguments:[NSArray arrayWithObject:[bundle bundlePath]]];
	[task_ setStandardInput:[NSPipe pipe]];
	[task_ setStandardOutput:[NSPipe pipe]];

	endpoint_ = [[SensorProtocolEndpoint alloc] init];
	[endpoint_ setInputProcessor:self selector:@selector(processInput:meta:)];
	[endpoint_ setInput:[[task_ standardOutput] fileHandleForReading]];
	[endpoint_ setOutput:[[task_ standardInput] fileHandleForWriting]];

	[task_ launch];

	return self;
}

- (void)dealloc
{
	// TODO: terminate task gracefully?
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

- (BOOL)started
{
	return started_;
}

- (void)setStarted:(BOOL)start
{
	[endpoint_ writeLine:start ? @"START" : @"STOP"];
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
			[self willChangeValueForKey:@"started"];
			started_ = started;
			[self didChangeValueForKey:@"started"];
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

@end
