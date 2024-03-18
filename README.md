# github_selfhosted_runner_test

Running the container defined in the `dockerfile` will run a self hosted GitHub runner locally on your machine.

To set up the self hosted runners, create an `.env` file in the top level directory with the following variables defined
```
# the current available version
RUNNER_VERSION=2.314.1

GH_OWNER=your github account name
GH_REPOSITORY=your repo
GH_TOKEN=the token provided by GitHub for the repo
```

Then run the following command
```bash
> docker compose build
> docker compose up
```

## TO DOES

Currently the approach does not support workflows running in a different workflow container aka using
```
runs-on: self-hosted
container:
  image: maven:3-eclipse-temurin-21
```
The problem is, that the image would be started as a docker in docker which the current `dockerfile` does not support.