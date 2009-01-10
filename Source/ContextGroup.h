//
//  ContextGroup.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>


@class Context;
@class ContextTree;


// A group of contexts, with zero or one of them selected.
@interface ContextGroup : NSObject {
	@private
	NSString *name_;
	ContextTree *contextTree_;
	Context *selection_;

	NSAttributedString *attrName_, *attrState_;
}

+ (id)contextGroupWithName:(NSString *)name;
+ (id)contextGroupWithName:(NSString *)name contextTree:(ContextTree *)contextTree;
- (id)initWithName:(NSString *)name;

- (NSString *)name;
- (NSAttributedString *)attributedName;
- (NSAttributedString *)attributedState;
- (int)count;
- (ContextTree *)contextTree;
- (Context *)selection;

- (void)setContextTree:(ContextTree *)contextTree;
- (void)setSelection:(Context *)context;

@end
