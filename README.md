# gh-warehouse
Store Github events as JSON in a Postgres database

## Getting started

1. Clone a copy of this repo
2. Create a new Heroku app and push this to it
3. Run `heroku run rake db:migrate` to create the tables
4. Set up an organization-wide webhook that points to 'https://<your-heroku-app>.herokuapp.com/payloads' with an appropriate secret
5. Configure the app with your secret, a la `heroku config:set WEBHOOK_SECRET_TOKEN=<your-token-goes-here>`
6. Check your webhook settings (https://github.com/organizations/<your organization>/settings/hooks) to make sure hooks are being delivered
7. Hook up your Heroku Postgres DB to a reporting tool of your choice
   for analysis
