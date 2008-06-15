//
//  USBVendorDB.m
//  MarcoPolo
//
//  Created by David Symonds on 15/06/08.
//

#import "USBVendorDB.h"


static NSDictionary *usbVendorDb = nil;


@implementation USBVendorDB

+ (NSDictionary *)sharedUSBVendorDB
{
	if (!usbVendorDb) {
		NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"usb-vendors"
										  ofType:@"txt"];
		if (!path) {
			NSLog(@"Couldn't find usb-vendors.txt");
			return nil;
		}
		NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
		FILE *f = fopen([path cStringUsingEncoding:NSUTF8StringEncoding], "r");
		// TODO: handle failure
		while (!feof(f)) {
			char buf[200];
			if (!fgets(buf, sizeof(buf), f))
				break;
			// Line format:  1033|NEC Corporation
			NSString *line = [NSString stringWithCString:buf encoding:NSUTF8StringEncoding];
			NSScanner *scan = [NSScanner scannerWithString:line];
			NSString *vendor_id, *vendor_name;
			[scan scanUpToString:@"|" intoString:&vendor_id];
			[scan setScanLocation:[scan scanLocation] + 1];
			[scan scanUpToString:@"\n" intoString:&vendor_name];

			[dict setValue:vendor_name forKey:vendor_id];
		}
		fclose(f);
		usbVendorDb = dict;
	}

	return usbVendorDb;
}

@end
