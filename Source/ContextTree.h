//
//  ContextTree.h
//  MarcoPolo
//
//  Created by David Symonds on 5/10/08.
//

#import <Cocoa/Cocoa.h>


@class Context;


// A tree of contexts.
// The tree structure is defined by the context objects (they have parent links).
// This class manages a collection of context objects, and provides convenience methods.
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
- (NSArray *)childrenOfContext:(Context *)context;

// Add a context. Its parent attribute will be used, and should already exist
// in this context tree.
- (void)addContext:(Context *)context;

// Bulk add. Equivalent to calling -addContext on each element of the array.
- (void)addContextsFromArray:(NSArray *)array;

// Remove a context from this tree. May cause the context to be deallocated if the
// tree is the last retainer.
- (void)removeContext:(Context *)context;

@end
