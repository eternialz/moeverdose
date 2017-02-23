# moeverdose

http://moeverdose.moe (old php version)

A booru made from scratch with Rails 5 and MongoDB
With a stupid team! And heretic rituals! And cute hamsters (Umarun~) !

#**TODOs:**
## **Priorities**

* 1 Posts system 99%
* 2 User system 75%
* 3 Comments system 50%
* 4 Author system 50%
* 5 Tag system 70%
* 6 Filter posts 5%
* 7 Alias system 0%
* 8 News system 80%

## ADMIN
* User list + delete and notification of infractions
* All Post list + thumbnail + delete + reported filter + link to uploader profile in admin page
* Prevent user deletion if they are not regular users
* All Tag list and their aliases
* All reported comments + delete or acceptation

## POSTS
* Report system
* Search by image on google
* Search system + filter
* Next/Previous
* Best posts page
* Source link
* Pagination in index

## COMMENTS
* Replies or quotes?
* Spoilers ?
* Anon comments?
* Post links '#[id_of_post]'
* User link '@username'
* Hide reported comments

## TAGS
* Aliases system

## USERS
* Security options
  * Change pass
  * Change mail
* Follow authors/characters/tags
* Notification system
* Level grow when other user like uploaded posts by the user
* Protect upload/edit/destroy/etc from non logged users and non authorized roles

## AUTHORS
* profiles?
* biography
* edit

## OTHERS
* Custom error pages

# Branches

master = Prod
preprod = Prod candidate
develop = Where every feature branches are merged when they are completed
feature/* are branches started from develop
hotfix/* are branches started from master

Use feature/name_of_new_feature to commit new features
Use hotfix/name_of_bug_to_fix to commit fixes

#**PROBLEMs and Future ideas:**

* What logo should we use?
* Which server should we use?
* Which CDN should we use?
* Discord bot + integration
