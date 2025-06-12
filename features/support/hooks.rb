Before do
  # Clear any existing data
  DatabaseCleaner.clean_with(:truncation)
end

After do
  # Clean up after each scenario
  DatabaseCleaner.clean
end 