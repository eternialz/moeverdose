# moeverdose

http://moeverdose.moe

A booru made with Rails 5
With beautiful design! And stupid things! And heretic rituals! And cute hamsters (Umarun~) !

# Notes

##**TODOs:**

### Admin system
Administrators and moderators can remove and edit posts, comments, authors

Only administrators can delete users

Administrations page must list all reported posts and comments + the reason and the reporter.

Admin can edit user Roles

### Posts system

* Title
* Source
* Author
* Tags
* Image
* Comments
  * Replies
* Overdoses
* Moe shortage
* Score
* Uploader
* Report
* Add/remove tags and users.
* Contributor can edit author field

### Tag and alias system


* name
* types
  * Characters
  * Author
  * Content
* post count
* downcased name with underscores? or we redo it each time?

Aliases are tags but in the posts pages, they are replaced by their parent.
Aliases can't have aliases in order to prevent aliases linking to themselves.

### Users system

* favorites
* blacklist tags
* blacklist users
* blacklist authors
* follow tags
* notifications
* page for notification or search of followed tags
* stats
  * post count
  * favorites count
  * author count
  * overdoses count
  * moe shortage count
  * join date
  * comment count
* roles
* post navigation

I suggest the use of Devise to créate the authentication system

### Comment system

* Message
* Reply to comment
* Score
* Comment display avatar, roles, nickname, message

### Author system
Every authors must have pages. A registered user can add authors. Recognised users can modify authors informations.

Authors page must display: Name/pseudo, link to website(s), list of posts, stats

If the author name doen't exist when uploading an image, an author page is automatically generated with the name only.
Then, in the post, there is a need to display that we need more informations about the autor.

### Cache and optimisation + CDN

### Other
* ~~Static pages~~
* Prevent user deletion if they are not regular users
* "Overdose" as post like and "Moe Shortage" as post dislike
* Users page can be filtered with: best uploader
* Posts page can be filtered by: overdose, moe shortages, popularity, recent posts, tags, characters, authors
* Random link to a post
* Random message on the homepage
* Custom error pages
* If a user comment a message container #[number] it should be replaced with a link to the post with the corresponding id

### **Priorities**

* 1 Posts system
* 2 User system
* 3 Comments system
* 4 Author system
* 5 Tag system
* 6 Filter posts
* 7 Alias system

# Branches

master = Prod

pre-prod = Prod candidate

develop = Where every feature/fix are applied when they are finished

feature/* and fix/* are always branches of develop

Use feature/nameoffeature to commit new features

Use fix/nameoffix to commit fixes

#**PROBLEMs and Future ideas:**

* *Wich girl should we use as a logo for moeverdose?!!!*
* Contributors and Regular users can edit posts/authors or only contributors?
* Contributors and Regular users can report posts/authors or only contributors?
* If we do tags following, we can also do characters following?
* Discord bot
* Discord Api integration. Registered users can request an invite wich expire on use or 30 min?
* Do we use another database instead of sqlite3 ?
* Reply to comment should be accepted until the 1st, 2nd, 3rd or 4th level?
* Wich server should we use?
* Wich CDN should we use?
* Changelog system ?
* News system on the homepage ?
