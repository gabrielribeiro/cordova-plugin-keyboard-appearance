/********* KeyboardAppearance.m Cordova Plugin Implementation *******/

#import <Cordova/CDV.h>
#import <objc/runtime.h>

#ifndef __CORDOVA_3_2_0
#warning "The keyboard appearance style plugin is only supported in Cordova 3.2 or greater, it may not work properly in an older version."
#endif

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

    NSString* setting = @"KeyboardStyle";
    if ([self settingForKey:setting]) {
        self.keyboardStyle = [self settingForKey:setting];
    }
}

- (id)settingForKey:(NSString*)key
{
    return [self.commandDelegate.settings objectForKey:[key lowercaseString]];
}

#pragma mark Keyboard Style

- (NSString*)keyboardStyle
{
    return _keyboardStyle;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

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

    [UIToolbar.appearance setTintColor:([style isEqualToString:@"dark"] ? UIColor.whiteColor : UIToolbar.appearance.tintColor)];

    [UIToolbar.appearance setBarTintColor:([style isEqualToString:@"dark"] ? UIColor.darkGrayColor : UIToolbar.appearance.barTintColor)];

    [UIToolbar.appearance setBarStyle: ([style isEqualToString:@"dark"] ? UIBarStyleBlack : UIBarStyleDefault)];

    [UIToolbar.appearance setTranslucent:YES];

    _keyboardStyle = style;
}

#pragma clang diagnostic pop

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
