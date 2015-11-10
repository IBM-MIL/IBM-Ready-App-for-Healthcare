//
//  MQAExceptionHandler.m
//  Healthcare
//
//  Created by Harrison Saylor on 11/10/15.
//
//

#import <Foundation/Foundation.h>

void exceptionHandler(NSException *exception) {}
NSUncaughtExceptionHandler *exceptionHandlerPointer = &exceptionHandler;