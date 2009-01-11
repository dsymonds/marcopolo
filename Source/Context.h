//
//  Context.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>


@class ContextTree;


// A single context.
@interface Context : NSObject {
	@private
	NSString *name_;

	NSMutableArray *children_;
	Context *parent_;  // not retained

	NSNumber *confidence_;	// in [0,1]

	NSAttributedString *attributedState_;
}

+ (id)context;
+ (id)contextWithName:(NSString *)name;
+ (id)contextWithName:(NSString *)name parent:(Context *)parent;
- (id)init;

- (NSString *)name;
- (NSString *)attributedName;
- (NSAttributedString *)attributedState;
- (NSMutableArray *)children;
- (Context *)parent;
- (NSNumber *)confidence;
- (NSString *)fullPath;

- (void)setName:(NSString *)name;
- (void)addChild:(Context *)parent;
- (void)setChildren:(NSArray *)children;
- (void)setConfidence:(NSNumber *)confidence;

@end
