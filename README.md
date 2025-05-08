# 🍵 Tea Tracker

A Rails web app for tracking and visualizing tea consumption habits!

---

## 🚀 Project Setup

To get started:

1. **Install dependencies:**
   - Ruby 3.x
   - Rails 8.x
   - PostgreSQL

2. **Install gems:**
   ```bash
   bundle install
   ```

3. **Set up the database:**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server:**
   ```bash
   rails server
   ```
   Visit [http://localhost:3000](http://localhost:3000) to view the app.

---

## 📋 Current Setup
- Rails app created
- Database migrated
- 2 seeded users, each with personalized profiles
- 14 seeded teas, linked to their respective users
- User model includes secure authentication and custom fields (`bio`, `avatar_url`)
- Backend fully supports multi-user tea tracking

---

# ✅ How to Get Started Quickly

```bash
git clone <repo-url>
cd project-tea-tracker/tea_tracker
bundle install
rails db:create db:migrate db:seed
rails server
```

# Heroku Setup
Make sure you are in the tea_tracker folder, not the parent folder and then run
```
git init
git branch -m master main
git checkout -b main
git remote add heroku https://git.heroku.com/tea-tracker.git
```

To check, run 
```git remote -v```
which should return (among others)
```heroku  https://git.heroku.com/tea-tracker.git (fetch)
heroku  https://git.heroku.com/tea-tracker.git (push)```

Run 
```cd ..
git remote -v```
This should not have any heroku links in it. 

To push to site, run 
```git push heroku main```
in this folder.

Congrats. You can now push to the deployed site.

To interact with the database, you need the following:

Heroku CLI
```brew install heroku/brew/heroku``` 
for Windows: look [here](https://devcenter.heroku.com/articles/heroku-cli)

```heroku login```
This will take you to heroku's login page, which is required for authentication.


Then, to connect to the database:
```heroku psql -a tea-tracker```
which is just a psql instance where you can run Postgres commands.

To push data from db/seeds.rb to remote 
```
heroku run rake db:seed -a tea-tracker
```

## Troubleshooting
If `heroku psql` gives you the error of `SSL error: certificate verify failed`, run the following:

```
cd ~/.postgresql
rm root.crt
```
This may cause issues if with other Postgres databases, but works for the connection.

# Heroku Post-Commit Hook Setup
Make sure you are in the root directory (`project-tea-tracker`).
There's a folder called `githooks` that should have a script called `post-commit` in it. If there isn't, mention it in Slack because we need to put it back. 

Run the following to setup the hooks script:
```
chmod +x setup_hooks.sh
./setup_hooks.sh
```

Run the following to check if it worked:
```
git config core.hooksPath
```
It should return 
```
githooks
```

Now, if you preface a commit with `prod:` (all lowercase right now but might change later), it will deploy to Heroku. The result will look like this:
```
git commit -m "prod: test"

Detected prod: commit — updating Heroku...
From https://git.heroku.com/tea-tracker
 * branch            main       -> FETCH_HEAD
Already up to date.
[main 2db32f6] Auto-sync from Repo A commit: prod: test
 1 file changed, 2 insertions(+)
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
...
```
Note: this will run when you COMMIT, not when you PUSH. So if you redact a commit/go back and forth there may be some messiness in the git history of Heroku, but since we're not explicitly looking there, this should be fine. It is also force pushing every time which is bad practice but will not fail (TODO: look into --force-with-lease).