//
//  LogicRule.h
//  MarcoPolo
//
//  Created by David Symonds on 25/07/08.
//

#import <Cocoa/Cocoa.h>
#import "Rule.h"


// Types for a logic rule.
typedef enum {
	kLogicRuleAND = 0,
	kLogicRuleOR = 1,
	kLogicRuleNOT = 2,  // a NOT-any (a.k.a. NOR)
} LogicRuleType;

// A rule that is a logical (AND/OR/NOT) grouping of other rules.
@interface LogicRule : NSObject<Rule> {
	@private
	LogicRuleType type_;
	NSMutableArray *subrules_;
}

+ (id)logicRuleOfType:(LogicRuleType)type withSubrules:(NSArray *)subrules;
- (id)initAsType:(LogicRuleType)type;
- (id)initAsType:(LogicRuleType)type withSubrules:(NSArray *)subrules;

- (void)setType:(LogicRuleType)type;
- (void)addSubrule:(id<Rule>)rule;

@end
