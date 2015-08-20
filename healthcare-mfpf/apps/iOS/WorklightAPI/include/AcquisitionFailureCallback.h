/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _AcquisitionFailureCallback_H_
#import <Foundation/Foundation.h>

@protocol AcquisitionFailureCallback <NSObject> 

/**
      * The method will be executed when an error occurs during acquisition.
      * @param errorObject the error that occurred.
      */
- (void) execute : (id) errorObject ;

@end

