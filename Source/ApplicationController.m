//
//  ApplicationController.m
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import "ApplicationController.h"


@implementation ApplicationController

- (void)awakeFromNib
{
	[self loadStatusItem];
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
