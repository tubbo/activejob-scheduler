# ActiveJob::Scheduler

[![Current Gem Version](https://badge.fury.io/rb/activejob-scheduler.svg)](http://badge.fury.io/rb/activejob-scheduler)
[![Build Status](https://travis-ci.org/tubbo/activejob-scheduler.svg?branch=master)](https://travis-ci.org/tubbo/activejob-scheduler)

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

Run the following command to generate a YAML-based schedule:

```bash
$ rails generate activejob:schedule
```

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
