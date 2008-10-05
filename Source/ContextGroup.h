//
//  ContextGroup.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>


@class ContextTree;


// A group of contexts, with zero or one of them selected.
@interface ContextGroup : NSObject {
	@private
	NSString *name_;
	ContextTree *contextTree_;
	Context *selection_;
}

+ (id)contextGroupWithName:(NSString *)name;
+ (id)contextGroupWithName:(NSString *)name contextTree:(ContextTree *)contextTree;
- (id)initWithName:(NSString *)name;

- (NSString *)name;
- (int)count;
- (ContextTree *)contextTree;

- (void)setContextTree:(ContextTree *)contextTree;

@end
