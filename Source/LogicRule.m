//
//  LogicRule.m
//  MarcoPolo
//
//  Created by David Symonds on 25/07/08.
//

#import "LogicRule.h"


@implementation LogicRule

+ (id)logicRuleOfType:(LogicRuleType)type withSubrules:(NSArray *)subrules
{
	return [[[LogicRule alloc] initAsType:type withSubrules:subrules] autorelease];
}

- (id)initAsType:(LogicRuleType)type
{
	return [self initAsType:type withSubrules:[NSArray array]];
}

- (id)initAsType:(LogicRuleType)type withSubrules:(NSArray *)subrules
{
	if (!(self = [super init]))
		return nil;

	type_ = type;
	subrules_ = [[NSMutableArray alloc] init];

	// Verify each subrule conforms to the Rule protocol.
	NSEnumerator *en = [subrules objectEnumerator];
	id obj;
	while ((obj = [en nextObject])) {
		if ([obj conformsToProtocol:@protocol(Rule)])
			[subrules_ addObject:obj];
		else
			NSLog(@"WARNING: Tried to add a subrule that wasn't a rule!");
	}

	return self;
}

#pragma mark Rule protocol

- (NSObject *)definition
{
	NSString *op = @"???";
	switch (type_) {
		case kLogicRuleAND:
			op = @"AND";
			break;
		case kLogicRuleOR:
			op = @"OR";
			break;
		case kLogicRuleNOT:
			op = @"NOT";
			break;
	}

	NSMutableArray *subrules = [NSMutableArray arrayWithCapacity:[subrules_ count]];
	NSEnumerator *en = [subrules_ objectEnumerator];
	id<Rule> subrule;
	while ((subrule = [en nextObject])) {
		[subrules addObject:[subrule definition]];
	}

	return [NSDictionary dictionaryWithObjectsAndKeys:
		@"Logic", @"type",
		op, @"operator",
		subrules, @"subrules", nil];
}

- (BOOL)matches:(ValueSet *)valueSet
{
	if ([subrules_ count] == 0)
		return NO;

	BOOL match = NO;
	if (type_ == kLogicRuleAND || type_ == kLogicRuleNOT)
		match = YES;

	NSEnumerator *en = [subrules_ objectEnumerator];
	id<Rule> subrule;
	while ((subrule = [en nextObject])) {
		BOOL individualMatch = [subrule matches:valueSet];
		switch (type_) {
			case kLogicRuleAND:
				match = match && individualMatch;
				break;
			case kLogicRuleOR:
				match = match || individualMatch;
				break;
			case kLogicRuleNOT:
				match = match && !individualMatch;
				break;
		}
	}

	return match;
}

#pragma mark -

- (void)setType:(LogicRuleType)type
{
	type_ = type;
}

- (void)addSubrule:(id<Rule>)rule
{
	[subrules_ addObject:rule];
}

@end
