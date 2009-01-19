//
//  ContextNode.h
//  MarcoPolo
//
//  Created by David Symonds on 19/01/09.
//

#import <Cocoa/Cocoa.h>


// A base class for Context and ContextGroup objects.
@interface ContextNode : NSObject<NSCoding> {
	@protected
	NSString *name_;
	NSMutableArray *children_;

	ContextNode *parent_;  // not retained

	// Transient
	NSAttributedString *attributedName_, *attributedState_;
}

- (id)init;

- (NSString *)name;
- (NSMutableArray *)children;
- (ContextNode *)parent;

- (NSAttributedString *)attributedName;
- (NSAttributedString *)attributedState;

- (NSArray *)descendants;

- (void)setName:(NSString *)name;
- (void)setChildren:(NSArray *)children;

- (void)addChild:(ContextNode *)child;

@end
