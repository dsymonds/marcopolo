//
//  SensorController.m
//  MarcoPolo
//
//  Created by David Symonds on 13/06/08.
//

#import "Sensor.h"
#import "SensorController.h"


@implementation SensorController

- (id)initWithSensor:(NSObject<Sensor> *)sensor
{
	if (!(self = [super init]))
		return nil;

	sensor_ = [sensor retain];

	[sensor_ addObserver:self forKeyPath:@"value" options:0 context:nil];

	return self;
}

- (void)dealloc
{
	[sensor_ release];
	[super dealloc];
}

- (NSString *)name
{
	return [sensor_ name];
}

- (BOOL)started
{
	return started_;
}

- (void)setStarted:(BOOL)start
{
	if (started_ == start)
		return;
	if (start) {
		// Attempt to start the sensor
		if ([sensor_ start])
			started_ = YES;
		else {
			NSLog(@"Failed to start sensor: %@", [sensor_ name]);
			[self setStarted:NO];  // ensure KVO
		}
	} else {
		// Attempt to stop the sensor
		if ([sensor_ stop])
			started_ = NO;
		else {
			NSLog(@"Failed to stop sensor: %@", [sensor_ name]);
			[self setStarted:YES];  // ensure KVO
		}
	}
}

- (NSObject *)value
{
	return [sensor_ value];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
			change:(NSDictionary *)change context:(void *)context
{
	if ((object == sensor_) && [keyPath isEqualToString:@"value"]) {
		[self willChangeValueForKey:@"value"];
		[self didChangeValueForKey:@"value"];
	} else
		[super observeValueForKeyPath:keyPath ofObject:object
				       change:change context:context];
}

@end
