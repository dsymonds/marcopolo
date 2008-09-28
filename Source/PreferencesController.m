//
//  PreferencesController.m
//  MarcoPolo
//
//  Created by David Symonds on 25/09/08.
//

#import "PreferencesController.h"


@implementation PreferencesController

+ (NSWindow *)createPreferencesWindow
{
	NSWindow *w = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 400)
						  styleMask:(NSClosableWindowMask | NSResizableWindowMask)
						    backing:NSBackingStoreBuffered
						      defer:NO];
	[w setReleasedWhenClosed:NO];
	[w center];

	return w;
}

+ (NSView *)loadPaneViewFromNibNamd:(NSString *)nibName
{
	NSNib *nib = [[[NSNib alloc] initWithNibNamed:nibName bundle:nil] autorelease];
	NSArray *objects;
	if (![nib instantiateNibWithOwner:self topLevelObjects:&objects]) {
		NSLog(@"Failed instantiating prefs pane from prefs nib: %@", nibName);
		return nil;
	}
	NSEnumerator *en = [objects objectEnumerator];
	NSObject *obj;
	while ((obj = [en nextObject])) {
		if ([obj isKindOfClass:[NSView class]])
			break;
	}
	if (!obj) {
		NSLog(@"Failed to find an NSView object in prefs nib: %@", nibName);
		return nil;
	}
	return (NSView *)obj;
}

+ (NSArray *)loadPanes
{
	NSMutableArray *ps = [[NSMutableArray alloc] init];

	// General
	[ps addObject:[NSDictionary dictionaryWithObjectsAndKeys:
		       @"general", @"id",
		       NSLocalizedString(@"General", @"Preferences Pane name"), @"name",
		       [[self class] loadPaneViewFromNibNamd:@"GeneralPrefs"], @"pane",
		       nil]];

	return ps;
}

- (id)init
{
	if (!(self = [super init]))
		return nil;

	preferencesWindow_ = [[self class] createPreferencesWindow];
	panes_ = [[self class] loadPanes];

	return self;
}

- (void)dealloc
{
	[preferencesWindow_ release];

	[super dealloc];
}

#pragma mark -

- (void)runPreferences
{
	[preferencesWindow_ makeKeyAndOrderFront:nil];
}

@end
