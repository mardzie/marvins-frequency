+++
title = "How I set my blog up"
description = "What technologies I used and how I set them up."
date = 2026-01-13
draft = true

[taxonomies]
tags = ["web", "rust", "linode", "bash", "systemd", "sws (static web server)", "zola"]
categories = ["blog"]
+++

I've started working on this blog a few days ago and I have to say, it was very fun.
The idea lingered in my head for waaay longer, for about a year and now I finally got to do it.

I will split this post into two sections:
- The Server
- My editing space

I will start with my editing space but first an overview.

I start with editing configs and [Markdown](https://commonmark.org) files with [Neovim](https://neovim.io/) to configure and write posts.
Then I use [Zola](https://www.getzola.org/) to generate this blog as a static site and with a little [Bash](https://www.gnu.org/software/bash/manual/bash.html) script I wrote I upload the generated site to my Linode server (Nanode).
On my Linode server runs a Bash script as a [systemd](https://systemd.io/) service that replaces the old site data with the newly uploaded one.
After that [SWS](https://static-web-server.net) serves it to you.

# Editing space
I use [Zola](https://www.getzola.org/) to generate this blog. 
