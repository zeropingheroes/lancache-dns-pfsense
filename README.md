# lancache-dns-pfsense

pfSense DNS server configuration generator for running a lancache. Pulls the list of domains from `uklans/cache-domains`.

## Requirements

- Ubuntu Server 16.04
- pfSense 2.* using the "DNS Resolver" service

## Installation

1. `git clone https://github.com/zeropingheroes/lancache-dns-pfsense.git && cd lancache-dns-pfsense`

## Configuration

All configuration is done via environment variables:

1. `cp .env.example .env`
2. `nano .env`

Alternatively set the environment variables manually by running:

`export VARIABLE=value`

You can also use a comma to seperate multiple ip addresses, for example:

`export LANCACHE_IP="192.168.1.1,192.168.1.2"`

## Usage

1. `sudo ./generate.sh`
2. Copy the output from the console and paste into pfSense:
   * Services > DNS Resolver > General Settings > Custom Options
   
The config is also available from `/tmp/lancache-dns-pfsense/lancache-dns-pfsense.conf`
