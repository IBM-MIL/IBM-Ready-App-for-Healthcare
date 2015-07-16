package com.ibm.mil;

import java.util.List;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;

public class TabTest {
	private static RemoteWebDriver driver;
	private static IosUtilities utils = new IosUtilities();
	private static SignInUtilities signInUtils = new SignInUtilities();

	@Before
	public void setup() throws Exception {
		driver = (RemoteWebDriver) utils.iosTestSetupWebDriver(driver);
	}

	@Test
	public void testTabAvailability() throws Exception {
		
		//sign in and accept all permissions
		signInUtils.SignInAndPermissionUtilities(driver);
		
		// Wait for next page to load, aka wait for the ouch icon to appear
		utils.waitForElement(driver, "ouch icon");
		//test the tabs

		//verify that the heart rate tab is there
		WebElement heart_tab = utils.waitForElement(driver, "heart_tab");
		//By heart_tab = By.linkText("name=heart_tab");
		Assert.assertNotNull(
				"Heart tab is not null, so it exists",
				heart_tab);
		
//		//verify that the calorie tab is there
//		WebElement calorie_tab = utils.waitForElement(driver, "calorie_tab");
//		//By calorie_tab = By.linkText("name=calorie_tab");
//		Assert.assertNotNull("Calorie tab is not null, so it exists", calorie_tab);
		
		//verify that the weight rate tab is there
		WebElement weight_tab = utils.waitForElement(driver, "weight_tab");
		//By weight_tab = By.linkText("name=weight_tab");
		Assert.assertNotNull("Calorie tab is not null, so it exists", weight_tab);
		
		//verify that steps tab is there
		WebElement steps_tab = utils.waitForElement(driver, "steps_tab");
		//By steps_tab = By.linkText("name=steps_tab");
		Assert.assertNotNull("Calorie tab is not null, so it exists", steps_tab);
		
		// Store the number of uiimages - each tab is a ui image plus the images on the tab bar
		List<WebElement> uiImages = driver.findElements(By
				.className("UIAImage"));
		Assert.assertEquals(8, uiImages.size());
	}
		
	@After
	public void stop() {
		// Close the session
		utils.iosTestTeardownDriver(driver);
	}
}