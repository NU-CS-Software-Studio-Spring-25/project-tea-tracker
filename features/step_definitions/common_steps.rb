require 'rspec/expectations'

Before do
  # Clean up in the correct order to respect foreign key constraints
  ActiveRecord::Base.connection.execute("TRUNCATE entries, teas, users CASCADE")
  
  # Create only the skylarke user
  User.create!(
    username: "skylarke",
    password: "Password123",
    password_confirmation: "Password123",
    bio: "Building a diverse tea collection.",
    csv_prompt_seen: true
  )
end

# Navigation steps
Given(/^I am on the home page$/) do
  visit root_path
end

# User creation and authentication steps
Given(/^a user exists with username "([^"]*)" and password "([^"]*)"$/) do |username, password|
  # Skip user creation since we already have skylarke
  expect(username).to eq("skylarke")
end

Given(/^I am signed in as "([^"]*)"$/) do |username|
  # Only allow skylarke
  expect(username).to eq("skylarke")
  
  visit new_session_path
  fill_in "username", with: username
  fill_in "password", with: "Password123"
  find('input.cta-button.primary-btn[type="submit"]').click
end

# Interaction steps
When(/^I click "([^"]*)"$/) do |link|
  case link
  when "Login"
    find('input.cta-button.primary-btn[type="submit"]').click
  when "Logout"
    click_link "Logout"
  when "New Tea"
    click_link "New Tea"
  else
    click_link_or_button link
  end
end

When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field.downcase, with: value
end

# Tea management steps
Given(/^a tea exists with name "([^"]*)"$/) do |name|
  # Use skylarke as the user
  user = User.find_by(username: "skylarke")
  
  Tea.create!(
    name: name,
    category: "black",
    price: 10.0,
    vendor: "Test Vendor",
    known_for: "Test Known For",
    region: "Test Region",
    popularity: 1,
    shopping_platform: "Test Platform",
    product_url: "http://test.com",
    grams: 100,
    year: 2024,
    ship_from: "Test Origin",
    user: user
  )
end

When(/^I confirm the deletion$/) do
  if page.driver.browser.respond_to?(:switch_to)
    page.driver.browser.switch_to.alert.accept
  else
    click_button "Delete"
  end
end

When(/^I cancel the deletion$/) do
  if page.driver.browser.respond_to?(:switch_to)
    page.driver.browser.switch_to.alert.dismiss
  else
    click_link "Cancel"
  end
end

# Verification steps
Then(/^I should be redirected to the dashboard$/) do
  expect(current_path).to eq(dashboard_path)
end

Then(/^I should be redirected to the home page$/) do
  expect(current_path).to eq(root_path)
end

Then(/^I should see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should not see "([^"]*)"$/) do |text|
  expect(page).not_to have_content(text)
end

Then(/^I should still see "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end 