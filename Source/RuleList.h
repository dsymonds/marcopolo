//
//  RuleList.h
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import <Cocoa/Cocoa.h>
#import "Rule.h"


// A list of rules.
@interface RuleList : NSObject {
	@private
	NSMutableArray *rules_;
}

+ (id)ruleList;
- (id)init;

- (NSEnumerator *)ruleEnumerator;

- (void)addRule:(id<Rule>)rule;

@end
