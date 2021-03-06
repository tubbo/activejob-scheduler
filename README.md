# ActiveJob::Scheduler

[![Current Gem Version](https://badge.fury.io/rb/activejob-scheduler.svg)](http://badge.fury.io/rb/activejob-scheduler)
[![Build Status](https://travis-ci.org/tubbo/activejob-scheduler.svg?branch=master)](https://travis-ci.org/tubbo/activejob-scheduler)
[![Maintainability](https://api.codeclimate.com/v1/badges/94b5d52c0059cc8a380b/maintainability)](https://codeclimate.com/github/tubbo/activejob-scheduler/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/94b5d52c0059cc8a380b/test_coverage)](https://codeclimate.com/github/tubbo/activejob-scheduler/test_coverage)

An extension to [ActiveJob][aj] for running background jobs
periodically, according to a schedule. Inspired by its predecessors,
[resque-scheduler][resque] and [sidekiq-scheduler][sidekiq],
`ActiveJob::Scheduler` hopes to bring the power of scheduled jobs into
everyone's hands, by way of the pre-defined ActiveJob API which most
popular queueing backend choices already support.

Like its predecessors, `ActiveJob::Scheduler` uses the same powerful
syntax for describing when periodic jobs should run as
[Rufus::Scheduler][rufus]. However, unlike its predecessors,
`ActiveJob::Scheduler` does not require a separate process to be run.
Instead, it uses an `after_perform` callback to re-enqueue the job after
it has been performed.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activejob-scheduler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activejob-scheduler

## Usage

To schedule your jobs, add the `repeat` macro to the job definition:

```ruby
class GenerateSitemapsJob < ApplicationJob
  repeat 'every day at 2am'

  def perform
    SitemapGenerator.generate
  end
end
```

This macro can also be used to configure the job event, like its name or
arguments:

```ruby
class GenerateSitemapsJob < ApplicationJob
  repeat every: '1d', name: 'Sitemap Generator', arguments: %w(foo bar)

  def perform(foo, bar)
    SitemapGenerator.generate(foo, bar) # => foo == "foo", bar == "bar"
  end
end
```

The DSL also allows you to iterate over a collection and pass in a
different argument for each item:

```ruby
class SyncOrdersJob < ApplicationJob
  repeat 'every day at 11:30am', each: -> { Order.not_synced }

  def perform(order)
    ExternalSystem.create(order)
  end
end
```

This will trigger the event every day at 11:30am, but enqueue a job for
each model in the collection, and pass it into the job arguments. You
can specify static arguments here as well, they will be passed in prior
to the item argument at the end.

```ruby
class SyncOrdersJob < ApplicationJob
  repeat 'every day at 11:30am',
    arguments: ['synced'],
    each: -> { Order.not_synced }

  def perform(type, order)
    ExternalSystem.create(type: type, order: order) # type is "synced"
  end
end
```

Start the schedule by running this command:

```bash
./bin/rails activejob:schedule
```

### YAML Schedule

Much like **resque-scheduler**, you can use a YAML schedule file with
**activejob-scheduler** with a very similar syntax. To generate a new
one, run:

```bash
$ rails generate activejob:schedule
```

Then, add your jobs into the YAML like so:

```yaml
generate_sitemaps:
  interval:
    every: '1d'
```

This is entirely optional, however, and both DSL-based jobs and
YAML-based jobs will be included in the schedule at runtime.

### Mailers

```ruby
class AdminMailer < ApplicationMailer
  repeat :daily_status, 'every day at 8am'
  def daily_status
    mail to: User.admins.pluck(:email)
  end
end
```

This will send the email every day at **8:00am**. You can also pass all
the regular fields from `repeat` in the job DSL like arguments and the
various fugit-parsed intervals.

You can also send a different email for each recipient:

```ruby
class UserMailer < ApplicationMailer
  repeat :status, 'every day at 8am', each: -> { User.receive_email }
  def status(user)
  end
end
```

This lambda will be called when the event is enqueued, and individual
mails will be sent out for each user in the collection.

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake rspec` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To
release a new version, update the version number in `version.rb`, and
then run `bin/rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/tubbo/activejob-scheduler. This project is intended
to be a safe, welcoming space for collaboration, and contributors
are expected to adhere to the
[Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License][mit].

[aj]: https://github.com/rails/rails/tree/master/activejob
[resque]: https://github.com/resque/resque-scheduler
[sidekiq]: https://github.com/Moove-it/sidekiq-scheduler
[rufus]: https://github.com/jmettraux/rufus-scheduler
[mit]: http://opensource.org/licenses/MIT
