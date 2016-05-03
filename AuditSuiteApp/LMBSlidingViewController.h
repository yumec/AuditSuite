//  LMBSlidingViewController.h
//  ImmApp
//
//  Created by Esteban Torres Hernández on 1/31/11.
//  Copyright 2011 Little Maven Bird. All rights reserved.

//  Set the "tag" value of all the textfields in incremental order for the controller to
//  automatically navigate between them in logical order when pressing the "return" key

#import <UIKit/UIKit.h>


@interface LMBSlidingViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate> {
	CGFloat animatedDistance;
}

@end
