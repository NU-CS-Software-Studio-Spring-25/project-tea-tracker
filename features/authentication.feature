Feature: User Authentication
  As a user
  I want to sign in and out of the application
  So that I can access my personal tea collection

  Background:
    Given I am on the home page

  Scenario: Successful sign in (Happy Path)
    Given a user exists with username "skylarke" and password "Password123"
    When I click "Login"
    And I fill in "Username" with "skylarke"
    And I fill in "Password" with "Password123"
    And I click "Login"
    Then I should be redirected to the dashboard

  Scenario: Failed sign in with wrong password (Sad Path)
    Given a user exists with username "skylarke" and password "Password123"
    When I click "Login"
    And I fill in "Username" with "skylarke"
    And I fill in "Password" with "wrongpassword"
    And I click "Login"
    Then I should see "Invalid username or password"

  Scenario: Successful sign out (Happy Path)
    Given I am signed in as "skylarke"
    When I click "Logout"
    Then I should be redirected to the home page

  Scenario: Failed sign in with non-existent account (Sad Path)
    When I click "Login"
    And I fill in "Username" with "nonexistent"
    And I fill in "Password" with "Password123"
    And I click "Login"
    Then I should see "Invalid username or password" 