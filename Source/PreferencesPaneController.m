//
//  PreferencesPaneController.m
//  MarcoPolo
//
//  Created by David Symonds on 3/10/08.
//

#import "PreferencesPaneController.h"


@implementation PreferencesPaneController

- (id)initWithApplicationController:(ApplicationController *)applicationController
{
	if (!(self = [super init]))
		return nil;

	applicationController_ = [applicationController retain];

	return self;
}

- (void)dealloc
{
	[applicationController_ release];

	[super dealloc];
}

- (ApplicationController *)applicationController
{
	return applicationController_;
}

@end
