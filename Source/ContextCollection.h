//
//  ContextCollection.h
//  MarcoPolo
//
//  Created by David Symonds on 9/01/09.
//

#import <Cocoa/Cocoa.h>


@class ContextGroup;


// A collection of ContextGroups.
@interface ContextCollection : NSObject {
	@private
	NSMutableArray *contextGroups_;
}

- (NSArray *)children;

- (void)addContextGroup:(ContextGroup *)contextGroup;
- (void)setChildren:(NSArray *)children;

@end
