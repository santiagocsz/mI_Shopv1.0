# mI_Shop

## Prerequisites

1. Install Ruby via [RailsInstaller](http://railsinstaller.org/en) *(install latest version)*

2. ```
   bundle install --without production
   ```
   ​

### mI_Shop

It's a shop where an admin can add or delete items and Users can buy from it.
Use account: admin@admin.com
   password: admin
to gain access to administrator privileges to add or delete items from the store



## Deploying to Heroku

### Deployment Instructions

1. Add all your changes on git and make a commit
2. Create a Heroku server: `heroku create`
3. Create a database for your server: `heroku addons:create heroku-postgresql:hobby-dev`
4. Push the code to Heroku: `git push heroku master`
5. I preconfigured the necessary files for this to work.
6. Verify all is working and submit your links (github and heroku) to me.
