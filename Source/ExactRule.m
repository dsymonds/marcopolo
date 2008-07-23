//
//  ExactRule.m
//  MarcoPolo
//
//  Created by David Symonds on 23/07/08.
//

#import "ExactRule.h"


@implementation ExactRule

#pragma mark NSCoder protocol

- (id)initWithCoder:(NSCoder *)coder
{
	if (!(self = [super init]))
		return nil;

	sensor_ = [[coder decodeObjectForKey:@"Sensor"] retain];
	value_ = [[coder decodeObjectForKey:@"Value"], retain];

	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:sensor_ forKey:@"Sensor"];
	[coder encodeObject:value_ forKey:@"Value"];
}

#pragma mark Rule protocol

- (BOOL)matches:(ValueSet *)valueSet
{
	// TODO
	return NO;
}

@end
