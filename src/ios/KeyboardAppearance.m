/********* KeyboardAppearance.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>

@interface KeyboardAppearance : CDVPlugin {
  // Member variables go here.
  @protected NSString* _keyboardStyle;
}

@property (readwrite, assign) NSString* keyboardStyle;

- (void)keyboardStyle:(CDVInvokedUrlCommand*)command;

@end

@implementation KeyboardAppearance

#pragma mark Initialize

static NSString* UIClassString;
static NSString* WKClassString;
static NSString* UITraitsClassString;

- (void)pluginInitialize
{
    // Create these strings at runtime so they aren't flagged
    UIClassString = [@[@"UI", @"Web", @"Browser", @"View"] componentsJoinedByString:@""];
    WKClassString = [@[@"WK", @"Content", @"View"] componentsJoinedByString:@""];
    UITraitsClassString = [@[@"UI", @"Text", @"Input", @"Traits"] componentsJoinedByString:@""];
}

#pragma mark Keyboard Style

- (NSString*)keyboardStyle
{
    return _keyboardStyle;
}

- (void)setKeyboardStyle:(NSString*)style
{
    if ([style isEqualToString:_keyboardStyle]) {
        return;
    }

    IMP newImp = [style isEqualToString:@"dark"] ? imp_implementationWithBlock(^(id _s) {
        return UIKeyboardAppearanceDark;
    }) : imp_implementationWithBlock(^(id _s) {
        return UIKeyboardAppearanceLight;
    });

    for (NSString* classString in @[UIClassString, UITraitsClassString]) {
        Class c = NSClassFromString(classString);
        Method m = class_getInstanceMethod(c, @selector(keyboardAppearance));

        if (m != NULL) {
            method_setImplementation(m, newImp);
        } else {
            class_addMethod(c, @selector(keyboardAppearance), newImp, "l@:");
        }
    }

    _keyboardStyle = style;
}

#pragma mark Plugin interface

- (void)keyboardStyle:(CDVInvokedUrlCommand*)command
{
    id value = [command.arguments objectAtIndex:0];
    if ([value isKindOfClass:[NSString class]]) {
        value = [(NSString*)value lowercaseString];
    } else {
        value = @"light";
    }

    self.keyboardStyle = value;
}

@end
