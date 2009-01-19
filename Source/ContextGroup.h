//
//  ContextGroup.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>
#import "ContextNode.h"


@class Context;


// A group of contexts, with zero or one of them selected.
@interface ContextGroup : ContextNode {
	@private
	Context *selection_;
}

+ (id)contextGroupWithName:(NSString *)name;
+ (id)contextGroupWithName:(NSString *)name topLevelContexts:(NSArray *)contexts;
- (id)initWithName:(NSString *)name;

- (Context *)selection;

- (void)setSelection:(Context *)context;

@end
