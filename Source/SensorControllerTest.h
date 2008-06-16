//
//  SensorControllerTest.h
//  MarcoPolo
//
//  Created by David Symonds on 16/06/08.
//

#import <SenTestingKit/SenTestingKit.h>

@class MockSensor;
@class SensorController;


@interface SensorControllerTest : SenTestCase {
	MockSensor *mockSensor;
	SensorController *sensorController;

	BOOL notifiedOfValueChange, notifiedOfValueSummaryChange;
}

@end
