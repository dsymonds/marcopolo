//
//  MockSensor.h
//  MarcoPolo
//
//  Created by David Symonds on 16/06/08.
//

#import <Cocoa/Cocoa.h>
#import "Sensor.h"


@interface MockSensor : NSObject<Sensor> {
	BOOL multi_, started_;
	int value_;
}

// Sensor protocol methods
- (NSString *)name;
- (BOOL)isMultiValued;
- (BOOL)start;
- (BOOL)stop;
- (NSObject *)value;

// Mock controls
- (void)setMulti:(BOOL)multi;
- (void)changeValue;

@end
