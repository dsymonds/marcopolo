//
//  USBDevice.h
//  MarcoPolo
//
//  Created by David Symonds on 15/06/08.
//

#import <Cocoa/Cocoa.h>


@interface USBDevice : NSObject {
	@private
	NSNumber *vendorID_, *productID_;
	NSString *description_;
}

+ (id)deviceWithVendor:(UInt16)vendor_id product:(UInt16)product_id description:(NSString *)description;
- (id)initWithVendor:(UInt16)vendor_id product:(UInt16)product_id description:(NSString *)description;

- (NSNumber *)vendorID;
- (NSNumber *)productID;
- (NSString *)description;

- (BOOL)isEqual:(id)object;
- (unsigned)hash;

@end
