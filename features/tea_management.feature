Feature: Tea Management
  As a user
  I want to manage my tea collection
  So that I can keep track of my teas

  Background:
    Given I am signed in as "skylarke"

  Scenario: Successfully create a new tea (Happy Path)
    When I click "New Tea"
    And I fill in "Name" with "Earl Grey"
    And I fill in "Description" with "Classic black tea with bergamot"
    And I fill in "Origin" with "England"
    And I click "Create Tea"
    Then I should see "Tea was successfully created"
    And I should see "Earl Grey"

  Scenario: Fail to create tea with missing required fields (Sad Path)
    When I click "New Tea"
    And I click "Create Tea"
    Then I should see "Name can't be blank"
    And I should see "Description can't be blank"

  Scenario: Successfully edit a tea (Happy Path)
    Given a tea exists with name "Earl Grey"
    When I click "Edit"
    And I fill in "Description" with "Updated description"
    And I click "Update Tea"
    Then I should see "Tea was successfully updated"
    And I should see "Updated description"

  Scenario: Fail to edit tea with invalid data (Sad Path)
    Given a tea exists with name "Earl Grey"
    When I click "Edit"
    And I fill in "Name" with ""
    And I click "Update Tea"
    Then I should see "Name can't be blank"

  Scenario: Successfully delete a tea (Happy Path)
    Given a tea exists with name "Earl Grey"
    When I click "Delete"
    And I confirm the deletion
    Then I should see "Tea was successfully deleted"
    And I should not see "Earl Grey"

  Scenario: Fail to delete tea due to cancellation (Sad Path)
    Given a tea exists with name "Earl Grey"
    When I click "Delete"
    And I cancel the deletion
    Then I should still see "Earl Grey" 