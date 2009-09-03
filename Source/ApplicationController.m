//
//  ApplicationController.m
//  MarcoPolo
//
//  Created by David Symonds on 15/08/08.
//

#import "ApplicationController.h"
#import "ContextCollection.h"
#import "PreferencesController.h"
#import "SensorArrayController.h"


@interface ApplicationController (Private)

- (void)loadStatusItem;

@end

#pragma mark -

@implementation ApplicationController

- (id)init
{
	if (!(self = [super init]))
		return nil;

	contextCollection_ = [[ContextCollection alloc] init];
	sensorArrayController_ = [[SensorArrayController alloc] init];

	preferencesController_ = [[PreferencesController alloc] initWithApplicationController:self];

	return self;
}

- (void)dealloc
{
	[preferencesController_ release];

	[contextCollection_ release];

	[super dealloc];
}

- (void)awakeFromNib
{
	[sensorArrayController_ loadSensors];

	[self loadStatusItem];

	NSString *prefPane = [[NSUserDefaults standardUserDefaults] stringForKey:@"DebugShowPrefPaneOnStartup"];
	if (prefPane) {
		[self performSelector:@selector(runPreferences:)
			   withObject:self
			   afterDelay:0.5];
		[preferencesController_ performSelector:@selector(switchToPaneNamed:)
					     withObject:prefPane
					     afterDelay:1.0];
	}
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

#pragma mark -

- (ContextCollection *)contextCollection
{
	return contextCollection_;
}

- (SensorArrayController *)sensorArrayController
{
	return sensorArrayController_;
}

@end
