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
	[sensorController removeObserver:self forKeyPath:@"value"];
	[sensorController removeObserver:self forKeyPath:@"valueSummary"];

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
	STAssertEquals([sensorController running], NO, nil);
	[sensorController setRunning:YES];
	STAssertEquals([sensorController running], YES, nil);
	[sensorController setRunning:NO];
	STAssertEquals([sensorController running], NO, nil);
}

- (void)testValueBinding
{
	[sensorController setRunning:YES];
	STAssertEquals([sensorController running], YES, nil);

	[mockSensor setMulti:NO];
	NSObject *sval = [sensorController value];
	STAssertNotNil(sval, nil);
	STAssertTrue([sval isKindOfClass:[NSDictionary class]], nil);
	NSDictionary *dict = (NSDictionary *) sval;
	NSNumber *val = [dict valueForKey:@"data"];
	STAssertEquals([val intValue], 0, nil);
	STAssertEqualObjects([sensorController valueSummary], [dict valueForKey:@"description"], nil);

	notifiedOfValueChange = NO;
	[mockSensor changeValue];
	STAssertTrue(notifiedOfValueChange, @"was not notified of value change");
	STAssertTrue(notifiedOfValueSummaryChange, @"was not notified of valueSummary change");

	dict = (NSDictionary *) [sensorController value];
	STAssertEquals([[dict valueForKey:@"data"] intValue], 1, nil);

	[mockSensor setMulti:YES];
	sval = [sensorController value];
	STAssertNotNil(sval, nil);
	STAssertTrue([sval isKindOfClass:[NSArray class]], nil);
	NSArray *valArray = (NSArray *) sval;
	STAssertTrue([valArray count] == 3, nil);
	STAssertEqualObjects([sensorController valueSummary], @"3 values", nil);
	int i;
	for (i = 0; i < 3; ++i)
		STAssertEquals([[valArray objectAtIndex:i] valueForKey:@"data"],
			       [NSNumber numberWithInt:i + 1], nil);
}

@end
