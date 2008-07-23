//
//  Rule.h
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import <Cocoa/Cocoa.h>

@class ValueSet;


// The interface for all types of rules.
@protocol Rule<NSCoding>

- (BOOL)matches:(ValueSet *)valueSet;

@end
