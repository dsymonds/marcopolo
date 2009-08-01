//
//  SensorArrayController.h
//  MarcoPolo
//
//  Created by David Symonds on 12/06/08.
//

#import <Cocoa/Cocoa.h>


@class ValueSet;

// The array of sensor stubs, each wrapped in a SensorController.
@interface SensorArrayController : NSArrayController {
}

- (void)loadSensors;

// Binding: valueSet
- (ValueSet *)valueSet;

@end
