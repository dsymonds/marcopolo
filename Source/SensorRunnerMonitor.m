//
//  SensorRunnerMonitor.m
//  MarcoPolo
//
//  Created by David Symonds on 15/02/09.
//

#import "SensorController.h"
#import "SensorRunnerMonitor.h"


@interface SensorRunnerMonitor (Private)

- (void)processLine:(NSString *)line;

@end

#pragma mark -

@implementation SensorRunnerMonitor

+ (SensorRunnerMonitor *)monitorWithSensorController:(SensorController *)sensorController
{
	return [[[self alloc] initWithSensorController:sensorController] autorelease];
}

- (id)initWithSensorController:(SensorController *)sensorController
{
	if (!(self = [super init]))
		return nil;

	sensorController_ = [sensorController retain];
	endpoint_ = [[SensorProtocolEndpoint alloc] init];

	[sensorController_ addObserver:self
			    forKeyPath:@"started"
			       options:nil
			       context:nil];
	[sensorController_ addObserver:self
			    forKeyPath:@"value"
			       options:nil
			       context:nil];

	[endpoint_ setInputProcessor:self selector:@selector(processLine:)];
	[endpoint_ setInput:[NSFileHandle fileHandleWithStandardInput]];
	[endpoint_ setOutput:[NSFileHandle fileHandleWithStandardOutput]];

	return self;
}

- (void)dealloc {
	[sensorController_ removeObserver:self forKeyPath:@"started"];
	[sensorController_ removeObserver:self forKeyPath:@"value"];

	[sensorController_ release];
	[endpoint_ release];
	[super dealloc];
}

- (BOOL)finished
{
	return [endpoint_ closed];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
		      ofObject:(id)object
			change:(NSDictionary *)change
		       context:(void *)context
{
	if ([keyPath isEqualToString:@"started"]) {
		BOOL started = [sensorController_ started];
		[endpoint_ writeLine:started ? @"STARTED" : @"STOPPED"];
	}
	if ([keyPath isEqualToString:@"value"]) {
		NSLog(@"Value changed!");
		// TODO: Report this!
	}
}

#pragma mark -

- (void)processLine:(NSString *)line
{
	//NSLog(@"Processing line: [%@]", line);
	if ([line isEqualToString:@"START"]) {
		[sensorController_ setStarted:YES];
	} else if ([line isEqualToString:@"STOP"]) {
		[sensorController_ setStarted:NO];
	}
}

@end
