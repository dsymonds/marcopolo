//
//  SensorArrayController.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "SensorArrayController.h"
#import "SensorController.h"


@implementation SensorArrayController

- (void)awakeFromNib
{
	[self loadSensors];
}

#pragma mark Sensor loading

- (void)loadSensorFromBundle:(NSBundle *)bundle
{
	Class sensorClass = [bundle principalClass];

	// Verify adherence to Sensor protocol
	if (![sensorClass conformsToProtocol:@protocol(Sensor)]) {
		NSLog(@"Class '%@' from bundle %@ doesn't conform to Sensor protocol",
		      sensorClass, [bundle bundlePath]);
		return;
	}
	NSArray *requiredInstanceMethods = [NSArray arrayWithObjects:
					    @"init", @"dealloc",
					    @"name",
					    @"isMultiValued",
					    @"start", @"stop",
					    nil];
	NSEnumerator *en = [requiredInstanceMethods objectEnumerator];
	NSString *method;
	while ((method = [en nextObject])) {
		SEL sel = NSSelectorFromString(method);
		if (![sensorClass instancesRespondToSelector:sel]) {
			NSLog(@"Class '%@' from bundle %@ doesn't implement instance method '%@'",
			      sensorClass, [bundle bundlePath], method);
			return;
		}
	}

	NSObject<Sensor> *sensor = [[[sensorClass alloc] init] autorelease];
	SensorController *sc = [[SensorController alloc] initWithSensor:sensor];
	[self addObject:sc];
}

- (void)loadSensorsInPath:(NSString *)path
{
	NSArray *contents = [[NSFileManager defaultManager] directoryContentsAtPath:path];
	NSEnumerator *en = [contents objectEnumerator];
	NSString *name;
	while ((name = [en nextObject])) {
		if ([name hasSuffix:@".sensor"]) {
			NSString *fullPath = [path stringByAppendingPathComponent:name];
			// TODO: we need to resolve symlinks
			[self loadSensorFromBundle:[NSBundle bundleWithPath:fullPath]];
		}
	}
}

- (void)loadSensors
{
	// TODO: Add other places to look for sensors
	NSArray *searchPaths = [NSArray arrayWithObject:
				[[NSBundle mainBundle] builtInPlugInsPath]];

	NSEnumerator *en = [searchPaths objectEnumerator];
	NSString *path;
	while ((path = [en nextObject]))
		[self loadSensorsInPath:path];
}

@end
