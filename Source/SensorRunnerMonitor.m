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
	inputPipe_ = [[NSPipe alloc] init];
	finished_ = NO;
	queuedData_ = [[NSMutableData alloc] init];

	[sensorController_ addObserver:self
			    forKeyPath:@"value"
			       options:nil
			       context:nil];

	return self;
}

- (void)dealloc {
	[sensorController_ removeObserver:self forKeyPath:@"value"];

	[sensorController_ release];
	[inputPipe_ release];
	[queuedData_ release];
	[super dealloc];
}

- (void)setInput:(NSFileHandle *)fileHandle
{
	[[NSNotificationCenter defaultCenter] addObserver:self
						 selector:@selector(handleMoreData:)
						     name:NSFileHandleDataAvailableNotification
						   object:fileHandle];
	[fileHandle waitForDataInBackgroundAndNotify];
}

- (BOOL)finished
{
	return finished_;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath
		      ofObject:(id)object
			change:(NSDictionary *)change
		       context:(void *)context
{
	if ([keyPath isEqualToString:@"value"]) {
		NSLog(@"Value changed!");
		// TODO: Report this!
	}
}

- (void)handleMoreData:(NSNotification *)notification
{
	NSFileHandle *fh = [notification object];
	NSData *data = [fh availableData];
	if ([data length] == 0) {
		NSLog(@"Reached EOF!");
		finished_ = YES;
		return;
	}
	[queuedData_ appendData:data];

	// Process lines
	while ([queuedData_ length] > 0) {
		NSString *str = [[[NSString alloc] initWithData:queuedData_
						       encoding:NSUTF8StringEncoding] autorelease];
		if (!str)
			break;
		unsigned nlIndex = [str rangeOfString:@"\n"].location;
		if (nlIndex != NSNotFound) {
			NSString *line = [str substringToIndex:nlIndex];
			[self processLine:line];
			str = [str substringFromIndex:nlIndex + 1];
			[queuedData_ setData:[str dataUsingEncoding:NSUTF8StringEncoding]];
		}
	}

	[fh waitForDataInBackgroundAndNotify];
}

#pragma mark -

- (void)processLine:(NSString *)line
{
	NSLog(@"Processing line: [%@]", line);
	if ([line isEqualToString:@"START"]) {
		[sensorController_ setStarted:YES];
	} else if ([line isEqualToString:@"STOP"]) {
		[sensorController_ setStarted:NO];
	}
}

@end
