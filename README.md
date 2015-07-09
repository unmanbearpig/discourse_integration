# Simple app that provides Single Sign On for Discourse

## How to set it up
### Add a new subdomain for your forum
You have to use your registrar's website to do that.
Point it to your Discourse IP address.

### Warning
Don't enable SSO in Discourse until everything else is ready.
Discourse would disable regular login when you enable SSO,
so nobody (including you) would be able to log in if it does not work.

### How to disable SSO if something goes wrong and you can't log into Discourse

In case you enable it and login doesn't work, you can disable
it via rails console on you Discourse server.

- ssh to your DigitalOcean server

- Go to your discourse directory, probably
```
cd /var/discourse
```
Enter the Discourse conainer using its launcher
Replace app with your real container configuration name,
it is probably the only file in /var/discourse/containers

try this
```
ls containers
```

skip the file extension, so if it's called app.yml, then execute
```
./launcher enter app
```

If everything is fine then you should be able to run
```
rails c
```
it would launch a Rails console in your production Discourse.

You can disable SSO with the following command:
```
SiteSetting.enable_sso = false
```

### Create a new app in Heroku

Fork this repository and create a new app.

### Enable PostgreSQL Heroku addon
I'm using PostgreSQL database, since Heroku does not recommend to use sqlite in production.
You need heroku-postgresql:hobby-dev add-on, to enable it use
```
heroku addons:attach heroku-postgresql:hobby-dev
```
### Set the configuration variables

You can set environment variables via
```
heroku config:set KEY1=VALUE1
```

#### DISCOURSE_URL
It's the url of your Discoures
for example in my project it is set to
```
http://discourse-test.scykr.com
```

#### DISCOURSE_SSO_URL
Address to Discourse's SSO API endpoint, it should be something like
"#{your-discourse}/session/sso_login", replace #{your-discourse} with the address to your forum.
Here is the value I use.
```
http://discourse-test.scykr.com/session/sso_login
```

#### DISCOURSE_SSO_SECRET
A secret key for signing auth data sent between Discourse and Rails app.
Should be the same as your secret in the Discourse forum.
The longer and more complex - the better.

### Configure Discourse
#### SSO Secret
#### SSO URL
The url of your Rails app's SSO endpoint.
Set it to
"#{your-app-url}/discourse/sso"

Here is mine, for example:
```
http://discourse-integration-app.herokuapp.com/discourse/sso
```
#### Configure header styles
TODO
### Enable SSO
Make sure your app is live and enable SSO in Discourse.
