//
//  HomeView.m
//  PushNotificationTool
//
//  Created by Mulla, Farooq on 11/15/14.
//  Copyright (c) 2014 Mulla. All rights reserved.
//


#import "HomeView.h"
#import <JavaVM/JavaVM.h>
#import <JavaVM/jni.h>
#import <JavaNativeFoundation/JNFJNI.h>
#import <JavaNativeFoundation/JavaNativeFoundation.h>

NSString *const kHomeWindowControllerAlertMessage = @"Please enter all required fields.";
NSString *const kHomeWindowControllerAlertCancelButtonTitle = @"OK";


JNIEXPORT jobject JNICALL Java_MyRejectedNotificationListener_showMessage
(JNIEnv *, jobject, jstring);
JNIEXPORT jobject JNICALL Java_MyFailedConnectionListener_showMessage
(JNIEnv *, jobject, jstring);

@interface HomeView ()

@property (nonatomic, weak) IBOutlet NSTextField *textFieldPopUpActionKeys;
@property (nonatomic, weak) IBOutlet NSTextField *textFieldFilePath;
@property (nonatomic, weak) IBOutlet NSSecureTextField *passwordSecureTextField;
@property (nonatomic, weak) IBOutlet NSTextField *texFieldDeviceToken;
@property (nonatomic, weak) IBOutlet NSTextField *textFieldBadgeNumber;
@property (nonatomic, weak) IBOutlet NSTextField *textFieldURLScheme;
@property (nonatomic, weak) IBOutlet NSTextField *textFieldAlertMessage;
@property (nonatomic, weak) IBOutlet NSButton *btnQuit;
@property (nonatomic, weak) IBOutlet NSButton *btnPush;
- (IBAction)btnBrowseClicked:(id)sender;
- (IBAction)pushButtonClicked:(id)sender;
- (IBAction)quitButtonClicked:(id)sender;

@end

@implementation HomeView

//-----------------
//NSOpenPanel: Displaying a File Open Dialog in OS X 10.x
//-----------------
- (IBAction)btnBrowseClicked:(id)sender
{
    // Loop counter.
    int i;
    // Create a File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    // Set array of file types
    NSArray *fileTypesArray;
    fileTypesArray = [NSArray arrayWithObjects:@"p12", nil];
    
    // Enable options in the dialog.
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowedFileTypes:fileTypesArray];
    [openDlg setAllowsMultipleSelection:NO];
    
    // Display the dialog box.  If the OK pressed,
    // process the files.
    if ( [openDlg runModal] == NSOKButton )
    {
        // Gets list of all files selected
        NSArray *files = [openDlg URLs];
        // Loop through the files and process them.
        for( i = 0; i < [files count]; i++ )
        {
            // Display file path to user.
            [_textFieldFilePath setStringValue:[[files objectAtIndex:i] path]];
        }
    }
    
}

- (IBAction)pushButtonClicked:(id)sender
{
    NSString *path = [_textFieldFilePath stringValue];
    NSString *password = [_passwordSecureTextField stringValue];
    NSString *deviceToken = [_texFieldDeviceToken stringValue];
    NSString *badgeNumber = [_textFieldBadgeNumber stringValue];
    NSString *alertBody = [_textFieldAlertMessage stringValue];

    if([path length] > 0 && [password length] > 0 && [deviceToken length] > 0 && [badgeNumber length] > 0 && [alertBody length] > 0)
    {
        [self accessJavaClass];
    }
    else
    {
    }
}

- (IBAction)quitButtonClicked:(id)sender
{
    [[NSApplication sharedApplication] terminate:nil];
}


JNIEXPORT jobject JNICALL Java_MyRejectedNotificationListener_showMessage
(JNIEnv *env, jobject thisObject, jstring js)
{
    return NULL;
}

JNIEXPORT jobject JNICALL Java_MyFailedConnectionListener_showMessage
(JNIEnv *env, jobject thisObject, jstring js)
{
    return NULL;
}

