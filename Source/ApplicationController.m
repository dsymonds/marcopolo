//
//  ApplicationController.m
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import "ApplicationController.h"
#import "PreferencesController.h"


@implementation ApplicationController

- (id)init
{
	if (!(self = [super init]))
		return nil;

	preferencesController_ = [[PreferencesController alloc] init];

	return self;
}

- (void)dealloc
{
	[preferencesController_ release];

	[super dealloc];
}

- (void)awakeFromNib
{
	[self loadStatusItem];
}

- (IBAction)runPreferences:(id)sender
{
	[preferencesController_ runPreferences];
}

- (void)loadStatusItem
{
	if (statusBarItem_) {
		[[NSStatusBar systemStatusBar] removeStatusItem:statusBarItem_];
		[statusBarItem_ release];
	}

	// TODO: use an icon instead
	statusBarItem_ = [[NSStatusBar systemStatusBar] statusItemWithLength:35];
	[statusBarItem_ retain];
	[statusBarItem_ setHighlightMode:YES];
	//[statusBarItem_ setImage:XXX];
	[statusBarItem_ setTitle:@"hi"];
	[statusBarItem_ setMenu:statusBarMenu];
}

@end
