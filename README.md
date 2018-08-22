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

You can also:
```ruby
class User < ActiveRecord::Base
  track update: :role
end
```
which will only monitor the action when the specify column *role* changed.

That's it!

## 
# License
This project rocks and uses MIT-LICENSE.