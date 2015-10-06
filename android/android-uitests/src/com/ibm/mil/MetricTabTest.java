package com.ibm.mil;

import io.selendroid.SelendroidKeys;
import io.selendroid.SelendroidLauncher;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;

public class MetricTabTest {
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



	// TODO: This test currently tests that the metric tabs exist. As the
	// application is fleshed out more, this test should become more robust

	@Test
	public void test1() {
		WebElement user = utils.waitForElement(driver, "patient_id");
		WebElement password = utils.waitForElement(driver, "password");
		user.sendKeys("user1");
		password.sendKeys("password1");
System.out.println("got here1");
		// Select the login button
		WebElement loginButton = utils.waitForElement(driver, "login_button");
		System.out.println("got here2" + loginButton);
		new Actions(driver).sendKeys(SelendroidKeys.BACK).perform();
		loginButton.click();

System.out.println("got here3");
		// Wait for next page to load
		try {
			Thread.sleep(2000);
			System.out.println("got here4");
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			System.out.println("got here5");
			e.printStackTrace();
		}

System.out.println("got here6");
		WebElement metricsTabs = utils.waitForElement(driver, "metrics_tabs_area");
		System.out.println("got here7");
		Assert.assertNotNull("Metrics tabs area exists", metricsTabs);
	}

}