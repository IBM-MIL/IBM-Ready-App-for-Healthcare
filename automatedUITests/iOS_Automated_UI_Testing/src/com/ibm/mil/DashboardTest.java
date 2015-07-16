package com.ibm.mil;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;

public class DashboardTest {
	private static RemoteWebDriver driver;
	private static IosUtilities utils = new IosUtilities();
	private static SignInUtilities signInUtils = new SignInUtilities();

	@Before
	public void setup() throws Exception {
		driver = (RemoteWebDriver) utils.iosTestSetupWebDriver(driver);
	}

	@Test
	public void testDashboard() throws Exception {
		
		//call the sign in and permission utility
		signInUtils.SignInAndPermissionUtilities(driver);
		
		// Wait for next page to load, aka the ouch icon button is present
		utils.waitForElement(driver, "ouch icon");
		
		for (String handle : driver.getWindowHandles()) {
			System.out.println(handle);
		}

		// Select the webview
		WebElement web = driver.findElement(By.xpath("//UIAWebView"));
		web.click();

		// now that a webview is displayed, switch to web mode.
		driver.switchTo().window("Web_1");

		// Check that the date field exists
		WebElement date = driver.findElement(By.id("c"));
		Assert.assertNotNull("Date Field exists", date);

		// Check that the minutes field exists
		WebElement minutes = driver.findElement(By.id("f"));
		Assert.assertNotNull("Minutes Field exists", minutes);

		// Check that the minutes label field exists
		WebElement minutesLabel = driver.findElement(By.id("g"));
		Assert.assertNotNull("Minutes Label field exists", minutesLabel);

		// Check that the exercises field exists
		WebElement exercises = driver.findElement(By.id("i"));
		Assert.assertNotNull("Exercises Field exists", exercises);

		// Check that the exercises label field exists
		WebElement exercisesLabel = driver.findElement(By.id("j"));
		Assert.assertNotNull("Exercises Label field exists", exercisesLabel);

		// Check that the sessions field exists
		WebElement sessions = driver.findElement(By.id("l"));
		Assert.assertNotNull("Sessions Field exists", sessions);

		// Check that the sessions label field exists
		WebElement sessionsLabel = driver.findElement(By.id("m"));
		Assert.assertNotNull("Sessions Label field exists", sessionsLabel);

		// TODO: Check that the Get Started button exists – As the app grows, we
		// will want to check that this is clickable.
		WebElement getStarted = driver.findElement(By.id("n"));
		Assert.assertNotNull("Get Started field exists", getStarted);

	}

	@After
	public void stop() {
		// Close the session
		utils.iosTestTeardownDriver(driver);
	}
}