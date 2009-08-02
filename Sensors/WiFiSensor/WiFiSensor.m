//
//  WiFiSensor.m
//  MarcoPolo
//
//  Created by David Symonds on 2/08/09.
//

#import "Apple80211.h"
#import "OS.h"
#import "WiFiSensor.h"


#define kWiFiScanInterval	((NSTimeInterval) 10)


@interface WiFiSensor (Private)

- (void)update:(NSTimer *)timer;
- (NSArray *)updateWithApple80211;

- (void)setAccessPoints:(NSArray *)arr;

@end

#pragma mark -

@implementation WiFiSensor

- (id)init
{
	if (!(self = [super init]))
		return nil;

	lock_ = [[NSLock alloc] init];
	accessPoints_ = [[NSMutableArray alloc] init];
	timer_ = nil;
	osxMinorVersion_ = OSXMinorVersion();

	return self;
}

- (void)dealloc
{
	[timer_ invalidate];
	[lock_ release];
	[accessPoints_ release];
	[super dealloc];
}

- (NSString *)name
{
	return @"WiFi";
}

- (BOOL)isMultiValued
{
	return YES;
}

- (void)start
{
	timer_ = [NSTimer scheduledTimerWithTimeInterval:kWiFiScanInterval
						  target:self
						selector:@selector(update:)
						userInfo:nil
						 repeats:YES];
	[timer_ fire];
}

- (void)stop
{
	[timer_ invalidate];
	timer_ = nil;
	[self setAccessPoints:[NSArray array]];
}

- (BOOL)running
{
	return timer_ != nil;
}

- (NSObject *)value
{
	[lock_ lock];
	NSArray *accessPoints = [[accessPoints_ copy] autorelease];
	[lock_ unlock];

	return accessPoints;
}

static NSString *macToString(const UInt8 *mac)
{
	return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]];
}

- (void)update:(NSTimer *)timer
{
	if (osxMinorVersion_ == 4 || osxMinorVersion_ == 5) {
		NSArray *arr = [self updateWithApple80211];
		[self setAccessPoints:(arr ? arr : [NSArray array])];
	}
}

- (NSArray *)updateWithApple80211
{
	if (!WirelessIsAvailable())
		return nil;

	WirelessContextPtr wctxt;
	WIErr err;
	if ((err = WirelessAttach(&wctxt, 0)) != noErr)
		return nil;

	// First, if we are already associated with an AP then we return only it, without scanning.
	// This avoids disrupting existing connections.
	WirelessInfo winfo;
	if (WirelessGetInfo(wctxt, &winfo) == noErr) {
		if (winfo.power > 0 && winfo.link_qual > 0) {
			NSString *ssid = [NSString stringWithCString:(const char *) winfo.name
							    encoding:NSISOLatin1StringEncoding];
			NSString *mac = macToString(winfo.macAddress);
			return [NSArray arrayWithObject:
				[NSDictionary dictionaryWithObjectsAndKeys:
				 ssid, @"SSID", mac, @"MAC", nil]];
		}
	}

	// FAKE DATA
	return [NSArray arrayWithObject:
		[NSDictionary dictionaryWithObjectsAndKeys:
		 @"D-Link", @"SSID", @"00:50:ba:e1:fa:46", @"MAC", nil]];

	// TODO: actual scanning

	return nil;
}

// Takes an array of dictionaries, each with SSID and MAC keys.
// Each dictionary is expanded into two value dictionaries, one for SSID, one for MAC.
- (void)setAccessPoints:(NSArray *)arr
{
	NSMutableArray *accessPoints = [NSMutableArray arrayWithCapacity:[arr count]];
	NSEnumerator *en = [arr objectEnumerator];
	NSDictionary *dict;
	while ((dict = [en nextObject])) {
		// TODO: Detect and ignore duplicate SSIDs
		NSString *ssid = [dict valueForKey:@"SSID"];
		NSString *mac = [dict valueForKey:@"MAC"];
		[accessPoints addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  [NSDictionary dictionaryWithObject:ssid forKey:@"ssid"], @"data",
		  [NSString stringWithFormat:@"SSID = %@", ssid], @"description", nil]];
		[accessPoints addObject:
		 [NSDictionary dictionaryWithObjectsAndKeys:
		  [NSDictionary dictionaryWithObject:mac forKey:@"mac"], @"data",
		  [NSString stringWithFormat:@"MAC = %@", mac], @"description", nil]];
	}

	[self willChangeValueForKey:@"value"];
	[lock_ lock];
	[accessPoints_ setArray:accessPoints];
	[lock_ unlock];
	[self didChangeValueForKey:@"value"];
}

@end
