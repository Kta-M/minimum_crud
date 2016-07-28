# MinimumCrud

[![Gem Version](https://badge.fury.io/rb/minimum_crud.svg)](https://badge.fury.io/rb/minimum_crud)
[![Code Climate](https://codeclimate.com/github/Kta-M/minimum_crud/badges/gpa.svg)](https://codeclimate.com/github/Kta-M/minimum_crud)

MinimumCrud is a Rails controller/view generator for simple model. The generated controller/view works as with Rails default scaffold controller/view, and minimize the code with DRY principle.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'minimum_crud'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install minimum_crud
```

## Usage

After migrate (in this case `users`),

```
$ bundle exec rails g minimum_crud users
      create  app/controllers/users_controller.rb
      create  app/views/layouts/minimum_crud/application/_form.html.erb
      create  app/views/layouts/minimum_crud/application/index.html.erb
      create  app/views/layouts/minimum_crud/application/show.html.erb
      create  app/views/layouts/minimum_crud/application/new.html.erb
      create  app/views/layouts/minimum_crud/application/edit.html.erb
      create  app/views/users/_form.html.erb
      create  app/views/users/_index.html.erb
      create  app/views/users/_show.html.erb
```

|files|description|
|:--------|:--------|
|app/controllers/users_controller.rb|the controller works as with Rails default scaffold controller for users.|
|app/views/layouts/minimum_crud/application/*.html.erb|sub layout files.|
|app/views/users/*.html.erb|model specific view files.|

In the view files, there are some instance variable
- @model: model class
- @record: target record (`show`, `new`, `edit`)
- @records: target record array (`index`)

### option
|option|description|default|
|:--------|:--------|:--------|
|-l, --sub-layout|sub layout directory name. if you don't need sub layout, set `none`.|application|
|-j, --enable-json|enable json format|false|
|-p, --permit-params|permit params list on strong prameters|attributes of the model except `id`, `created_at`, `updated_at`|

example:
```
$ bundle exec rails g minimum_crud users --sub-layout none --enable-json true --permit-params name birthday
```

## Contributing

1. Fork it!
1. Create your feature branch (git checkout -b my-new-feature)
1. Commit your changes (git commit -am 'Add some feature')
1. Push to the branch (git push origin my-new-feature)
1. Create a new Pull Request


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
