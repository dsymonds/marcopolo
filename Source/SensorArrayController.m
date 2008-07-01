//
//  SensorArrayController.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "SensorArrayController.h"
#import "SensorController.h"
#import "ValueSet.h"


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
	[sc addObserver:self forKeyPath:@"value" options:0 context:nil];
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

- (ValueSet *)valueSet
{
	ValueSet *vs = [ValueSet valueSet];

	NSEnumerator *en = [[self arrangedObjects] objectEnumerator];
	NSObject<Sensor> *sensor;
	while ((sensor = [en nextObject])) {
		NSObject *value = [sensor value];
		if (!value)
			continue;
		if (![sensor isMultiValued])
			[vs setValueForSensor:[sensor name] value:value];
		else
			[vs setValuesForSensor:[sensor name] values:(NSArray *) value];
	}

	return vs;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
			change:(NSDictionary *)change context:(void *)context
{
	if ([object isKindOfClass:[SensorController class]] && [keyPath isEqualToString:@"value"]) {
		[self willChangeValueForKey:@"valueSet"];
		[self didChangeValueForKey:@"valueSet"];
	} else
		[super observeValueForKeyPath:keyPath ofObject:object
				       change:change context:context];
}

@end
