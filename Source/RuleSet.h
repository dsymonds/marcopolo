//
//  RuleSet.h
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import <Cocoa/Cocoa.h>
#import "Rule.h"


// A set of rules.
@interface RuleSet : NSObject {
	@private
	NSMutableArray *rules_;
}

+ (id)ruleSet;
- (id)init;

- (NSEnumerator *)ruleEnumerator;

- (void)addRule:(id<Rule>)rule;

@end
