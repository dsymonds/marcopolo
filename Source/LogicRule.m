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
	LogicRule *lr = [[[self alloc] initAsType:type] autorelease];
	NSEnumerator *en = [subrules objectEnumerator];
	id obj;
	while ((obj = [en nextObject])) {
		if ([obj conformsToProtocol:@protocol(Rule)])
			[lr addSubrule:obj];
		else
			NSLog(@"WARNING: Tried to add a subrule that wasn't a rule!");
	}
	return lr;
}

- (id)initAsType:(LogicRuleType)type
{
	if (!(self = [super init]))
		return nil;

	type_ = type;
	subrules_ = [[NSMutableArray alloc] init];

	return self;
}

#pragma mark NSCoder protocol

- (id)initWithCoder:(NSCoder *)coder
{
	// TODO
//	return [self initWithSensor:[coder decodeObjectForKey:@"Sensor"]
//			      value:[coder decodeObjectForKey:@"Value"]];
	return [self init];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	// TODO
//	[coder encodeObject:sensor_ forKey:@"Sensor"];
//	[coder encodeObject:value_ forKey:@"Value"];
}

#pragma mark Rule protocol

- (BOOL)matches:(ValueSet *)valueSet
{
	if ([subrules_ count] == 0)
		return NO;

	BOOL match = NO;
	if (type_ == kLogicRuleAND || type_ == kLogicRuleNOT)
		match = YES;

	NSEnumerator *en = [subrules_ objectEnumerator];
	id<Rule> obj;
	while ((obj = [en nextObject])) {
		BOOL individualMatch = [obj matches:valueSet];
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
