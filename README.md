# Gunther P. Können

This is the source code / content repository for the website of Gunther P. Können.

Visit the website at:

* https://guntherkonnen.github.io; or
* https://guntherkonnen.com


### Development

Requirements:

* Ruby 3.1.2 or later

Install dependencies:

```
bundle
```

Run the server:

```
bundle exec middleman server
```

Deploy through Github Actions on push (see .github/workflows/gh-pages.yml):

```
git push origin master
```

Or build and deploy the ./build directory to your platform of choice:

```
bundle exec middleman build
```
