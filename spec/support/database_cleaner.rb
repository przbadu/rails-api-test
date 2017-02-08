RSpec.configure do |config|
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation)}
  
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.append_after(:each) { DatabaseCleaner.clean }
end
