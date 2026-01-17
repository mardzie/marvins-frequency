+++
title = "How I set my blog up"
description = "What technologies I used and how I set them up."
date = 2026-01-14

[taxonomies]
tags = ["web", "rust", "linode", "bash", "systemd", "sws (static web server)", "zola"]
categories = ["blog", "intermediate"]
+++

I've started working on this blog a few days ago, and I have to say, it was very fun.
The idea lingered in my head for waaay longer, for about a year and now, I finally got to do it.

I will split this post into two sections:
- [My Editing Space](#editing-space)
- [The Server](#the-server)

Here is the GitHub [repository](https://github.com/mardzie/marvins-frequency) where this blog's source lives.

I will start with my editing space but first an overview.

> I edit [Markdown](https://commonmark.org/) files with [Neovim](https://neovim.io/).  
> Then build the blog with [Zola](https://www.getzola.org/).  
> Push it to the Linode server with a custom [Bash](https://www.gnu.org/software/bash/manual/bash.html) script I wrote.  
> Unpack it automatically on the server with a service I wrote (Just another Bash script).  
> [SWS (Static Web Server)](https://static-web-server.net/) serves the files to you!


<br>

# Editing Space
I use [Neovim](https://neovim.io/) to edit all configs and [Markdown](https://commonmark.org/) files.
Markdown is used by Zola to generate the blog's content.

[Zola](https://www.getzola.org/) is a static site generator written in Rust.
It uses Markdown to generate websites, and you can customize it with custom or [premade themes](https://www.getzola.org/themes/).

I use [Terminus](https://github.com/ebkalderon/terminus) as my theme.

The first thing I wrote was my `content/_index.md`, which is the homepage.
With `zola serve` or `zola serve --drafts` (if drafts should be shown), Zola serves the website locally.

If I am happy with my work I remove the draft tag from the file and deploy the site to my Linode Nanode server.

> [!NOTE]
> A Nanode is the smallest server size from Linode.  
> I have a Nanode which costs €5 a month has 1 vCPU and 1 GB RAM.

For deploying, I use my custom [Bash script](https://github.com/mardzie/marvins-frequency/blob/main/scripts/push.sh).
It builds and uploads the website to my server.


<br>

# The Server
On the server, a [service](https://github.com/mardzie/marvins-frequency/blob/main/scripts/services/marvins-frequency-updater.service)
runs the [Upload Watchdog](https://github.com/mardzie/marvins-frequency/blob/main/scripts/upload-watchdog.sh)
to catch the newly uploaded website and unpack it into the website directory.

Two <abbr title="Static Web Server">SWS</abbr> services, one for [https](https://github.com/mardzie/marvins-frequency/blob/main/scripts/services/marvins-frequency-sws-secure.service)
the other one for [http](https://github.com/mardzie/marvins-frequency/blob/main/scripts/services/marvins-frequency-sws.service), serve the files to the outside world.

Don't forget to open port 80 for http and port 443 for https or else no one can access the website.

To get an [SSL certificate](https://www.cloudflare.com/learning/ssl/what-is-an-ssl-certificate/), I used [Certbot](https://certbot.eff.org/) which I can recommend.
It issues a certificate fast, for free and renews it automatically.

The https SWS server uses [this config](https://github.com/mardzie/marvins-frequency/blob/main/scripts/configs/sws-secure.toml), which has the paths of the certificates to be able to use https.
The http SWS server uses [this config](https://github.com/mardzie/marvins-frequency/blob/main/scripts/configs/sws.toml) if anyone is interested.


<br>

# Conclusion
It took me only a few days to set this blog up, but it was great fun.

Thanks for reading and I wish you a nice day.
