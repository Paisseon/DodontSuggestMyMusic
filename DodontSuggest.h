#import <UIKit/UIKit.h>
#import "libcolorpicker.h"

static NSString* bundleIdentifier = @"ai.paisseon.dodontsuggest";
static NSMutableDictionary *settings;
static bool enabled;
static bool hideSuggestions;
static bool hideMusicPlayer;
static bool colourTime;
static NSString* timeColour;

@interface DodoBottomView : UIView
@end