#import "GdprDialogPlugin.h"
#import "SwiftGdprDialogPlugin.h"

@implementation GdprDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftGdprDialogPlugin registerWithRegistrar:registrar];
}
@end