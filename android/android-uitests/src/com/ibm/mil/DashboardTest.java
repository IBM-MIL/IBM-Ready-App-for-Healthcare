package com.ibm.mil;

import io.selendroid.SelendroidLauncher;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

// TODO: The android hybrid test (this one) is currently 
// broken due to an incompatibility issue with Selendroid and the 
// latest version of Cordova. There is an issue opened on the 
// Selendroid github: https://github.com/selendroid/selendroid/issues/658

public class DashboardTest {
	private static SelendroidLauncher selendroidServer = null;
	private static WebDriver driver = null;
	private static AndroidUtilities utils = new AndroidUtilities();

	@BeforeClass
	public static void startSelendroidServer() throws Exception {
		selendroidServer = utils.androidTestSetupSelendroid(selendroidServer);
	}
	
	@Before
	public void setupSelendriod() throws Exception {
		driver = utils.androidTestSetupWebDriver(driver);
	}

	@After
	public void refreshSelendroidDriver() {
		utils.androidTestTeardownDriver(driver);
	}
	@AfterClass
	public static void stopSelendroidServer() {
		utils.androidTestTeardownServer(selendroidServer);
	}
	// TODO: This test currently tests that the web elements exist on the page.
	// As the
	// application is fleshed out more, this test should become more robust IE
	// testing that the 'Get Started' button is clickable and takes the user to
	// the correct screen

	@Test
	public void test1() {
		WebElement user = utils.waitForElement(driver, "patient_id");
		WebElement password = utils.waitForElement(driver, "password");

		user.sendKeys("user1");
		password.sendKeys("password1");
		//Assuming the software keyboard is open.  This REQUIRES you UNCHECK the "hardware keyboard preset" in your
		//Android emulators when you create them.
		utils.closeKeyboard(driver);
		
		// Select the login button
		WebElement loginButton = utils.waitForElement(driver, "login_button");
		loginButton.click();

		// Wait for next page to load
		try { Thread.sleep(4000); } catch (InterruptedException e) {}

		// Select the webview
		WebElement web = utils.waitForElement(driver, "webview");
		web.click();

		// now that a webview is displayed, switch to web mode.
		driver.switchTo().window("WEBVIEW");

		// Check that the date field exists
		WebElement date = utils.waitForElement(driver, "c");
		Assert.assertNotNull("Date Field exists", date);

		// Check that the minutes field exists
		WebElement minutes = utils.waitForElement(driver, "f");
		Assert.assertNotNull("Minutes Field exists", minutes);

		// Check that the minutes label field exists
		WebElement minutesLabel = utils.waitForElement(driver, "g");
		Assert.assertNotNull("Minutes Label field exists", minutesLabel);

		// Check that the exercises field exists
		WebElement exercises = utils.waitForElement(driver, "i");
		Assert.assertNotNull("Exercises Field exists", exercises);

		// Check that the exercises label field exists
		WebElement exercisesLabel = utils.waitForElement(driver, "j");
		Assert.assertNotNull("Exercises Label field exists", exercisesLabel);

		// Check that the sessions field exists
		WebElement sessions = utils.waitForElement(driver, "l");
		Assert.assertNotNull("Sessions Field exists", sessions);

		// Check that the sessions label field exists
		WebElement sessionsLabel = utils.waitForElement(driver, "m");
		Assert.assertNotNull("Sessions Label field exists", sessionsLabel);

		// TODO: Check that the Get Started button exists  As the app grows, we
		// will want to check that this is clickable.
		WebElement getStarted = utils.waitForElement(driver, "n");
		Assert.assertNotNull("Get Started field exists", getStarted);

	}

}