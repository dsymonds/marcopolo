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
	NSMutableArray *children_;
	Context *selection_;

	NSAttributedString *attrName_, *attrState_;
}

+ (id)contextGroupWithName:(NSString *)name;
+ (id)contextGroupWithName:(NSString *)name topLevelContexts:(NSArray *)contexts;
- (id)initWithName:(NSString *)name;

- (NSString *)name;
- (NSAttributedString *)attributedName;
- (NSAttributedString *)attributedState;
- (NSArray *)children;
- (Context *)selection;

- (void)addTopLevelContext:(Context *)context;
- (void)addTopLevelContextsFromArray:(NSArray *)contexts;
- (void)setSelection:(Context *)context;

@end
