//
//  SensorControllerTest.m
//  MarcoPolo
//
//  Created by David Symonds on 16/06/08.
//

#import "MockSensor.h"
#import "SensorController.h"
#import "SensorControllerTest.h"


@implementation SensorControllerTest

- (void)setUp
{
	mockSensor = [[MockSensor alloc] init];
	STAssertNotNil(mockSensor, nil);
	sensorController = [[SensorController alloc] initWithSensor:mockSensor];
	STAssertNotNil(sensorController, nil);

	notifiedOfValueChange = NO;
	notifiedOfValueSummaryChange = NO;
	[sensorController addObserver:self forKeyPath:@"value" options:0 context:nil];
	[sensorController addObserver:self forKeyPath:@"valueSummary" options:0 context:nil];
}

- (void)tearDown
{
	[mockSensor release];
	[sensorController release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
		      ofObject:(id)object
			change:(NSDictionary *)change
		       context:(void *)context
{
	STAssertEqualObjects(object, sensorController, @"got notified of a non-sensorController KVO change!");
	if ([keyPath isEqualToString:@"value"])
		notifiedOfValueChange = YES;
	else if ([keyPath isEqualToString:@"valueSummary"])
		notifiedOfValueSummaryChange = YES;
	else
		STAssertTrue(NO, @"got notified of an unexpected KVO change: '%@'", keyPath);
}

#pragma mark -
#pragma mark Tests

- (void)testSimpleBindings
{
	STAssertEqualObjects([sensorController name], [mockSensor name], nil);
}

- (void)testStartingAndStopping
{
	STAssertEquals([sensorController started], NO, nil);
	[sensorController setStarted:YES];
	STAssertEquals([sensorController started], YES, nil);
	[sensorController setStarted:NO];
	STAssertEquals([sensorController started], NO, nil);
}

- (void)testValueBinding
{
	[sensorController setStarted:YES];
	STAssertEquals([sensorController started], YES, nil);

	[mockSensor setMulti:NO];
	NSNumber *val = (NSNumber *) [sensorController value];
	STAssertEquals([val intValue], 0, nil);
	STAssertEqualObjects([sensorController valueSummary], val, nil);

	notifiedOfValueChange = NO;
	[mockSensor changeValue];
	STAssertTrue(notifiedOfValueChange, @"was not notified of value change");
	STAssertTrue(notifiedOfValueSummaryChange, @"was not notified of valueSummary change");

	val = (NSNumber *) [sensorController value];
	STAssertEquals([val intValue], 1, nil);

	[mockSensor setMulti:YES];
	NSArray *valArray = (NSArray *) [sensorController value];
	STAssertTrue([valArray count] == 3, nil);
	STAssertEqualObjects([sensorController valueSummary], @"3 values", nil);
	int i;
	for (i = 0; i < 3; ++i)
		STAssertEquals([valArray objectAtIndex:i], [NSNumber numberWithInt:i + 1], nil);
}

@end
