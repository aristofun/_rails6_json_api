Rails 6, Sendgrid Web API
 
## Local setup

1. Edit `seeds.rb` if neccessary
2. `bundle install`
3. Create [your own credentials](https://stackoverflow.com/a/48373368/1245302) and put your Sendgrid API key to `sendgrid_api_key:` property
4. `bundle rails db:migrate`
5. `bundle rails s`

## Available Routes

```
    GET  /users
    POST /users
    GET  /users/:id
    POST /invites
```

