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
- 1 seeded user
- 10 seeded teas
- Web Page showing all teas for a user

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

# Troubleshooting
If `heroku psql` gives you the error of `SSL error: certificate verify failed`, run the following:

```
cd ~/.postgresql
rm root.crt
```
This may cause issues if with other Postgres databases, but works for the connection.
