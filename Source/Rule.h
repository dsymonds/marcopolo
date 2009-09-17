//
//  Rule.h
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import <Cocoa/Cocoa.h>

@class ValueSet;


// The interface for all types of rules.
@protocol Rule

// Return the rule's definition as an NSCoding-conformant object.
- (NSObject *)definition;

- (BOOL)matches:(ValueSet *)valueSet;

@end
