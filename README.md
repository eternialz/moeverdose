<p align="center"><img width="100" src="https://github.com/eternialz/moeverdose/blob/develop/public/images/logo-128.png?raw=true" alt="Moeverdose logo"></p>

<h1 align="center">MOEVERDOSE</h1>
<p align="center">A taggable image board made from scratch with Rails 5 and PostGreSQL.</p>
<p align="center">
    <a href="https://travis-ci.org/eternialz/moeverdose"><img src="https://travis-ci.org/eternialz/moeverdose.svg?branch=develop" alt="Build Status"></a>
    <a href="https://codecov.io/gh/eternialz/moeverdose"><img src="https://codecov.io/gh/eternialz/moeverdose/branch/develop/graph/badge.svg" alt="Coverage Status"></a>
    <a href="https://www.codefactor.io/repository/github/eternialz/moeverdose/"><img src="https://www.codefactor.io/repository/github/eternialz/moeverdose/badge" alt="Code quality"></a>
    <a href="https://discordapp.com/invite/xfCpyJY"><img src="https://discordapp.com/api/guilds/163371003366342657/widget.png?style=shield" alt="Dev chat"></a>
    <a href="https://opensource.org/licenses/MPL-2.0"><img src="https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg" alt="Licence MPL 2.0"></a>
</p>

<p align="center">
<a href="http://moeverdose.moe">http://moeverdose.moe</a> | <a href="https://twitter.com/moeverdose">https://twitter.com/moeverdose</a>
</p>

## Requirements

- Docker

    *or*
    
- Ruby 2.6.x

- PostgreSQL 10+

- Rails 5.2.x

- ImageMagick

## Features

- Search posts by tags and type of content

- Filter and sort posts

- Favorited & blacklisted tags

- Favorited posts

- Author management

- User profiles

- User levels

- Navigate using keyboard

- GDPR Compliant

## Initialisation

#### Develop

- Set your custom environment variables in .env

- Compile image and access console `docker-compose run --rm runner`

- Install Requirements `bundle install && yarn install`

- Create database `rails db:create db:migrate db:seed`

- Exit console

- Run moeverdose `docker-compose run --publish 3000:3000 --rm rails`

- Access as http://localhost:3000

#### Testing

- Execute migrations for test base `docker-compose run --rm runner rails db:migrate RAILS_ENV=test`

- Run tests `docker-compose run --rm runner rails test`

#### Production

*Work in progress*

## Browser support

Browser support is defined in [.browserslistrc](https://github.com/eternialz/moeverdose/blob/develop/.browserslistrc)

## Contributing

See [Contributing guidelines](https://github.com/eternialz/moeverdose/blob/develop/.github/CONTRIBUTING.md).

## Questions

For questions and support please use the [official discord server](https://discordapp.com/invite/xfCpyJY).

## Changelog

Detailed changes for each release are added along with [each releases](https://github.com/eternialz/moeverdose/releases).

## Licence

[MPL 2.0](https://opensource.org/licenses/MPL-2.0)
