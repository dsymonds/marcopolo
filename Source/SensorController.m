//
//  SensorController.m
//  MarcoPolo
//
//  Created by David Symonds on 13/06/08.
//

#import "Sensor.h"
#import "SensorController.h"
#import "SensorLoader.h"


@interface SensorController (Private)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
			change:(NSDictionary *)change context:(void *)context;
- (BOOL)valueIsWellFormed:(NSObject *)value singleValue:(BOOL)singleValue;

@end

#pragma mark -

@implementation SensorController

+ (void)initialize
{
	[self setKeys:[NSArray arrayWithObject:@"value"] triggerChangeNotificationsForDependentKey:@"valueSummary"];
}

+ (id)sensorControllerWithSensor:(NSObject<Sensor> *)sensor
{
	return [[[self alloc] initWithSensor:sensor] autorelease];
}

+ (id)sensorControllerWithSensorInBundle:(NSBundle *)bundle
{
	return [[[self alloc] initWithSensorInBundle:bundle] autorelease];
}

- (id)initWithSensor:(NSObject<Sensor> *)sensor
{
	if (!sensor)
		return nil;
	if (!(self = [super init]))
		return nil;

	sensor_ = [sensor retain];

	[sensor_ addObserver:self forKeyPath:@"value" options:0 context:nil];
	[sensor_ addObserver:self forKeyPath:@"running" options:0 context:nil];

	return self;
}

- (id)initWithSensorInBundle:(NSBundle *)bundle
{
	return [self initWithSensor:[SensorLoader sensorFromBundle:bundle]];
}

- (void)dealloc
{
	[sensor_ removeObserver:self forKeyPath:@"value"];
	[sensor_ removeObserver:self forKeyPath:@"running"];

	[sensor_ release];
	[super dealloc];
}

- (NSString *)name
{
	return [sensor_ name];
}

- (BOOL)running
{
	return [sensor_ running];
}

- (void)setRunning:(BOOL)shouldRun
{
	if ([sensor_ running] == shouldRun)
		return;
	if (shouldRun) {
		[sensor_ start];
	} else {
		[sensor_ stop];
	}
}

- (NSObject *)value
{
	NSObject *v = [sensor_ value];

	// Check that the value is well-formed.
	if (!v || ![self valueIsWellFormed:v singleValue:![sensor_ isMultiValued]])
		return nil;

	return v;
}

- (NSObject *)valueSummary
{
	NSObject *v = [self value];
	if (!v)
		return nil;

	if (![sensor_ isMultiValued]) {
		return [(NSDictionary *) v valueForKey:@"description"];
	} else {
		NSArray *array = (NSArray *) v;
		if ([array count] == 1)
			return @"1 value";
		else
			return [NSString stringWithFormat:@"%d values", [array count]];
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
			change:(NSDictionary *)change context:(void *)context
{
	if ((object == sensor_) && [keyPath isEqualToString:@"value"]) {
		[self willChangeValueForKey:@"value"];
		[self didChangeValueForKey:@"value"];
	} else if ((object == sensor_) && [keyPath isEqualToString:@"running"]) {
		// Only valid for SensorStub.
		[self willChangeValueForKey:@"running"];
		[self didChangeValueForKey:@"running"];
	} else
		[super observeValueForKeyPath:keyPath ofObject:object
				       change:change context:context];
}

- (BOOL)valueIsWellFormed:(NSObject *)value singleValue:(BOOL)singleValue
{
	if (!singleValue) {
		if (![value isKindOfClass:[NSArray class]]) {
			NSLog(@"Sensor %@ returned a %@ as a value; expected an NSArray",
			      [sensor_ name], [value class]);
			return NO;
		}
		NSEnumerator *en = [(NSArray *) value objectEnumerator];
		NSObject *elt;
		while ((elt = [en nextObject]))
			if (![self valueIsWellFormed:elt singleValue:YES])
				return NO;
		return YES;
	}

	// Should be an NSDictionary with keys: data, description
	if (![value isKindOfClass:[NSDictionary class]]) {
		NSLog(@"Sensor %@ returned a %@ as a value; expected an NSDictionary",
		      [sensor_ name], [value class]);
		return NO;
	}
	NSDictionary *dict = (NSDictionary *) value;
	if (![dict objectForKey:@"data"] || ![dict objectForKey:@"description"]) {
		NSLog(@"Sensor %@ returned a NSDictionary with missing key(s); keys found: %@",
		      [sensor_ name], [[dict allKeys] componentsJoinedByString:@", "]);
		return NO;
	}

	return YES;
}

@end
