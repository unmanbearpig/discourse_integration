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
You can find all of these settings by searching for sso in your-discourse.com/admin/site_settings/

#### SSO Secret
Should be the same as in your Rails app's config.

#### SSO URL
The url of your Rails app's SSO endpoint.
Set it to
"#{your-app-url}/discourse/sso"

Here is mine, for example:
```
http://discourse-integration-app.herokuapp.com/discourse/sso
```

#### Configure header styles
Go to /admin/customize/css_html in your Discourse forum, create new customization and copy and paste HTML and CSS from discourse_assets directory in this repository.
These are minimal styles copied from Bootstrap and modified a little bit to avoid any collisions with Discourse CSS.
If you need to add some other items into the header, you'll have to modify the HTML on this Discourse admin page.

Replace '#' with a full url to your Rails app in the following part in HTML:
```
<a class="navbar-brand" href="/">
```

Since it's all static, it's impossible to add any dynamic content there and have it displayed in Discourse.
I don't see any good way to do that, and I haven't seen any Discourse forum that does that. All of the Discourse forums I've seen customize it in pretty much the same way.

### Enable SSO
First, switch your main domain to the Rails app and make sure it is live and working.
Enable SSO option in Discourse.

### [Optional] Create accounts for your existing user
If you want you can create accounts for your users in the Rails app and send them the password reset link.
