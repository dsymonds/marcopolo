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
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:1000];
		NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"usb-vendors"
										  ofType:@"txt"];
		if (!path) {
			NSLog(@"Couldn't find usb-vendors.txt");
			return nil;
		}
		NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
		if (!data) {
			NSLog(@"Couldn't read %@", path);
			return nil;
		}
		NSString *stringData = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		if (!stringData) {
			NSLog(@"Data in %@ is not UTF-8", path);
			return nil;
		}
		NSCharacterSet *nl = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
		NSScanner *scanner = [NSScanner scannerWithString:stringData];
		[scanner setCharactersToBeSkipped:nl];
		NSString *line;
		while ([scanner scanUpToCharactersFromSet:nl intoString:&line]) {
			NSArray *parts = [line componentsSeparatedByString:@"|"];
			if ([parts count] != 2) {
				NSLog(@"Malformed line: [%@]", line);
				continue;
			}

			[dict setValue:[parts objectAtIndex:1] forKey:[parts objectAtIndex:0]];
		}
		usbVendorDb = [dict retain];
	}

	return usbVendorDb;
}

@end
