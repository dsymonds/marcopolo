//
//  PreferencesController.m
//  MarcoPolo
//
//  Created by David Symonds on 25/09/08.
//

#import "PreferencesController.h"


@interface PreferencesController (Private)

- (void)switchToPane:(NSMutableDictionary *)pane;
- (void)resizeWindowToSize:(NSSize)size withMinSize:(NSSize)minSize resizeable:(BOOL)resizeable;

@end

#pragma mark -

@implementation PreferencesController

+ (NSWindow *)createPreferencesWindow
{
	int mask = NSTitledWindowMask | NSClosableWindowMask | NSResizableWindowMask;
	NSWindow *w = [[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 500, 400)
						  styleMask:mask
						    backing:NSBackingStoreBuffered
						      defer:NO];
	[w setReleasedWhenClosed:NO];
	[w center];

	return w;
}

- (NSToolbar *)createToolbar
{
	NSToolbar *t = [[NSToolbar alloc] initWithIdentifier:@"PreferencesToolbar"];

	[t setAllowsUserCustomization:NO];
	[t setAutosavesConfiguration:NO];
	[t setDelegate:self];

	return t;
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
	return (NSView *) [obj retain];
}

+ (NSArray *)loadPanes
{
	NSMutableArray *ps = [[NSMutableArray alloc] init];

	// General
	[ps addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		       @"general", @"id",
		       NSLocalizedString(@"General", @"Preferences Pane name"), @"name",
		       [[[self class] loadPaneViewFromNibNamd:@"GeneralPrefs"] autorelease], @"view",
		       [NSNumber numberWithBool:NO], @"resizeable",
		       @"GeneralPrefs", @"icon",
		       nil]];

	// Contexts
	[ps addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
		       @"contexts", @"id",
		       NSLocalizedString(@"Contexts", @"Preferences Pane name"), @"name",
		       [[[self class] loadPaneViewFromNibNamd:@"ContextsPrefs"] autorelease], @"view",
		       [NSNumber numberWithBool:YES], @"resizeable",
		       @"ContextsPrefs", @"icon",
		       nil]];

	// Use the starting size as each pane's minimum size
	NSEnumerator *en = [ps objectEnumerator];
	NSMutableDictionary *pane;
	while ((pane = [en nextObject])) {
		NSView *view = [pane valueForKey:@"view"];
		NSSize size = [view frame].size;
		[pane setValue:[NSNumber numberWithFloat:size.width] forKey:@"min_width"];
		[pane setValue:[NSNumber numberWithFloat:size.height] forKey:@"min_height"];
	}

	return ps;
}

#pragma mark -

- (id)init
{
	if (!(self = [super init]))
		return nil;

	panes_ = [[self class] loadPanes];
	currentPane_ = nil;

	preferencesWindow_ = [[self class] createPreferencesWindow];
	toolbar_ = [self createToolbar];

	[preferencesWindow_ setToolbar:toolbar_];
	[self switchToPane:[panes_ objectAtIndex:0]];

	return self;
}

- (void)dealloc
{
	[panes_ release];
	[preferencesWindow_ release];

	[super dealloc];
}

#pragma mark -

- (void)runPreferences
{
	[preferencesWindow_ makeKeyAndOrderFront:nil];
}

#pragma mark -

- (NSMutableDictionary *)paneByIdentifier:(NSString *)identifier
{
	NSEnumerator *en = [panes_ objectEnumerator];
	NSMutableDictionary *pane;
	while ((pane = [en nextObject]))
		if ([[pane valueForKey:@"id"] isEqualToString:identifier])
			return pane;
	return nil;
}

- (float)toolbarHeight
{
	NSRect contentRect;

	contentRect = [NSWindow contentRectForFrameRect:[preferencesWindow_ frame]
					      styleMask:[preferencesWindow_ styleMask]];
	return NSHeight(contentRect) - NSHeight([[preferencesWindow_ contentView] frame]);
}

- (float)titleBarHeight
{
	return [preferencesWindow_ frame].size.height
		- [[preferencesWindow_ contentView] frame].size.height
		- [self toolbarHeight];
}