- (void) accessJavaClass
{
    static JavaVM* jvm = NULL;
    JNIEnv* env = NULL;
    int envError;
    
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jar" inDirectory:@"Java"];
    NSMutableString *completePath = [[NSMutableString alloc]initWithString:@"-Djava.class.path=$CLASSPATH"];
    for (NSString *string in paths) {
        [completePath appendFormat:@":%@",string];
    }
    const char *command = [completePath UTF8String];
    
    JavaVMOption options;
    options.optionString = (char *)command;
    
    JavaVMInitArgs args;
    args.version = JNI_VERSION_1_6;
    args.options = &options;
    args.nOptions = 1;
    args.ignoreUnrecognized = 0;
    
    if(!jvm)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        envError = JNI_CreateJavaVM(&jvm, (void**) &env, &args);
#pragma clang diagnostic pop
        
    }
    else
    {
        envError = JNI_OK;
    }
    
    if (envError == JNI_OK)
    {
        jclass pushNotificationClass = NULL;
        @try {
            if ((*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL)== JNI_OK)
            {
                pushNotificationClass = (*env)->FindClass(env, "main/mulla/pushy/PushNotificationTool");
                JNFClassInfo classInfo;
                classInfo.name = "PushNotification";
                classInfo.cls = pushNotificationClass;
                
                if (pushNotificationClass != nil)
                {
                    NSLog(@"Accessed");
                    
                    jmethodID pushMethodID = (*env)->GetStaticMethodID(env, pushNotificationClass, "Push", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
                    
                    JNFMemberInfo pushMethod;
                    pushMethod.name = "Push";
                    pushMethod.name = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V";
                    pushMethod.isStatic = YES;
                    pushMethod.classInfo = &classInfo;
                    pushMethod.j.methodID = pushMethodID;
                    
                    NSString *path = [_textFieldFilePath stringValue];
                    NSString *password = [_passwordSecureTextField stringValue];
                    NSString *deviceToken = [_texFieldDeviceToken stringValue];
                    NSString *badgeNumber = [_textFieldBadgeNumber stringValue];
                    NSString *alertBody = [_textFieldAlertMessage stringValue];
                    NSString *soundFile = [_textFieldURLScheme stringValue];
                    NSString *actionKey = [_textFieldPopUpActionKeys stringValue];
                    
                    jstring jPath = JNFNSToJavaString(env, path);
                    jstring jPassword = JNFNSToJavaString(env,password);
                    jstring jdeviceToken = JNFNSToJavaString(env,deviceToken);
                    jstring jbadgeNumber = JNFNSToJavaString(env,badgeNumber);
                    jstring jalertBody = JNFNSToJavaString(env,alertBody);
                    jstring jsoundFile = JNFNSToJavaString(env,soundFile);
                    jstring jactionKey = JNFNSToJavaString(env,actionKey);
                    
                    (*env)->ExceptionClear(env);
                    JNFCallStaticVoidMethod(env, &pushMethod, jPath, jPassword, jdeviceToken, jbadgeNumber, jalertBody, jsoundFile, jactionKey);
                }
                else
                {
                    NSLog(@"Not Accessed");
                }
                
                (jvm[0])->DetachCurrentThread(jvm);

            }
        }
        @catch (NSException *exception) {
            NSLog(@"@catch BLOCK:-Exception Occured: %@",exception);
        }
        @finally {
            NSLog(@"@finally BLOCK:-");
//            (*env)->DeleteLocalRef(env,pushNotificationClass);
            
        }
    }
    else
    {
        
    }
}

/*
- (void) accessJavaClass
{
    static JavaVM* jvm = NULL;
    JNIEnv* env = NULL;
    int envError;

    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jar" inDirectory:@"Java"];
    NSMutableString *completePath = [[NSMutableString alloc]initWithString:@"-Djava.class.path=$CLASSPATH"];
    for (NSString *string in paths) {
        [completePath appendFormat:@":%@",string];
    }
    const char *command = [completePath UTF8String];

    JavaVMOption options;
    options.optionString = (char *)command;
    
    JavaVMInitArgs args;
    args.version = JNI_VERSION_1_6;
    args.options = &options;
    args.nOptions = 1;
    args.ignoreUnrecognized = 0;
    
    if(!jvm)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        envError = JNI_CreateJavaVM(&jvm, (void**) &env, &args);
#pragma clang diagnostic pop

    }
    else
    {
        envError = JNI_OK;
    }
    
    if (envError == JNI_OK)
    {
        if ((*jvm)->AttachCurrentThread(jvm, (void**)&env, NULL)== JNI_OK)
        {
            jclass pushNotificationClass = (*env)->FindClass(env, "main/mulla/pushy/PushNotificationTool");
            JNFClassInfo classInfo;
            classInfo.name = "PushNotification";
            classInfo.cls = pushNotificationClass;
            
            if (pushNotificationClass != nil)
            {
                NSLog(@"Accessed");
                
                jmethodID pushMethodID = (*env)->GetStaticMethodID(env, pushNotificationClass, "Push", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
                
                JNFMemberInfo pushMethod;
                pushMethod.name = "Push";
                pushMethod.name = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V";
                pushMethod.isStatic = YES;
                pushMethod.classInfo = &classInfo;
                pushMethod.j.methodID = pushMethodID;

                NSString *path = [_textFieldFilePath stringValue];
                NSString *password = [_passwordSecureTextField stringValue];
                NSString *deviceToken = [_texFieldDeviceToken stringValue];
                NSString *badgeNumber = [_textFieldBadgeNumber stringValue];
                NSString *alertBody = [_textFieldAlertMessage stringValue];
                NSString *soundFile = [_textFieldURLScheme stringValue];
                NSString *actionKey = [_textFieldPopUpActionKeys stringValue];

                jstring jPath = JNFNSToJavaString(env, path);
                jstring jPassword = JNFNSToJavaString(env,password);
                jstring jdeviceToken = JNFNSToJavaString(env,deviceToken);
                jstring jbadgeNumber = JNFNSToJavaString(env,badgeNumber);
                jstring jalertBody = JNFNSToJavaString(env,alertBody);
                jstring jsoundFile = JNFNSToJavaString(env,soundFile);
                jstring jactionKey = JNFNSToJavaString(env,actionKey);

                JNFCallStaticVoidMethod(env, &pushMethod, jPath, jPassword, jdeviceToken, jbadgeNumber, jalertBody, jsoundFile, jactionKey);
                
                (*env)->DeleteLocalRef(env,pushNotificationClass);
            }
            else
            {
                NSLog(@"Not Accessed");
            }
            
            (jvm[0])->DetachCurrentThread(jvm);
        }
    }
}
*/
@end
