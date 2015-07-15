/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLDevice_H_
#import <Foundation/Foundation.h>
@class WLGeoAcquisitionPolicy;
@class WLLocationServicesConfiguration;
@class WLWifiAcquisitionPolicy;
@protocol WLDeviceContext;
@protocol WLGeoCallback;
@protocol WLGeoFailureCallback;
@protocol WLWifiAcquisitionCallback;
@protocol WLWifiConnectedCallback;
@protocol WLWifiFailureCallback;

/**
 * @ingroup geo
 * This protocol provides access to the device’s context, which provides access to the acquired location information. This protocol also can be used to acquire location information.
 */
@protocol WLDevice <NSObject> 

/**
     * @short getLocationServicesConfig This method returns the current location services configuration. 
     *
     * @param None.
	 * @return The current location services configuration.
	 */
- (WLLocationServicesConfiguration*) getLocationServicesConfig  ;

/**
      * Starts ongoing acquisition for sensors that are provided in the newConfiguration policy.
      * <p>
      * Ongoing acquisition is started for the Geo and WiFi sensors that are provided in the policy. When new sensor information is acquired, the device context is updated, and the specified triggers are evaluated for activation.
      * <p>
      * After calling this method, {@link #getLocationServicesConfig()} will return <code>newConfiguration</code>
      * @see <a href="http://infocenter.francelab.fr.ibm.com:1234/help/index.jsp?topic=%2Fcom.ibm.worklight.help.doc%2Fapiref%2Fr_wl_location.html">LocationServices</a> for details of the permissions that are required for Android and iOS.

	 * @param newConfiguration the configuration to use, specifying acquisition policy, trigger configuration and failure callbacks. Changes made to it after calling this method
	 *        will not modify the runtime behavior unless the object is passed again in a new call to this method.
	 *        
	 * @see #getDeviceContext()
	 */
- (void) startAcquisition : (WLLocationServicesConfiguration*) newConfiguration ;
/**
      * Stops the ongoing acquisition. The stop action is delegated to all relevant sensors, and all trigger states are cleared.
	  *     
      * @param None.
      */
- (void) stopAcquisition  ;
/** 
      * Acquires a geographical position.
      * <p>
      * The device attempts to acquire a geographical position. This attempt could be based on geo-location data acquired by the device, or it could involve the use of WiFi. If the attempt is successful, the following actions take place:
      * <ul>
      * <li>The device context might be updated. This action is dependent on the freshness of the data in the context, and the new position data being at least as accurate as the existing position data.</li>
      * <li>The <b><code>onSuccess</code></b> function is invoked.</li>
      * <li>If the device context was updated, triggers might be activated.</li></ul>
      * </p>
      * <p>
      * <b>Note:</b> Because <code>acquireGeoPosition</code> might activate triggers, you should not call <code>acquireGeoPosition</code> from a trigger callback. 
      *        Potentially, this could cause an endless loop of trigger evaluations leading to callbacks leading to <code>acquireGeoPosition</code> calls.
      * @see  <a href="http://infocenter.francelab.fr.ibm.com:1234/help/index.jsp?topic=%2Fcom.ibm.worklight.help.doc%2Fapiref%2Fr_wl_location.html">Location Services</a> for details of the permissions required for Android and iOS.
      * </p>
      * @param onSuccess A callback function that is invoked when a position is acquired successfully. The position is passed as a parameter to the callback function.
      * @param onFailure A callback function that is invoked when the position is not acquired successfully. The error is passed as a parameter to the callback function.
      * @param geoPolicy The policy that is used to configure the acquisition.
      */
- (void)acquireGeoPositionWithDelegate:(id<WLGeoCallback>)onSuccess failureDelegate:(id<WLGeoFailureCallback>)onFailure policy:(WLGeoAcquisitionPolicy*)geoPolicy;
/**
      * Acquires the currently visible access points.
      * <p>
      * The device attempts to acquire the currently visible access points. If the attempt is successful, and ongoing WiFi acquisition is enabled (using WL.Device.startAcquistion), the following actions take place:
      *   <ol> 
      *             <li> The device context is updated.</li> 
      *             <li> An <code>onSuccess</code> callback is performed. </li>
      *             <li>Triggers are activated.</li></ol>
      * If there is no ongoing WiFi acquisition, only the <code>onSuccess</code> callback function is called.
      * </p>
      * <p>
      * <b>Note</b>: Because <code>acquireVisibleAccessPoints</code> might activate triggers, you must be careful when calling <code>acquireVisibleAccessPoints</code> from a trigger callback. 
      *                  Potentially, this could cause an endless loop of trigger evaluations leading to callbacks leading to <code>acquireVisibleAccessPoints</code> calls.
      *</p>
      * @see <a href="http://infocenter.francelab.fr.ibm.com:1234/help/index.jsp?topic=%2Fcom.ibm.worklight.help.doc%2Fapiref%2Fr_wl_location.html">Location Services</a> for details of the permissions required for Android and iOS  
      * @param onSuccess A callback function that is invoked when the visible access points are acquired successfully. The appropriate WiFi access points list, filtered according to the provided policy setting, is passed as a parameter to this function.
      * @param onFailure A callback function that is invoked if the acquisition is unsuccessful.
      * @param wifiPolicy The policy that is used to configure the acquisition.               
      */
- (void)getConnectedAccessPointFilteredByPolicy:(WLWifiAcquisitionPolicy*)wifiPolicy withDelegate:(id<WLWifiAcquisitionCallback>)onSuccess failureDelegate:(id<WLWifiFailureCallback>)onFailure;
/**
     * Acquires the currently connected WiFi access point information.
	 * <p>
	 * The device attempts to acquire the currently connected WiFi access point information. If the attempt is successful, the access point
	 * information is passed to the <code>onSuccess</code> callback function.
	 * @see <a href="http://infocenter.francelab.fr.ibm.com:1234/help/index.jsp?topic=%2Fcom.ibm.worklight.help.doc%2Fapiref%2Fr_wl_location.html">Location Services</a> for details of the permissions required for Android and iOS 
	 * @param onSuccess A callback function that is invoked when access point connection information is acquired successfully. The acquisition result is passed as a parameter to this function.
	 * @param onFailure A callback function that is invoked if the acquisition is unsuccessful. 
	 */
- (void)getConnectedAccessPointWithDelegate:(id<WLWifiConnectedCallback>)onSuccess failureDelegate:(id<WLWifiFailureCallback>)onFailure;
/**
     * This method returns the current device context, which contains information about the acquired locations.
     *
     * @param None.
	 * @return The current device context, containing information about the acquired locations.
	 */
- (id<WLDeviceContext>) getDeviceContext  ;

@end

