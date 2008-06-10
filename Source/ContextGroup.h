//
//  ContextGroup.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>

@class Context;


// A group of contexts, with zero or one of them selected.
@interface ContextGroup : NSObject {
	@private
	NSMutableArray *contexts_;
	Context *selection_;
}

+ (id)contextGroup;
+ (id)contextGroupWithContexts:(NSArray *)contextArray;
- (id)init;

- (int)count;
- (NSArray *)contexts;
- (NSArray *)topLevelContexts;
- (void)addContext:(Context *)context;
- (void)addContextsFromArray:(NSArray *)contextArray;

@end
