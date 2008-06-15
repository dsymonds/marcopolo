//
//  USBVendorDB.h
//  MarcoPolo
//
//  Created by David Symonds on 15/06/08.
//

#import <Cocoa/Cocoa.h>


@interface USBVendorDB : NSObject {
}

// Singleton dictionary mapping vendor ID (as a decimal NSString) to a vendor name.
+ (NSDictionary *)sharedUSBVendorDB;

@end
