# ActiveJob::Scheduler

[![Current Gem Version](https://badge.fury.io/rb/activejob-scheduler.svg)](http://badge.fury.io/rb/activejob-scheduler)

An extension to [ActiveJob][aj] for running background jobs
periodically, according to a schedule. Inspired by its predecessors,
[resque-scheduler][resque] and [sidekiq-scheduler][sidekiq],
`ActiveJob::Scheduler` hopes to bring the power of scheduled jobs into
everyone's hands, by way of the pre-defined ActiveJob API which most
popular queueing backend choices already support.

Like its predecessors, `ActiveJob::Scheduler` is built with
[Rufus::Scheduler][rufus], an immensely powerful task scheduling library
to make sure your jobs get kicked off at *exactly* the right time.

## Installation

Add this line to your application's Gemfile:

    gem 'activejob-scheduler'

And then execute:

    $ bundle

## Usage

Run the following command to generate a YAML-based schedule:

```bash
$ rails generate active_job:schedule
```

Edit this YAML file the same way you would with resque-scheduler or
sidekiq-scheduler (they define the same parameters). Then, it's your
choice as to how you wish to run it, either by the binary:

```bash
$ bundle exec ajs
```

Or, with a Rake task:

```bash
$ bundle exec rake schedule
```

The schedule must run as a separate process, but it's very light...it
delegates all the real processing to your queue workers, and simply
enqueues jobs as the specified time rolls around.

## Development

Please use GitHub pull requests to contribute bug fixes or features, and
make sure to include tests with all your work.

### License

[University of Illinois/NCSA Open Source License][license]

    Copyright (c) 2014 Tom Scott
    All rights reserved.

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the "Software"),
    to deal with the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimers.

    Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimers in the documentation
    and/or other materials provided with the distribution.

    None of the names of its contributors may be used to endorse or promote
    products derived from this Software without specific prior written permission.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
    INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
    PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT
    OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS WITH THE SOFTWARE.

[aj]: https://github.com/rails/activejob
[resque]: https://github.com/resque/resque-scheduler
[sidekiq]: https://github.com/Moove-it/sidekiq-scheduler
[rufus]: https://github.com/jmettraux/rufus-scheduler
[license]: http://opensource.org/licenses/NCSA
