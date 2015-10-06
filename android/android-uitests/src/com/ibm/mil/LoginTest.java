package com.ibm.mil;

import io.selendroid.SelendroidLauncher;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class LoginTest {
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
	
	// This test will test that unsuccessful login attempts act as expected.

	@Test
	public void incorrectLoginTest() {
		// Check that the invalid ID message displays as expected when no ID is
		// entered.
		// Select the login button
		WebElement loginButton = utils.waitForElement(driver, "login_button");
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
		user.sendKeys("user1");
		utils.closeKeyboard(driver);

		WebElement password = utils.waitForElement(driver, "password");
		password.click();
		password.sendKeys("incorrectPassword");
		utils.closeKeyboard(driver);
		
		// Select the login button
		WebElement loginButton2 = utils.waitForElement(driver, "login_button");
		loginButton2.click();
		
		//By invalidPassword = By.id("invalid_password");
		WebElement invalidPasswordLoginFailure = utils.waitForElement(driver, "invalid_password");
		Assert.assertNotNull("Invalid ID message exists, so login is unsuccessful",
				invalidPasswordLoginFailure);
	}

	// This test will check that a user is successfully able to login with valid
	// credentials.

	@Test
	public void test2() {
		WebElement user = utils.waitForElement(driver, "patient_id");
		WebElement password = utils.waitForElement(driver, "password");

		user.sendKeys("user1");
		password.sendKeys("password1");

		// Select the login button
		WebElement loginButton = driver.findElement(By.id("login_button"));
		utils.closeKeyboard(driver);
		loginButton.click();
		
		WebElement metricsTabs = utils.waitForElement(driver, "metrics_tabs_area");
		Assert.assertNotNull("Metrics tabs area exists, so login is successful", metricsTabs);
		System.out.println("I did get to the end.");
	}

}