//
//  ExactRuleTest.m
//  MarcoPolo
//
//  Created by David Symonds on 25/07/08.
//

#import "ExactRule.h"
#import "ExactRuleTest.h"
#import "ValueSet.h"


@implementation ExactRuleTest

- (ValueSet *)mockValueSetWithValues:(NSArray *)valueArray
{
	ValueSet *vs = [ValueSet valueSet];
	[vs setValues:valueArray forSensor:@"Mock"];
	return vs;
}

- (ValueSet *)mockValueSetWithValue:(NSObject *)value
{
	return [self mockValueSetWithValues:[NSArray arrayWithObject:value]];
}

- (void)testDefinition
{
	ExactRule *rule = [ExactRule exactRuleWithSensor:@"Mock" value:[NSNumber numberWithInt:1]];
	NSObject *def = [rule definition];
	NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"Exact", @"type",
				  @"Mock", @"sensor",
				  [NSNumber numberWithInt:1], @"value", nil];
	STAssertEqualObjects(def, expected, nil);
}

- (void)testRuleMatching
{
	ExactRule *rule = [ExactRule exactRuleWithSensor:@"Mock" value:[NSNumber numberWithInt:1]];
	STAssertFalse([rule matches:[ValueSet valueSet]], nil);

	// Just that exact value present
	NSMutableArray *values = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:1]];
	STAssertTrue([rule matches:[self mockValueSetWithValues:values]], nil);

	// Other values added
	[values addObject:[NSNumber numberWithInt:2]];
	[values addObject:[NSNumber numberWithInt:3]];
	STAssertTrue([rule matches:[self mockValueSetWithValues:values]], nil);

	// Value no longer there
	[values removeObject:[NSNumber numberWithInt:1]];
	STAssertFalse([rule matches:[self mockValueSetWithValues:values]], nil);

	// Completely different sensor name, but same value
	ValueSet *vs = [ValueSet valueSet];
	[vs setValue:[NSNumber numberWithInt:1] forSensor:@"OtherMock"];
	STAssertFalse([rule matches:[self mockValueSetWithValues:values]], nil);
}

@end
