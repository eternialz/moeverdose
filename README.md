# moeverdose

A booru made with Rails 5 | http://moeverdose.moe
With beautiful design! hehe

# Notes

##**TODOs:**

### Admin system
Administrators and moderators can remove posts, comments, ...
Administrations page must list all reported posts and comments + the reason and the reporter.
Admin can edit user Roles


### Posts system


### Users system

Users are able to make a post their favorites, blacklist tags, blacklist user, blacklist authors, follow tags,
User pages must show their recent likes, recent uploads, stats and avatar.

Stats:
Post count, role(s), likes count, author added, overdoses, moe shortage, join date, comment count

Roles:
admin, moderators, regular user, contributor, developper


### Comment system


### Author system
Every authors must have pages. A registered user can add authors. Recognised users can modify authors informations.
Authors page must display: Name/pseudo, link to website(s), list of posts, stats
If the author name doen't exist when uploading an image, an author page is automatically generated with the name only.
Then in the post, there is a need to display that we need more informations about the autor.

##**IDEAs:**

### MANY THINGS! Yay!
...I forgot all of em!







... I lied!

* Prevent user deletion if they are not regular users
* "Overdose" as post like and "Moe Shortage" as post dislike

# Branches

master = Prod
pre-prod = Prod candidate
develop = Where every feature/fix are applied when they are finished
feature/* and fix/* are always branches of develop

Use feature/nameoffeature to commit new features
Use bug/nameofbug to commit fixes
