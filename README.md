# Moeverdose [![CodeFactor](https://www.codefactor.io/repository/github/eternialz/moeverdose/badge)](https://www.codefactor.io/repository/github/eternialz/moeverdose/) [![CodeFactor](https://travis-ci.org/eternialz/moeverdose.svg?branch=master)](https://travis-ci.org/eternialz/moeverdose) [![dev chat](https://discordapp.com/api/guilds/163371003366342657/widget.png?style=shield)](https://discord.me/moeverdose) [![code style: prettier](https://img.shields.io/badge/code_style-prettier-ff69b4.svg?style=flat)](https://github.com/prettier/prettier)

http://moeverdose.moe | https://twitter.com/moeverdose

A taggable image board made from scratch with Rails 5 and PostGreSQL.
Online soon.

# Requirements

- Rails 5.2
- Ruby 2.5.3
- PostGreSQL
- ImageMagick
- Foreman

# Initialisation

### Dev

- Install Requirements

- Clone and install gems
  `bundle install`

- Create dev database
  `rails db:create db:migrate db:seed`

- Set your environment vars in .env

- Launch server
  `foreman start`

# PLANNED FEATURES

- Install and Deployment script
- Possible and better duplicate finder with perceptual hashes instead of md5
- Finish all helps pages
  - Registration help section
  - Editing posts help page
- Better admin features
  - Batch Delete
  - Admin: stats
  - Edit user role
  - Search posts, users
  - Administrable tags
- Patreon
  - Color change contrib
  - Rôle discord
  - Better comment length
  - Custom banner
  - Avatar GIF
  - No Ads
- Ad Sense

# Contributing

See [CONTRIBUTING.md](https://github.com/eternialz/moeverdose/blob/master/CONTRIBUTING.md)

# Licence

Mozilla Public Licence 2.0
