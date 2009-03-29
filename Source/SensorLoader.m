//
//  SensorLoader.m
//  MarcoPolo
//
//  Created by David Symonds on 13/03/09.
//

#import "Sensor.h"
#import "SensorLoader.h"


@implementation SensorLoader

+ (NSObject<Sensor> *)sensorFromBundle:(NSBundle *)bundle
{
	Class sensorClass = [bundle principalClass];
	if (!sensorClass) {
		NSLog(@"Failed to find the principal class of bundle %@",
		      [bundle bundlePath]);
		return nil;
	}

	// Verify adherence to Sensor protocol
	if (![sensorClass conformsToProtocol:@protocol(Sensor)]) {
		NSLog(@"Class '%@' from bundle %@ doesn't conform to Sensor protocol",
		      sensorClass, [bundle bundlePath]);
		return nil;
	}
	// Since this is a compiled sensor we are loading, it might be declaring that it
	// conforms to an older Sensor protocol, so we check that the required methods are
	// actually implemented.
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
			return nil;
		}
	}

	return [[[sensorClass alloc] init] autorelease];
}

@end
