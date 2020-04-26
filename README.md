# ExcelSerializer

This gem allows you to easily export ruby objects to excel files by defining a serializer for each object. ExcelSerializer can work with multiple excel writting gems and allows you to translate the document headers using I18n.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'excel_serializer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install excel_serializer

## Usage

### Serializer definition

```ruby
class AttendeeExcelSerializer
  include ExcelSerializer::ObjectSerializer

  attributes :uuid, :first_name, :last_name, :created_at
  belongs_to :event

  excel_adapter :write_excel # optional
  translation_adapter :i18n # optional 

  def created_at
    object.created_at&.strftime("%Y-%m-%d")
  end
end
```

### Excel file generation

```ruby
AttendeeExcelSerializer.new(attendees).excel_file
```

excel_file method receives an optional string parameter path, which will be used as the generated file path. If this param is not present the file will be generated in /tmp folder with a random string name.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/storresy/excel_serializer. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/storresy/excel_serializer/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExcelSerializer project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/storresy/excel_serializer/blob/master/CODE_OF_CONDUCT.md).
