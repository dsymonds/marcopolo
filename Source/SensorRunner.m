//
//  SensorRunner.m
//  MarcoPolo
//
//  Created by David Symonds on 15/02/09.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"
#import "SensorController.h"
#import "SensorRunnerMonitor.h"


int main(int argc, char *argv[])
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// First argument should be the path to the bundle.
	if (argc != 2) {
		NSLog(@"Missing first arg!");
		return 1;
	}
	NSString *bundlePath = [NSString stringWithUTF8String:argv[1]];

	// Load sensor
	NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
	if (!bundle) {
		NSLog(@"Did not find a bundle at %@", bundlePath);
		return 1;
	}
	SensorController *sc = [SensorController sensorControllerWithSensorInBundle:bundle];
	if (!sc) {
		NSLog(@"Failed loading sensor from %@", bundlePath);
		return 1;
	}

	SensorRunnerMonitor *mon = [SensorRunnerMonitor monitorWithSensorController:sc];
	[mon setInput:[NSFileHandle fileHandleWithStandardInput]];

	// Main run loop. Runs until the monitor says we're done (probably stdin EOF),
	// checking every 0.5 seconds.
	NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
	while (![mon finished]) {
		[runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
	}

	[pool release];
	return 0;
}
