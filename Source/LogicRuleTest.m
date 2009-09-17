//
//  LogicRuleTest.m
//  MarcoPolo
//
//  Created by David Symonds on 12/08/08.
//

#import "ExactRule.h"
#import "LogicRule.h"
#import "LogicRuleTest.h"
#import "TestHelpers.h"
#import "ValueSet.h"


@implementation LogicRuleTest

- (void)setUp
{
	one = [[NSNumber numberWithInt:1] retain];
	two = [[NSNumber numberWithInt:2] retain];
	three = [[NSNumber numberWithInt:3] retain];
	four = [[NSNumber numberWithInt:4] retain];
	one_two = [[NSArray arrayWithObjects:one, two, nil] retain];
	two_three = [[NSArray arrayWithObjects:two, three, nil] retain];
	three_four = [[NSArray arrayWithObjects:three, four, nil] retain];
	one_two_three_four = [[NSArray arrayWithObjects:one, two, three, four, nil] retain];
}

- (void)tearDown
{
	[one release];
	[two release];
	[three release];
	[four release];
	[one_two release];
	[two_three release];
	[three_four release];
	[one_two_three_four release];
}

- (ValueSet *)mockValueSetWithValues:(NSArray *)valueArray
{
	ValueSet *vs = [ValueSet valueSet];
	[vs setValues:valueArray forSensor:@"Mock"];
	return vs;
}

- (id<Rule>)ruleForValue:(NSObject *)value
{
	return [ExactRule exactRuleWithSensor:@"Mock" value:value];
}

- (LogicRule *)logicRule:(LogicRuleType)type withExactMatchSubrulesFrom:(NSArray *)valueArray
{
	NSMutableArray *subrules = [NSMutableArray arrayWithCapacity:[valueArray count]];
	NSEnumerator *en = [valueArray objectEnumerator];
	id val;
	while ((val = [en nextObject]))
		[subrules addObject:[self ruleForValue:val]];
	return [LogicRule logicRuleOfType:type withSubrules:subrules];
}

- (void)testDefinition
{
	LogicRule *rule = [self logicRule:kLogicRuleAND withExactMatchSubrulesFrom:one_two];
	NSObject *def = [rule definition];
	NSDictionary *expected = [NSDictionary dictionaryWithObjectsAndKeys:
				  @"Logic", @"type",
				  @"AND", @"operator",
				  [NSArray arrayWithObjects:
				   [[self ruleForValue:one] definition],
				   [[self ruleForValue:two] definition], nil],
				  @"subrules", nil];
	STAssertEqualObjects(def, expected, nil);
}

- (void)testLogicAnd
{
	LogicRule *lr;

	// No subrule case
	lr = [LogicRule logicRuleOfType:kLogicRuleAND withSubrules:[NSArray array]];
	STAssertFalse([lr matches:[self mockValueSetWithValues:[NSArray array]]],
		      @"No subrule AND should never match");
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two]],
		      @"No subrule AND should never match");
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two_three_four]],
		      @"No subrule AND should never match");

	// Non-trivial subrule case
	lr = [self logicRule:kLogicRuleAND withExactMatchSubrulesFrom:one_two];
	STAssertFalse([lr matches:[self mockValueSetWithValues:[NSArray array]]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:one_two]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:two_three]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:three_four]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:one_two_three_four]], nil);
}

- (void)testLogicOr
{
	LogicRule *lr;

	// No subrule case
	lr = [LogicRule logicRuleOfType:kLogicRuleOR withSubrules:[NSArray array]];
	STAssertFalse([lr matches:[self mockValueSetWithValues:[NSArray array]]],
		      @"No subrule OR should never match");
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two]],
		      @"No subrule OR should never match");

	// Non-trivial subrule case
	lr = [self logicRule:kLogicRuleOR withExactMatchSubrulesFrom:one_two];
	STAssertFalse([lr matches:[self mockValueSetWithValues:[NSArray array]]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:one_two]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:two_three]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:three_four]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:one_two_three_four]], nil);
}

- (void)testLogicNot
{
	LogicRule *lr;

	// No subrule case
	lr = [LogicRule logicRuleOfType:kLogicRuleNOT withSubrules:[NSArray array]];
	STAssertFalse([lr matches:[self mockValueSetWithValues:[NSArray array]]],
		      @"No subrule NOT should never match");
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two]],
		      @"No subrule NOT should never match");

	// Non-trivial subrule case
	lr = [self logicRule:kLogicRuleNOT withExactMatchSubrulesFrom:one_two];
	STAssertTrue([lr matches:[self mockValueSetWithValues:[NSArray array]]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:two_three]], nil);
	STAssertTrue([lr matches:[self mockValueSetWithValues:three_four]], nil);
	STAssertFalse([lr matches:[self mockValueSetWithValues:one_two_three_four]], nil);
}

// TODO: Add unit tests for nested logic rules.

@end
