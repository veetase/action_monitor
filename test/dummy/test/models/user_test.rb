require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # let(:user) { users(:one) }
  test "get_columns_to_track" do
    # symbol
    assert_equal User.get_columns_to_track(:name), [:name]

    # array
    assert_equal User.get_columns_to_track([:name, :login_at]), [:name, :login_at]

    # hash only
    assert_equal User.get_columns_to_track(only: [:name, :login_at]), [:name, :login_at]

    # hash except
    assert_equal User.get_columns_to_track(except: [:updated_at]), [:id, :name, :login_at, :created_at]
  end

  test "configuration" do
    app_name = 'test_name'
    path = 'log/action.log'
    resource_identfier = 'name'

    ActionMonitor.configure do |config|
      config.app_name = app_name
      config.log_path = path
      config.resource_identfier = resource_identfier
    end

    puts User.count
    user = users(:one)

    assert_equal ActionMonitor.configuration.app_name, app_name
    assert_equal user.resource_id, user.name
  end
end
