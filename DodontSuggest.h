#import <UIKit/UIKit.h>
#import "libcolorpicker.h"

static NSString* bundleIdentifier = @"ai.paisseon.dodontsuggest";
static NSMutableDictionary *settings;
static bool enabled;
static NSString* timeColour;

@interface DodoTimeDateContainerView : UIView
@end