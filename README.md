# Moeverdose [![CodeFactor](https://www.codefactor.io/repository/github/eternialz/moeverdose/badge)](https://www.codefactor.io/repository/github/eternialz/moeverdose/) [![CodeFactor](https://travis-ci.org/eternialz/moeverdose.svg?branch=master)](https://travis-ci.org/eternialz/moeverdose) [![Known Vulnerabilities](https://snyk.io/test/github/eternialz/moeverdose/badge.svg)](https://snyk.io/test/github/eternialz/moeverdose) [![dev chat](https://discordapp.com/api/guilds/163371003366342657/widget.png?style=shield)](https://discordapp.com/invite/xfCpyJY) [![Coverage Status](https://coveralls.io/repos/github/eternialz/moeverdose/badge.svg?branch=master)](https://coveralls.io/github/eternialz/moeverdose?branch=master) [![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat)](https://github.com/prettier/prettier)

http://moeverdose.moe | https://twitter.com/moeverdose

A taggable image board made from scratch with Rails 5 and PostGreSQL.
Online soon.

# Requirements

- Rails 5.2
- Ruby 2.6.3
- Docker

# Initialisation

### Dev

- Install Requirements

- Create database `docker-compose run --rm runner rails db:create`

- Execute migrations `docker-compose run --rm runner rails db:migrate`

- Seed database `docker-compose run --rm runner rails db:seed`

- Run moeverdose `docker-compose run --publish 3000:3000 -rm rails`

- Access as http://localhost:3000

### Testing

- Execute migrations for test base `docker-compose run --rm runner rails db:migrate RAILS_ENV=test`

- Run tests `docker-compose run --rm runner rails test`

# Browser support

Browser support is defined in [.browserlistrc](https://github.com/eternialz/moeverdose/blob/master/.browserlistrc)

# Contributing

See [CONTRIBUTING.md](https://github.com/eternialz/moeverdose/blob/master/CONTRIBUTING.md)

# Licence

Mozilla Public Licence 2.0
