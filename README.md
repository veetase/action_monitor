# ActionMonitor
A simple tool for logging rails model changes, impleted by add model hooks.
## Getting started

Add this line to your application's Gemfile:

```ruby
gem 'action_monitor', git: 'https://github.com/veetase/action_monitor.git'
```

And then execute:

    $ bundle install

For example, if you want monitor a model named User:

```ruby
class User < ActiveRecord::Base
  track :create, :destroy, :update
end
```

The code above will monitor actions:
- a user is created
- a user is destroyed
- a user is changed

You can also write as follows to specify the column udpated:
```ruby
class User < ActiveRecord::Base
  track update: { only: :role }
end

# short version
class User < ActiveRecord::Base
  track update: :role
end

# short version multiple columns
class User < ActiveRecord::Base
  track update: [:role, :login_at]
end

# using except
class User < ActiveRecord::Base
  track update: { except: [:updated_at, :avatar] }
end
```

## configuration
```ruby
  ActionMonitor.configure do |config|
    config.app_name = 'MyApplication' # optional
    config.log_path = "log/model-changes-#{Rails.env}.log" # optional, default: log/action_monitor.log
    config.current_user_identfier = 'current_user' # code snippet to tell who is the current user, default: current_user, you need to implement it.
    config.resource_identfier = 'tracking_resource_identfier', # method name to get the resource identifier,  default tracking_resource_identfier, if you dont implement it, the default odentifier will be **id**
    config.producer_type = 'file' # only support log file by now
  end
```

That's it!

## 
# License
This project rocks and uses MIT-LICENSE.