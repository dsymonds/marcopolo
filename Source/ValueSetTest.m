//
//  ValueSetTest.m
//  MarcoPolo
//
//  Created by David Symonds on 1/07/08.
//

#import "ValueSet.h"
#import "ValueSetTest.h"


@implementation ValueSetTest

- (void)testWithNoSensors
{
	ValueSet *vs = [ValueSet valueSet];

	STAssertTrue([[vs valuesForSensor:@"Mock"] count] == 0, nil);
	STAssertNil([[vs valueEnumeratorForSensor:@"Mock"] nextObject], nil);
}

- (void)testSingleValueSensor
{
	ValueSet *vs = [ValueSet valueSet];

	[vs setValue:[NSNumber numberWithFloat:23.9] forSensor:@"Mock"];
	NSArray *vals = [vs valuesForSensor:@"Mock"];
	STAssertTrue([vals count] == 1, nil);
	STAssertEqualObjects([vals lastObject], [NSNumber numberWithFloat:23.9], nil);
}

@end
