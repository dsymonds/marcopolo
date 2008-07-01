//
//  ValueSet.h
//  MarcoPolo
//
//  Created by David Symonds on 1/07/08.
//

#import <Cocoa/Cocoa.h>


// A set of values from sensors.
@interface ValueSet : NSObject {
	@private
	// Map the sensor name to an NSArray of values from it.
	NSMutableDictionary *values_;
}

+ (id)valueSet;
- (id)init;

// Always returns an NSArray, which might be empty.
- (NSArray *)valuesForSensor:(NSString *)sensorName;
- (NSEnumerator *)valueEnumeratorForSensor:(NSString *)sensorName;

- (void)setValueForSensor:(NSString *)sensorName value:(NSObject *)value;
- (void)setValuesForSensor:(NSString *)sensorName values:(NSArray *)values;

@end
