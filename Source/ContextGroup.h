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
	NSString *name_;
	NSMutableArray *contexts_;
	Context *selection_;
}

+ (id)contextGroupWithName:(NSString *)name;
+ (id)contextGroupWithName:(NSString *)name contexts:(NSArray *)contextArray;
- (id)initWithName:(NSString *)name;

- (NSString *)name;
- (int)count;
- (NSArray *)contexts;
- (NSArray *)topLevelContexts;
- (void)addContext:(Context *)context;
- (void)addContextsFromArray:(NSArray *)contextArray;

@end
