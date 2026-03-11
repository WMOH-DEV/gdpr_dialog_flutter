#import "GdprDialogPlugin.h"

#if __has_include(<gdpr_dialog/gdpr_dialog-Swift.h>)
#import <gdpr_dialog/gdpr_dialog-Swift.h>
#else
#import "gdpr_dialog-Swift.h"
#endif

@implementation GdprDialogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftGdprDialogPlugin registerWithRegistrar:registrar];
}
@end