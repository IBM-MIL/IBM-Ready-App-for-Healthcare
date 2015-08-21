package com.ibm.mil;

import io.selendroid.SelendroidCapabilities;
import io.selendroid.SelendroidConfiguration;
import io.selendroid.SelendroidDriver;
import io.selendroid.SelendroidKeys;
import io.selendroid.SelendroidLauncher;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.Properties;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

public class AndroidUtilities {

	public static final String ENCODING = "UTF-8";
	public static final long OBJECT_LOAD_WAIT_TIME = 2000;
	public static final int OBJECT_LOAD_RETRIES = 15;
	public static final String PROPERTIES_FILE_NAME= "android.automated.testing.properties";
	public static final int DRIVER_RETRIES = 10;
	public static final int DRIVER_WAIT_TIME = 2000; //2 seconds
	
	private Properties androidProperties = null;
	
	public AndroidUtilities() {
		super();
		try {
			androidProperties = new Properties();
			File props = new File(PROPERTIES_FILE_NAME);
			System.out.println("Attempting to load test.properties file : " + props.getAbsolutePath());
			androidProperties.load(new BufferedReader(new InputStreamReader(new FileInputStream(props.getAbsolutePath()), ENCODING)));
		} catch(Exception ex) {
			System.out.println("Failed to open " + PROPERTIES_FILE_NAME + ", cannot continue.");
		}
	}

	private String getKeyValue(String key, String defaultValue) {
		//Using the value from the properties file, if its set, otherwise default to defaultValue.
		String value = androidProperties.containsKey(key) ? (String) androidProperties.get(key) : defaultValue;
		//If there is a system property set (using -D on the command line) hten lets use that instead.
		value = System.getProperty(key, value);
		return value;
	}
	
	//setup the selendroid server
	public SelendroidLauncher androidTestSetupSelendroid(SelendroidLauncher selendroidServer) throws Exception {
		String shouldStart = getKeyValue("SHOULD_START_SERVER", "true");
		if (!"false".equals(shouldStart))  {
			SelendroidConfiguration config = new SelendroidConfiguration();
			//if you want to set the specific port to start the server on, defaults to 4444 
			String portstr = getKeyValue("PORT", "4444");
			int port = 4444;
			try {
				port = Integer.parseInt(portstr);
			} catch (Exception ex) {
				//Do nothing as this will leave the port at the default 4444.
			}
			System.out.println("setting selendroidconfiguration port to: "  + port);
			config.setPort(port); 
			
			// Add the selendroid-test-app to the standalone server
			String defaultApp = getKeyValue("APPLICATION_PATH","/Users/atcabral/Ready.App.Physical.Therapist/platforms/android/build/outputs/apk/android-debug.apk");
			File app = new File (defaultApp);
			if (!app.isFile()) {
				System.out.println("Application provided does not exist: " + app.getAbsolutePath());
				System.exit(1);
			}
			
			System.out.println("Starting selendroid server with apk: " + defaultApp);
			config.addSupportedApp(defaultApp);
			selendroidServer = new SelendroidLauncher(config);
			selendroidServer.launchSelendroid();

			try { Thread.sleep(10000); } catch (InterruptedException e) { }
		}
		
		return selendroidServer;
	}
	
	//set up the web driver
	public WebDriver androidTestSetupWebDriver(WebDriver driver) throws Exception {
		String appName = getKeyValue("APP_NAME","com.ibm.mil.readyapps.physio");
		String appVersion = getKeyValue("APP_VERSION","1.0");
		//if you want to set the specific port to start the server on, defaults to 4444 
		String portstr = getKeyValue("PORT", "4444");
		int port = 4444;
		try {
			port = Integer.parseInt(portstr);
		} catch (Exception ex) {
			//Do nothing as this will leave the port at the default 4444.
		}
		System.out.println("setting selendroidconfiguration port to: "  + port);
		
		SelendroidCapabilities caps = new SelendroidCapabilities(appName + ":" + appVersion);
		String url = "http://localhost:" + port + "/wd/hub";
		System.out.println("Connecting to ios server at url: " + url + ", using appname: " + appName + 
				", and version: " + appVersion);
		for (int i = 0 ; i < AndroidUtilities.DRIVER_RETRIES ; ++i ) {
			try {
				driver = new SelendroidDriver(new URL(url), caps);
				break;
			} catch (Exception ex) {
				System.out.println("WebDriver creation failed, retrying, try " + (i+1) + " of " + AndroidUtilities.DRIVER_RETRIES);
				try { Thread.sleep(AndroidUtilities.DRIVER_WAIT_TIME) ; } catch (Exception sleepEx) {}
				if (i == (AndroidUtilities.DRIVER_RETRIES -1)) {
					System.out.println(ex.getMessage());
					throw ex;
				}
			}
		}
		
		try { Thread.sleep(5000); } catch (InterruptedException e) {}
		return driver;
	}

	public void androidTestTeardownDriver(WebDriver driver) {
		if (driver != null) {
			 try { driver.quit(); } catch (Exception ex) {}
		}
	}
	
	public void androidTestTeardownServer(SelendroidLauncher selendroidServer) {
		if (selendroidServer != null) {
			try { selendroidServer.stopSelendroid(); } catch (Exception ex) {}
		}
	}
	
	public WebElement waitForElement(WebDriver driver, String elementId) {
		WebElement elem = null;
		for (int i = 0 ; i < OBJECT_LOAD_RETRIES ; ++i ) {
			try {
				elem = driver.findElement(By.id(elementId));
				break;
			} catch (Exception ex) {
				System.out.println("Could not find element, trying. iterator: " + i + "of " + OBJECT_LOAD_RETRIES + 
						", elemid: " + elementId);
				if (i == (OBJECT_LOAD_RETRIES - 1)) {
					throw (ex);
				} else {
					try { Thread.sleep(OBJECT_LOAD_WAIT_TIME); } catch (Exception ex2) {}
				}
			}
		}
		return elem;
	}
	
	public void closeKeyboard(WebDriver driver) {
		try {
			new Actions(driver).sendKeys(SelendroidKeys.BACK).perform(); 
		} catch(Exception ex) {
			//lets swallow the exception.
		}
	}
} 