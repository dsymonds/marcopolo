//
//  USBDevice.m
//  MarcoPolo
//
//  Created by David Symonds on 15/06/08.
//

#import "USBDevice.h"


@implementation USBDevice

+ (id)deviceWithVendor:(UInt16)vendor_id product:(UInt16)product_id description:(NSString *)description
{
	return [[[[self class] alloc] initWithVendor:vendor_id
					     product:product_id
					 description:description] autorelease];
}

- (id)initWithVendor:(UInt16)vendor_id product:(UInt16)product_id description:(NSString *)description
{
	if (!(self = [super init]))
		return nil;

	vendorID_ = [[NSNumber alloc] initWithInt:vendor_id];
	productID_ = [[NSNumber alloc] initWithInt:product_id];
	description_ = [description retain];

	return self;
}

- (void)dealloc
{
	[vendorID_ release];
	[productID_ release];
	[description_ release];
	[super dealloc];
}

- (NSNumber *)vendorID
{
	return vendorID_;
}

- (NSNumber *)productID
{
	return productID_;
}

- (NSString *)description
{
	return description_;
}

- (BOOL)isEqual:(id)object
{
	if (self == object)
		return YES;
	if (!object || ![object isKindOfClass:[self class]])
		return NO;
	USBDevice *other = (USBDevice *) object;
	return ([vendorID_ isEqualToNumber:[other vendorID]] &&
		[productID_ isEqualToNumber:[other productID]]);
}

- (unsigned)hash
{
	return [vendorID_ hash] ^ [productID_ hash];
}

@end
