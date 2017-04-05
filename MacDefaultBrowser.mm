#include <node.h>
#include <v8.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

NSArray* getUrlSchemeRefs () {
    return [[NSArray alloc] initWithObjects:@"http", @"https", nil];
}

/**
 * in javascript: module.getDefaultBrowser()
 */
void getDefaultBrowser(const v8::FunctionCallbackInfo<v8::Value>& args) {
    @autoreleasepool {
        v8::Isolate* isolate = v8::Isolate::GetCurrent();
        v8::HandleScope scope(isolate);

        if (args.Length() != 0) {
            isolate->ThrowException(v8::Exception::Error(
                v8::String::NewFromUtf8(isolate, "This function does not accept any argument"))
            );
            return;
        }

        NSString *currentHandler = (__bridge NSString *) LSCopyDefaultHandlerForURLScheme(
            (__bridge CFStringRef)([getUrlSchemeRefs() objectAtIndex:0])
        );


        args.GetReturnValue().Set(
            v8::String::NewFromUtf8(isolate, [currentHandler cStringUsingEncoding:NSUTF8StringEncoding])
        );
    }
}

/**
 * in javascript: module.setDefaultBrowser(appId)
 */
void setDefaultBrowser(const v8::FunctionCallbackInfo<v8::Value>& args) {
    @autoreleasepool {
        v8::Isolate* isolate = v8::Isolate::GetCurrent();
        v8::HandleScope scope(isolate);

        if (args.Length() != 1) {
            isolate->ThrowException(v8::Exception::Error(
                v8::String::NewFromUtf8(isolate, "This function does not accept any argument"))
            );
            return;
        }

        v8::String::Utf8Value v8AppId(args[0]->ToString());
        NSString *appId = [NSString stringWithCString:*v8AppId encoding:NSUTF8StringEncoding];

        CFStringRef newHandler = (__bridge CFStringRef)(appId);

        bool result = true;
        for (NSString *urlScheme in getUrlSchemeRefs()) {
            OSStatus s = LSSetDefaultHandlerForURLScheme((__bridge CFStringRef)(urlScheme), newHandler);
            if (s > 0) {
                printf("Error (%d) while setting handler for protocol '%s'", (int)s, [urlScheme cStringUsingEncoding:NSUTF8StringEncoding]);
                result = false;
            }
        }

        args.GetReturnValue().Set(v8::Boolean::New(isolate, result));
    }
}

void init(v8::Handle<v8::Object> target) {
    NODE_SET_METHOD(target, "getDefaultBrowser", getDefaultBrowser);
    NODE_SET_METHOD(target, "setDefaultBrowser", setDefaultBrowser);
}

NODE_MODULE(binding, init);
