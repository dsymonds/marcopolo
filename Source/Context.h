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
	Context *parent_;
	ContextTree *tree_;

	NSNumber *confidence_;	// in [0,1]
}

+ (id)context;
+ (id)contextWithName:(NSString *)name;
+ (id)contextWithName:(NSString *)name parent:(Context *)parent;
- (id)init;

- (NSString *)name;
- (Context *)parent;
- (ContextTree *)tree;
- (NSNumber *)confidence;
- (NSString *)fullPath;

- (void)setName:(NSString *)name;
- (void)setParent:(Context *)parent;
- (void)setTree:(ContextTree *)tree;
- (void)setConfidence:(NSNumber *)confidence;

@end
