/********* KeyboardAppearance.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface KeyboardAppearance : CDVPlugin {
  // Member variables go here.
}

- (void)setKeyboardAppearance:(CDVInvokedUrlCommand*)command;
@end

@implementation KeyboardAppearance

- (void)setKeyboardAppearance:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* param = [command.arguments objectAtIndex:0];
    
    if ([param isEqualToString:@"dark"]) {
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];
    } else if ([param isEqualToString:@"light"]) {
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceLight];
    } else {
        [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDefault];
    }

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
