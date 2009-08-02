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
- (void)start;
- (void)stop;
- (BOOL)running;
- (NSObject *)value;

// Mock controls
- (void)setMulti:(BOOL)multi;
- (void)changeValue;

@end