- (float)toolbarAndTitleBarHeight
{
	return [self toolbarHeight] + [self titleBarHeight];
}

- (void)toolbarItemSelected:(NSToolbarItem *)sender
{
	NSMutableDictionary *pane = [self paneByIdentifier:[sender itemIdentifier]];
	[self switchToPane:pane];
}

- (void)switchToPane:(NSMutableDictionary *)pane
{
	if (pane == currentPane_)
		return;

	if (currentPane_) {
		// Remember current size
		NSSize size = [preferencesWindow_ frame].size;
		size.height -= [self toolbarAndTitleBarHeight];
		[currentPane_ setValue:[NSNumber numberWithFloat:size.width]
				forKey:@"last_width"];
		[currentPane_ setValue:[NSNumber numberWithFloat:size.height]
				forKey:@"last_height"];
	}

	NSSize minSize = NSMakeSize([[pane valueForKey:@"min_width"] floatValue],
				    [[pane valueForKey:@"min_height"] floatValue]);
	NSSize size = minSize;
	if ([pane objectForKey:@"last_width"]) {
		size = NSMakeSize([[pane valueForKey:@"last_width"] floatValue],
				  [[pane valueForKey:@"last_height"] floatValue]);
	}

	BOOL resizeable = [[pane valueForKey:@"resizeable"] boolValue];
	[preferencesWindow_ setShowsResizeIndicator:resizeable];

	[preferencesWindow_ setTitle:[NSString stringWithFormat:@"MarcoPolo  %C  %@",
				      0x2014, [pane valueForKey:@"name"]]];

	// Shift to a blank view of the correct size first
	NSView *blank = [[[NSView alloc] init] autorelease];
	[preferencesWindow_ setContentView:blank];
	[self resizeWindowToSize:size
		     withMinSize:minSize
		      resizeable:resizeable];

	if ([toolbar_ respondsToSelector:@selector(setSelectedItemIdentifier:)])
		[toolbar_ setSelectedItemIdentifier:[pane valueForKey:@"id"]];
	[preferencesWindow_ setContentView:[pane valueForKey:@"view"]];
	currentPane_ = pane;
}

- (void)resizeWindowToSize:(NSSize)size withMinSize:(NSSize)minSize resizeable:(BOOL)resizeable
{
	NSRect frame;
	float tbHeight, newHeight, newWidth;

	tbHeight = [self toolbarHeight];

	newWidth = size.width;
	newHeight = size.height;

	frame = [NSWindow contentRectForFrameRect:[preferencesWindow_ frame]
					styleMask:[preferencesWindow_ styleMask]];
	frame.origin.y += frame.size.height;
	frame.origin.y -= newHeight + tbHeight;
	frame.size.width = newWidth;
	frame.size.height = newHeight + tbHeight;
	frame = [NSWindow frameRectForContentRect:frame
					styleMask:[preferencesWindow_ styleMask]];

	[preferencesWindow_ setFrame:frame display:YES animate:YES];

	minSize.height += [self titleBarHeight];
	[preferencesWindow_ setMinSize:minSize];

	[preferencesWindow_ setMaxSize:(resizeable ? NSMakeSize(FLT_MAX, FLT_MAX) : minSize)];
}

#pragma mark -
#pragma mark NSToolbar delegate methods

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	NSDictionary *pane = [self paneByIdentifier:itemIdentifier];
	if (!pane)
		return nil;

	NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];

	[item setLabel:[pane valueForKey:@"name"]];
	[item setImage:[NSImage imageNamed:[pane valueForKey:@"icon"]]];
	[item setTarget:self];
	[item setAction:@selector(toolbarItemSelected:)];

	return item;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
	NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[panes_ count]];

	NSEnumerator *en = [panes_ objectEnumerator];
	NSDictionary *pane;
	while ((pane = [en nextObject]))
		[arr addObject:[pane valueForKey:@"id"]];

	return arr;
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
	return [self toolbarAllowedItemIdentifiers:toolbar];
}

@end
