# moeverdose

http://moeverdose.moe

A booru made with Rails 5
With beautiful design! And stupid things! And heretic rituals! And cute hamsters (Umarun~) !

# Notes

##**TODOs:**

### Admin system
Administrators and moderators can remove posts, comments, ...

Administrations page must list all reported posts and comments + the reason and the reporter.

Admin can edit user Roles

### Posts system

* Title
* Source
* Author
* Tags
* Image
* Comments
* Overdoses
* Moe shortage

### Tag system

Tags types:
* Characters
* Author
* Content

Tags need a post count and a downcased name where spaces are replaced by underscores

### Users system

Users are able to make a post their favorites, blacklist tags, blacklist user, blacklist authors, follow tags,
User pages must show their recent likes, recent uploads, stats and avatar.

Stats:
Post count, role(s), likes count, author added, overdoses, moe shortage, join date, comment count

Roles:
admin, moderators, regular user, contributor, developper

### Comment system
Comments belongs to a post and an user.
User comment count ?
Latest/All comment page ?

### Author system
Every authors must have pages. A registered user can add authors. Recognised users can modify authors informations.

Authors page must display: Name/pseudo, link to website(s), list of posts, stats

If the author name doen't exist when uploading an image, an author page is automatically generated with the name only.
Then, in the post, there is a need to display that we need more informations about the autor.

### Cache and optimisation

### Other
* Team page
* Help page
* Home page
* Stats page
* Git/open source page
* Licence page
* Changelog page
* Download page
* About page
* Legal things page ?
* Chat / discord page with api integration

##**IDEAs:**

### MANY THINGS! Yay!
...I forgot all of em!

...

... I lied!

* Prevent user deletion if they are not regular users
* "Overdose" as post like and "Moe Shortage" as post dislike
* Users page can be filtered with: best uploader, best commentator
* Posts page can be filtered by: overdose, moe shortages, popularity, recent posts
* Changelog system ?
* News system on the homepage ?
* Discord Api integration. Registered users can request an invite wich expire on use or 30 min?
* Discord bot
  * Repost every posts
  * Find posts by id (!post id)
  * ...
* Random link to a post
* Random message on the homepage

# Branches

master = Prod

pre-prod = Prod candidate

develop = Where every feature/fix are applied when they are finished

feature/* and fix/* are always branches of develop

Use feature/nameoffeature to commit new features

Use fix/nameoffix to commit fixes


##**PROBLEMs:**

* *Wich girl should we use as a logo for moeverdose?!!!*
* Contributors and Regular users can edit posts/authors or only contributors?
* Contributors and Regular users can report posts/authors or only contributors?
