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

- (void)testRuleMatching
{
	ExactRule *rule = [ExactRule exactRuleWithSensor:@"Mock" value:[NSNumber numberWithInt:1]];
	STAssertFalse([rule matches:[ValueSet valueSet]], nil);

	NSMutableArray *values = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:1]];
	STAssertTrue([rule matches:[self mockValueSetWithValues:values]], nil);

	[values addObject:[NSNumber numberWithInt:2]];
	[values addObject:[NSNumber numberWithInt:3]];
	STAssertTrue([rule matches:[self mockValueSetWithValues:values]], nil);

	[values removeObject:[NSNumber numberWithInt:1]];
	STAssertFalse([rule matches:[self mockValueSetWithValues:values]], nil);
}

@end
