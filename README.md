Rails 6, Sendgrid Web API
 
## Local setup

1. Edit `seeds.rb` if neccessary
2. `bundle install`
3. Replace credentials, put your Sendgrid API key to `sendgrid_api_key:` property
4. `bundle rails db:migrate`
5. `bundle rails s`

## Available Routes

```
    GET  /users
    POST /users
    GET  /users/:id
    POST /invites
```

