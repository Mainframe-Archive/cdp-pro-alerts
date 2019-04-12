# CDP PRO Alerts [![CircleCI](https://img.shields.io/circleci/project/github/MainframeHQ/cdp-pro-alerts.svg)](https://circleci.com/gh/MainframeHQ/cdp-pro-alerts) 

The purpose of this project is to send emails if the CDP is approaching liquidation.

## Installation

Clone the repo and `cd`` into it:

```
git clone git@github.com:MainframeHQ/cdp-pro-alerts.git
cd cdp-pro-alerts
```


### Using nix-shell

* Install [nix](https://nixos.org/nix/manual/#chap-installation)
* Run `nix-shell`
* You're done!

### Using your own system's package manager

* Install [Elixir 1.8(+)](https://elixir-lang.org/install.html)
* Install [Node.js 10(+)](https://nodejs.org/en/download/)
* Install [PostgreSQL 10(+)](https://www.postgresql.org/download/)
* You're done!

## Setup

Setup the database

```
initdb --no-locale --encoding=UTF-8
pg_ctl start
createuser postgres --createdb
```

Setup the project

```
mix deps.get
mix ecto.setup
```

## Running the project

```
iex -S mix phx.server
```

