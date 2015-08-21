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

public class PainReportTest {
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
	@Test
	public void incorrectLoginTest() {
		// Check that the invalid ID message displays as expected when no ID is
		// entered.
		// Select the login button
		//WebElement loginButton = utils.waitForElement(driver, "login_button");
		// Click the login button
		//loginButton.click();

		WebElement invalidIDLoginFailure = utils.waitForElement(driver, "invalid_id");
		Assert.assertNotNull(
				"Invalid ID message exists, so login is unsuccessful",
				invalidIDLoginFailure);

		// Check that the invalid password message displays as expected when
		// correct ID but incorrect password is entered

		WebElement user = utils.waitForElement(driver, "patient_id");
		user.click();
		utils.closeKeyboard(driver);

		WebElement password = utils.waitForElement(driver, "password");
		password.click();
		password.sendKeys("incorrectPassword");
		utils.closeKeyboard(driver);
		
		// Select the login button
		WebElement loginButton2 = utils.waitForElement(driver, "login_button");
		loginButton2.click();
		

		WebElement invalidPasswordLoginFailure = utils.waitForElement(driver, "invalid_password");
		Assert.assertNotNull("Invalid ID message exists, so login is unsuccessful",
				invalidPasswordLoginFailure);

	}
}
