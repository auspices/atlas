# Atlas

[![Build Status](https://travis-ci.org/auspices/atlas.svg?branch=master)](https://travis-ci.org/auspices/atlas)

## Meta

* **State**: production
* **Production**:
  * **URL**: https://atlas.auspic.es/
  * **URL**: https://auspices-atlas-production.herokuapp.com/
* **Host**: https://dashboard.heroku.com/apps/auspices-atlas-production
* **Deploys**: Merged PRs to `auspices/atlas#master` are automatically deployed to production [via Travis](https://travis-ci.org/auspices/atlas).

## API

GraphQL endpoint is located at `https://atlas.auspic.es/graphql`. Point your GraphiQL instance at this to explore the schema.

`/` simply returns a status response:

```json
{
  "status": 200,
  "code": "OK"
}
```
