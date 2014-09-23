//
//  UILabel+LFXExtensions.m
//  LIFX
//
//  Created by Nick Forge on 5/02/2014.
//  Copyright (c) 2014 LIFX Labs. All rights reserved.
//

#import "UILabel+LFXExtensions.h"

@implementation UILabel (LFXExtensions)

- (void)lfx_fadeToText:(NSString *)text duration:(NSTimeInterval)duration
{
	[self lfx_fadeToText:text textColor:self.textColor duration:duration];
}

- (void)lfx_fadeToText:(NSString *)text textColor:(UIColor *)textColor duration:(NSTimeInterval)duration
{
	if ([self.text isEqualToString:text] && [self.textColor isEqual:textColor]) return;
	
	if (duration == 0.0)
	{
		self.text = text;
		self.textColor = textColor;
		return;
	}
	
	// If the view isn't in the hierarchy yet (and hasn't been rendered), creating a snapshot
	// will pollute the console log, so don't bother with a snapshot in that scenario.
	if (self.window != nil)
	{
		UIView *snapshot = [self snapshotViewAfterScreenUpdates:NO];
		snapshot.frame = self.frame;
		[self.superview addSubview:snapshot];

		// Fade Out the Snapshot
		[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
			snapshot.alpha = 0.0;
		} completion:^(BOOL finished) {
			[snapshot removeFromSuperview];
		}];
	}
	
	// Fade In the actual Label
	self.alpha = 0.0;
	self.text = text;
	self.textColor = textColor;
	
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		self.alpha = 1.0;
	} completion:^(BOOL finished) {
		
	}];
}

@end
