//
//  ContextCollectionView.m
//  MarcoPolo
//
//  Created by David Symonds on 2/10/08.
//

#import "ApplicationController.h"
#import "ContextCollectionController.h"
#import "ContextCollectionView.h"
#import "PreferencesPaneController.h"


@implementation ContextCollectionView

- (void)awakeFromNib
{
	ContextCollectionController *cc = [[preferencesPaneController applicationController]
					   contextCollectionController];
	[self setDataSource:cc];
}

@end
