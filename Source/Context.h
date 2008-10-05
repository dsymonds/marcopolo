//
//  Context.h
//  MarcoPolo
//
//  Created by David Symonds on 10/06/08.
//

#import <Cocoa/Cocoa.h>


// A single context.
@interface Context : NSObject {
	@private
	NSString *name_;
	Context *parent_;
}

+ (id)context;
+ (id)contextWithName:(NSString *)name;
+ (id)contextWithName:(NSString *)name parent:(Context *)parent;
- (id)init;

- (NSString *)name;
- (Context *)parent;
- (void)setName:(NSString *)name;
- (void)setParent:(Context *)parent;

@end
