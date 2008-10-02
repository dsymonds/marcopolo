//
//  ContextsView.m
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import "ApplicationController.h"
#import "ContextsController.h"
#import "ContextsView.h"
#import "PreferencesPaneController.h"


@implementation ContextsView

- (void)awakeFromNib
{
	ContextsController *cc = [[preferencesPaneController applicationController] contextsController];
	[self setDataSource:cc];
}

@end
