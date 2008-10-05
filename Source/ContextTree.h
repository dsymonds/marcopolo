//
//  ContextTree.h
//  MarcoPolo
//
//  Created by David Symonds on 5/10/08.
//

#import <Cocoa/Cocoa.h>


@class Context;


@interface ContextTree : NSObject {
	@private
	NSMutableArray *contexts_;
	NSMutableArray *topLevelContexts_;
}

+ (id)contextTree;
- (id)init;

- (int)count;
- (BOOL)containsContext:(Context *)context;
- (NSArray *)allContexts;
- (NSArray *)topLevelContexts;

// Add a context. Its parent attribute will be used, and should already exist
// in this context tree.
- (void)addContext:(Context *)context;

// Bulk add. Equivalent to calling -addContext on each element of the array.
- (void)addContextsFromArray:(NSArray *)array;

@end
