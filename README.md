# Atlas

## Meta

- **State**: production
- **Production**:
  - **URL**: https://atlas.auspic.es/
  - **URL**: https://auspices-atlas-production.herokuapp.com/
- **Host**: https://dashboard.heroku.com/apps/auspices-atlas-production
- **Deploys**: Merged PRs to `auspices/atlas#master` are automatically deployed to production.

## Getting Started

```sh
cp .env.sample .env
# Fill out .env
rails db:setup
forego start -f Procfile.dev
```

## API

GraphQL endpoint is located at `https://atlas.auspic.es/graphql`. Point your GraphiQL instance at this to explore the schema.

`/` simply returns a status response:

```json
{
  "status": 200,
  "code": "OK"
}
```
