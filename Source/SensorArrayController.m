//
//  SensorArrayController.m
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import "SensorArrayController.h"
#import "SensorController.h"
#import "SensorLoader.h"
#import "SensorStub.h"
#import "ValueSet.h"


@implementation SensorArrayController

- (void)awakeFromNib
{
	[self loadSensors];
}

#pragma mark Sensor loading

- (void)loadSensorFromBundle:(NSBundle *)bundle
{
	SensorStub *s = [[SensorStub alloc] initWithSensorInBundle:bundle];
	SensorController *sc = [SensorController sensorControllerWithSensor:s];
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
			NSBundle *bundle = [NSBundle bundleWithPath:fullPath];
			if ([SensorLoader canLoadSensorFromBundle:bundle]) {
				[self loadSensorFromBundle:bundle];
			}
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
	SensorStub *s;
	while ((s = [en nextObject])) {
		NSObject *value = [s value];
		if (!value)
			continue;
		if (![s isMultiValued])
			[vs setValue:value forSensor:[s name]];
		else
			[vs setValues:(NSArray *) value forSensor:[s name]];
	}

	return vs;
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
			change:(NSDictionary *)change context:(void *)context
{
	if ([object isKindOfClass:[SensorStub class]] && [keyPath isEqualToString:@"value"]) {
		[self willChangeValueForKey:@"valueSet"];
		[self didChangeValueForKey:@"valueSet"];
	} else
		[super observeValueForKeyPath:keyPath ofObject:object
				       change:change context:context];
}

@end
