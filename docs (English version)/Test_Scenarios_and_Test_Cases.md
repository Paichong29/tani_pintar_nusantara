# Test Scenarios & Test Cases - Tani Pintar Nusantara

## 1. Test Scenario: Plant Image Capture
- **Test Case 1.1:** Capture image using camera
  - Steps: Open Scan screen → Tap capture button → Verify image is captured
  - Expected Result: Image is captured and displayed for analysis
- **Test Case 1.2:** Upload image from gallery
  - Steps: Open Scan screen → Select upload → Choose image → Verify image is loaded
  - Expected Result: Image is loaded and ready for analysis

## 2. Test Scenario: AI Analysis
- **Test Case 2.1:** Submit image for analysis
  - Steps: Capture or upload image → Submit for analysis
  - Expected Result: Analysis result is returned within 10 seconds
- **Test Case 2.2:** Handle invalid image
  - Steps: Submit non-plant image
  - Expected Result: Error message prompting to retry

## 3. Test Scenario: History Management
- **Test Case 3.1:** View analysis history
  - Steps: Navigate to History screen
  - Expected Result: List of past analyses displayed
- **Test Case 3.2:** Search history
  - Steps: Enter search query
  - Expected Result: Filtered list matching query
- **Test Case 3.3:** Delete history item
  - Steps: Swipe to delete or select delete option
  - Expected Result: Item removed with undo option

## 4. Test Scenario: Settings
- **Test Case 4.1:** Change language
  - Steps: Open Settings → Select language → Verify UI updates
  - Expected Result: App language changes accordingly
- **Test Case 4.2:** Toggle theme
  - Steps: Open Settings → Toggle theme switch
  - Expected Result: App theme switches between light and dark

## 5. Test Scenario: Notifications
- **Test Case 5.1:** Receive analysis completion notification
  - Steps: Submit image for analysis → Wait for notification
  - Expected Result: Notification received upon completion

---

*These test scenarios and cases ensure critical functionalities are verified for quality assurance.*
