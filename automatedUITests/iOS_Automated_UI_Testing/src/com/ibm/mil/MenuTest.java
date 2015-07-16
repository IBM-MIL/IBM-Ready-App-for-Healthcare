package com.ibm.mil;

import java.util.List;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.remote.RemoteWebDriver;

public class MenuTest {
	private static RemoteWebDriver driver;
	private static IosUtilities utils = new IosUtilities();
	private static SignInUtilities signInUtils = new SignInUtilities();

	@Before
	public void setup() throws Exception {
		driver = (RemoteWebDriver) utils.iosTestSetupWebDriver(driver);
	}

	@Test
	public void testMenuAccessibility() throws Exception {
		
		//sign in and accept all permissions
		signInUtils.SignInAndPermissionUtilities(driver);

		// Wait for next page to load, aka wait for the ouch icon to appear
		utils.waitForElement(driver, "ouch icon");

		// Store the uiimages
		List<WebElement> uiImages = driver.findElements(By
				.className("UIAImage"));
		Assert.assertEquals(8, uiImages.size());

		// Select the menu button to reveal the menu
		WebElement menuButton = utils.waitForElement(driver, "menu icon");
		menuButton.click();

		// Wait for menu to load
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// check that the correct amount of StaticTexts are on the screen
		List<WebElement> staticTexts = driver.findElements(By
				.className("UIAStaticText"));
		Assert.assertEquals(45, staticTexts.size());

		// Save table cells in a list
		List<WebElement> tableCells = driver.findElements(By
				.className("UIATableCell"));
		
		/* 
		 * Progress Menu Selection
		 * 
		 */

		// click the Progress menu item
		WebElement progressButton = tableCells.get(1);
		progressButton.click();

		// Wait for next screen to load
		try {
			Thread.sleep(2000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// Check that you can select the Progress menu item
		// test that the next page loaded and that the back button is present
		// TODO: When the app gets more fleshed out, this test will need to
		// change to check for a unique item on the Progress page
		
		// verify that the page loaded by seeing if the day tab is available
		WebElement dayTab = utils.waitForElement(driver, "Day");
		Assert.assertNotNull("Day tab is there so the progress menu item worked", dayTab);
		
		//click on the menu button on the progress view to access the menu again
		WebElement progressMenuButton = utils.waitForElement(driver, "menu icon");
		progressMenuButton.click();
		
		
		/* 
		 * Pain Management Selection
		 * 
		 */

		// Save table cells in a list
		List<WebElement> tableCells2 = driver.findElements(By
				.className("UIATableCell"));
		// click the Pain Management menu item
		WebElement painManagementButton = tableCells2.get(2);
		painManagementButton.click();

		// Check that you can select the Pain Management menu item
		// TODO: When the app gets more fleshed out, this test will need to
		// change to check for a unique item on the Pain Management page
		
		// Wait for next screen to load
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		// TODO: When the app gets more fleshed out, this test will need to
		// change to check all the elements or expand on it
		
		//click on the menu button on the pain management view to access the menu again
		WebElement painManagementMenuButton = utils.waitForElement(driver, "menu icon");
		painManagementMenuButton.click();
		
		
		/* 
		 * Exercise Library Selection
		 * 
		 */

		// Save table cells in a list
		List<WebElement> tableCells3 = driver.findElements(By
				.className("UIATableCell"));
		// click the Exercise Library menu item
		WebElement exerciseLibraryButton = tableCells3.get(3);
		exerciseLibraryButton.click();

		// Check that you can select the Exercise Library menu item, 
		// by checking for the "Assigned exercises" text field
		// TODO: When the app gets more fleshed out, this test will need to
		// change to check for a unique item on the Progress page
		
		WebElement assignedExercises = utils.waitForElement(driver, "Assigned");
		Assert.assertNotNull("Assigned exercises text exists so exercise library page loaded", assignedExercises);
		
		//click on the menu button on the progress view to access the menu again
		WebElement exerciseLibraryMenuButton = utils.waitForElement(driver, "menu icon");
		exerciseLibraryMenuButton.click();
		
		
		/* 
		 * Forms Selection
		 * 
		 */

		// Save table cells in a list
		List<WebElement> tableCells4 = driver.findElements(By
				.className("UIATableCell"));
		// click the Forms menu item
		WebElement formsButton = tableCells4.get(4);
		formsButton.click();

		// wait for the next screen to load
		try {
			Thread.sleep(1000);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		// Save table cells in a list
		List<WebElement> tableCells6 = driver.findElements(By
				.className("UIATableCell"));
		// click the home menu item
		WebElement homeButton = tableCells6.get(0);
		homeButton.click();
		
		
	}

	@After
	public void stop() {
		// Close the session
		utils.iosTestTeardownDriver(driver);
	}
}