#import "SkittyPrefs/SPSettingsController.h"

@interface DDSettingsController : SPSettingsController
@end

@interface NSTask : NSObject
- (id) init;
- (void) launch;
- (void) setLaunchPath: (NSString*) arg1;
- (void) setArguments: (NSArray*) arg1;
@end
