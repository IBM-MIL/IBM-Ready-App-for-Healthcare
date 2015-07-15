/*
* Licensed Materials - Property of IBM
* 5725-I43 (C) Copyright IBM Corp. 2006, 2013. All Rights Reserved.
* US Government Users Restricted Rights - Use, duplication or
* disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
*/

#define _WLGeoAcquisitionPolicy_H_
#import <Foundation/Foundation.h>

/**
* @ingroup geo
* The class controls how Geo positions will be acquired.
* <p>
* The setters of this class return a reference to this object so as to enable chaining calls. 
*/
@interface WLGeoAcquisitionPolicy : NSObject  <NSCopying> {
	@private
	long long maximumAge;
	long long timeout;
	BOOL enableHighAccuracy;
	int desiredAccuracy;
	int minChangeDistance;
	int minChangeTime;
}

/**
 * This method initializes the geographical position.
 *
 * @param None.
 **/
- (id) init  ;
+ (void) initialize  ;

/**
     * Used to save power. Accurate location information is not provided.
     *
     * @param None.
	 * @return a policy with the following preset values:
	 * <ul>
	 *   <li><code>enableHighAccuracy = false</code></li>
	 *   <li><code>minChangeTime = 300000</code> (5 minutes)</li>
	 *   <li><code>minChangeDistance = 1000</code> (1 kilometer)</li>
	 *   <li><code>maximumAge = 300000</code> (5 minutes)</li>
	 * </ul>
	 */
+ (WLGeoAcquisitionPolicy*) getPowerSavingProfile  ;
/**
      * Used to track devices, but at a rough granularity.
      *
      * @param None.
      * @return a policy with the following preset values:
      * <ul>
      *   <li><code>enableHighAccuracy = true</code></li>
      *   <li><code>desiredAccuracy = 200</code> (200 meters)</li>
      *   <li><code>minChangeTime = 30000</code> (30 seconds)</li>
      *   <li><code>minChangeDistance = 50</code> (50 meters)</li>
      *   <li><code>maximumAge = 60000</code> (60 seconds)</li>
      * </ul>
      */
+ (WLGeoAcquisitionPolicy*) getRoughTrackingProfile  ;

/**
      * This method is used to track devices, and get the best position information available.
      *
      * @param None.
      * @return a policy with the following preset values:
      * <ul>
      *   <li><code>enableHighAccuracy = true</code></li>
      *   <li><code>maximumAge = 100</code> (100 milliseconds)</li>
      * </ul>
      **/
+ (WLGeoAcquisitionPolicy*) getLiveTrackingProfile  ;

/**
 * This method returns the maximum age value. A cached position can be returned from the acquisition if the age of that position is less than the returned value. The default and minimum value is 100 milliseconds.
 *
 * @param None.
 * @return the maximum age. 
 **/
- (double) getMaximumAge  ;

/**
 * This method sets the maximum age of positions returned, in milliseconds. A cached position can be returned from the acquisition if the age of that position is less than the specified value. The default and minimum value is 100 milliseconds.
 *
 * @param maximumAge The maximum age value.
 * @return A reference to this object.
 **/
- (WLGeoAcquisitionPolicy*) setMaximumAge : (long long) maximumAge ;

/**
 * This method returns the duration, in milliseconds, that the policy waits for acquisitions before a {@link WLGeoError} value is sent. A value of -1 is used to indicate an infinite timeout. -1 is the default value.
 *
 * @param None.
 * @return the duration, in milliseconds.
 **/
- (long long) getTimeout  ;

/**
 * This method sets the duration, in milliseconds, that the policy waits for acquisitions. The default value is -1 which indicates an infinite timeout.
 *
 * If no position is acquired since the last position was acquired, or since the {@link WLDevice#startAcquisition(com.worklight.location.api.WLLocationServicesConfiguration)} class was called, a failure function is called.
 *
 * @param timeout The timeout interval for position acquisitions, in milliseconds.
 * @return A reference to this object.
 **/
- (WLGeoAcquisitionPolicy*) setTimeout : (long long) timeout ;

/**
 * If it is possible to obtain high-accuracy measurements, for example by using GPS, this method returns the Boolean value true. Otherwise it returns the value false.
 *
 * @param None.
 * @return true if it is possible to obtain high-accuracy measurements, for example by using GPS.
 **/
- (BOOL) isEnableHighAccuracy  ;

/**
 * This method controls whether it is possible to obtain high-accuracy measurements, for example by using GPS. When the Boolean value <code>true</code> is returned, the value of <code>getDesiredAccuracy</code> is taken into account.
 *
 * @param enableHighAccuracy The <code>setEnableHighAccuracy<code> setting.
 * @return A reference to this object.
 **/
- (WLGeoAcquisitionPolicy*) setEnableHighAccuracy : (BOOL) enableHighAccuracy ;

/**
 * This method returns the accuracy that you want in meters. This value is taken into account only when {@link #isEnableHighAccuracy()} returns <code>true</code>.
 *
 * @param None.
 * @return the accuracy that you want in meters.
 **/
- (int) getDesiredAccuracy  ;

/**
 * This method sets the accuracy that you want in meters. The accuracy that you want is only taken into account when {@link #isEnableHighAccuracy()} returns <code>true</code>.
 *
 * @param desiredAccuracy The desired accuracy setting.
 * @return A reference to this object.
 **/
- (WLGeoAcquisitionPolicy*) setDesiredAccuracy : (int) desiredAccuracy ;

/**
 * This method returns the minimum distance in meters that the position must change by, since the last update, in order to receive a new updated position. The default value is 0.
 *
 * @param None.
 * @return the minimum distance in meters.
 **/
- (int) getMinChangeDistance  ;

/**
 * This method sets the minimum distance in meters that the position must change by, since the last update, in order to receive a new updated position. Higher values can improve battery life,although the effect is generally less than that of {@link #setMinChangeTime(int)}. The default value is 0.
 *
 * @param minChangeDistance The minimum distance in meters that the position must change by, since the last update, in order to receive a new updated position.
 * @return A reference to this object.
 **/

- (WLGeoAcquisitionPolicy*) setMinChangeDistance : (int) minChangeDistance ;
/**
	 * @return the minimum time in milliseconds between updates. The default value is 0.
	 */
- (int) getMinChangeTime  ;
/**
	 * The minimum time in milliseconds between updates. Higher values can improve battery life.
	 * @return A reference to this object.
	 */
- (WLGeoAcquisitionPolicy*) setMinChangeTime : (int) minChangeTime ;
- (WLGeoAcquisitionPolicy*) clone  ;
/*
	 * (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
- (int) hash  ;
/*
	 * (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
- (BOOL) isEqual : (NSObject*) obj ;

@end



