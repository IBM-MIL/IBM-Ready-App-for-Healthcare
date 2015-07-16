package com.ibm.mil;

import io.selendroid.SelendroidLauncher;

import java.util.List;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;

public class MenuTest {
	private static SelendroidLauncher selendroidServer = null;
	private static WebDriver driver = null;
	private static AndroidUtilities utils = new AndroidUtilities();

	@BeforeClass
	public static void startSelendroidServer() throws Exception {
		selendroidServer = utils.androidTestSetupSelendroid(selendroidServer);
	}
	
	@Before
	//set up selendroid
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
		utils.closeKeyboard(driver);

		// Select the login button
		WebElement loginButton = utils.waitForElement(driver, "login_button");
		loginButton.click();

		// Wait for next page to load
		try { Thread.sleep(3000); } catch (InterruptedException e) { }

		// Menu drawer compiles into an ImageButton, so collect all ImageButtons
		// in a list
		List<WebElement> imageButtons = driver.findElements(By.tagName("ImageButton"));

		// Open the menu
		WebElement menuDrawer = imageButtons.get(0);
		menuDrawer.click();

		// Wait for next page to load
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Check that the patient ID field exists
		WebElement patientID = utils.waitForElement(driver, "menu_patient_id");
		Assert.assertNotNull("Patient ID field exists, pass", patientID);

		// Check that the patient ID label field exists
		WebElement patientIdLabel = driver.findElement(By
				.id("menu_subtitle_patient_id"));
		Assert.assertNotNull("Patient ID label exists, pass", patientIdLabel);

		// Check that the next visit field exists
		WebElement nextVisit = utils.waitForElement(driver, "menu_next_visit");
		Assert.assertNotNull("Next visit field exists, pass", nextVisit);

		// Check that the next visit label field exists
		WebElement nextVisitLabel = driver.findElement(By
				.id("menu_subtitle_next_visit"));
		Assert.assertNotNull("Next visit label exists, pass", nextVisitLabel);

		// Check that the week field exists
		WebElement week = utils.waitForElement(driver, "menu_week");
		Assert.assertNotNull("Week field exists, pass", week);

		// Check that the next visit label field exists
		WebElement weekLabel = utils.waitForElement(driver, "menu_subtitle_week");
		Assert.assertNotNull("Week label exists, pass", weekLabel);

		// Collect all the elements in the menu list.
		List<WebElement> menuList = driver.findElements(By.id("row_text"));

		// Check that the Progess item exists
		WebElement progress = menuList.get(0);
		Assert.assertNotNull("Progress item exists, pass", progress);

		// TODO: as the app grows, this test needs to expand to verify that
		// clicking on Progress takes the user to the correct page
		progress.click();

		// Check that the Pain Management item exists
		WebElement painManagement = menuList.get(1);
		Assert.assertNotNull("Pain Management item exists, pass", painManagement);

		// TODO: as the app grows, this test needs to expand to verify that
		// clicking on Pain Management takes the user to the correct page
		painManagement.click();

		// Check that the Exercise Library item exists
		WebElement exerciseLibrary = menuList.get(2);
		Assert.assertNotNull("Exercise Library item exists, pass", exerciseLibrary);

		// TODO: as the app grows, this test needs to expand to verify that
		// clicking on Exercise Library takes the user to the correct page
		exerciseLibrary.click();

		// Check that the Forms item exists
		WebElement forms = menuList.get(3);
		Assert.assertNotNull("Forms item exists, pass", forms);

		// TODO: as the app grows, this test needs to expand to verify that
		// clicking on Forms takes the user to the correct page
		forms.click();

		// Check that the Schedule item exists
		WebElement schedule = menuList.get(4);
		Assert.assertNotNull("Schedule item exists, pass", schedule);

		// TODO: as the app grows, this test needs to expand to verify that
		// clicking on Schedule takes the user to the correct page
		schedule.click();
	}

}