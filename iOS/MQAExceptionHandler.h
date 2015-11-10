//
//  MQAExceptionHandler.h
//  Healthcare
//
//  Created by Harrison Saylor on 11/10/15.
//
//

#ifndef MQAExceptionHandler_h
#define MQAExceptionHandler_h

volatile void exceptionHandler(NSException *exception);
extern NSUncaughtExceptionHandler *exceptionHandlerPointer;

#endif /* MQAExceptionHandler_h */
