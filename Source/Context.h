//
//  Context.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>
#import "ContextNode.h"


// A single context.
@interface Context : ContextNode {
	@private
	NSNumber *confidence_;	// in [0,1]
}

+ (id)context;
+ (id)contextWithName:(NSString *)name;
+ (id)contextWithName:(NSString *)name parent:(ContextNode *)parent;
- (id)init;

- (NSNumber *)confidence;

- (NSString *)fullPath;

- (void)setConfidence:(NSNumber *)confidence;

@end
