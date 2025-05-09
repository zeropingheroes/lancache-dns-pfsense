# lancache-dns-unbound

Generate a configuration file for use with Unbound DNS server to redirect domains to
a lancache.

Thanks to [uklans.net](https://uklans.net/) for compiling and maintaining the list of domains.

## Setup

1. `git clone https://github.com/zeropingheroes/lancache-dns-pfsense.git`
2. `cp .env.example .env`
3. `nano .env`

You can also use a comma to seperate multiple ip addresses, for example:

`export LANCACHE_IP="192.168.1.1,192.168.1.2"`

## Usage
Run `./generate.sh` to generate an unbound configuration file.

### Install config in OPNsense

Copy the generated configuration file to `/usr/local/etc/unbound.opnsense.d/`

### Install config in pfSense

1. Navigate to **Services > DNS Resolver**
2. Scroll down to **Custom Options**
3. Paste in the contents of the generated file
