//
//  ExactRule.h
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import <Cocoa/Cocoa.h>
#import "Rule.h"


@interface ExactRule : NSObject<Rule> {
	@private
	NSString *sensor_;
	NSObject *value_;
}

@end
