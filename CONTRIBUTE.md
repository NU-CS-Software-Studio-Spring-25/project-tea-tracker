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

3. **Set up the local database:**
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
bundle install
rails db:create db:migrate db:seed
rails server
```

# Heroku Setup
In the root of the project, run
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


If the post-commit hook isn't working, to push to site, run 
```git push heroku main```
in this folder. ONLY if it isn't working. 

To interact with the database, you need the following:

Heroku CLI
```brew install heroku/brew/heroku``` 
for Windows: look [here](https://devcenter.heroku.com/articles/heroku-cli)

```heroku login```
This will take you to heroku's login page, which is required for authentication.


To push data from db/seeds.rb to remote, again, only if the post-commit hook isn't working 
```
heroku pg:reset --confirm tea-tracker
heroku pg:push tea_tracker_development DATABASE_URL --app tea-tracker
```

Then, to connect to the database:
```heroku psql -a tea-tracker```
which is just a psql instance where you can run Postgresql commands.
You can run `\dt` to see all tables or `SELECT * FROM users;` or `SELECT * FROM teas;` to see if the data is properly migrated. 

## Troubleshooting
If `heroku psql` gives you the error of `SSL error: certificate verify failed`, run the following:

```
cd ~/.postgresql
rm root.crt
```
This may cause issues if with other Postgres databases, but works for the connection.

# Heroku Post-Commit Hook Setup
The hook automatically runs after every commit. This means that if you commit to our git remote, it also automatically pushes to heroku.
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

Now, if you commit, it will deploy to Heroku. If you are not logged in, it will skip. The result will look like this (TODO: check why it's always resetting db):

```
git add .
git commit -m "test"

Updating Heroku...
From https://git.heroku.com/tea-tracker
 * branch            main       -> FETCH_HEAD
From https://git.heroku.com/tea-tracker
 * branch            main       -> FETCH_HEAD
Already up to date.
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean
Enumerating objects: 12, done.
Counting objects: 100% (12/12), done.
Delta compression using up to 8 threads
Compressing objects: 100% (8/8), done.
Writing objects: 100% (10/10), 4.26 KiB | 4.26 MiB/s, done.
Total 10 (delta 2), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Updated 157 paths from dc6ceda
remote: Compressing source files... done.
remote: Building source:
...
```
Note: this will run when you COMMIT, not when you PUSH. So if you redact a commit/go back and forth there may be some messiness in the git history of Heroku, but since we're not explicitly looking there, this should be fine. It is also force pushing every time which is bad practice but will not fail (TODO: look into --force-with-lease and also look into not resetting the db every time).

NOTE: this does not work with github desktop. ask me how I know...
It does work with VSCode/Cursor's internal git functionality though. 