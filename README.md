
[![](https://rawgit.com/Jeansen/assets/master/license.svg)](LICENSE)
![](https://rawgit.com/Jeansen/assets/master/project-status.svg)
![](https://rawgit.com/Jeansen/assets/master/rxvt.svg)
![](https://rawgit.com/Jeansen/assets/master/version.svg)
[![Build Status](https://travis-ci.org/Jeansen/trc.svg?branch=master)](https://travis-ci.org/Jeansen/trc)

# QED
QED is a Perl extension for [urxvt](https://en.wikipedia.org/wiki/Rxvt-unicode) which extends urxvt to show the 
utilization of different system resources, namely:

- CPU
- DISK
- RAM
- NETWORK (LAN, WAN)

Originally I just wanted to have som LED-like indicators but soon decided to make this extension more verbose and 
changed the simple LED look to animated bars. With time, increasing knowledge and a lot of trial and error, I 
continued to optimize the UX and added additional features.

I tried to make the tool as indempotent as possible. But for querying the filesystem I had to resort to an external 
library. I plan to remove this dependency in the future.

Here's a short animation of what it looks like.

![](https://cloud.githubusercontent.com/assets/9211499/16177977/63aa7bee-363c-11e6-9fcb-124d498f1922.gif)

In this animation I just create a file of 5GB in size and write some random data to it. The top-right indicator shows the CPU, following it the indicators for DISK, RAM and NETWORK. As expected the DISK indicator lights up. Since there is not much going on else, RAM is between 20 and 40%. The same is true for the CPU. NETWORK is not in use, so it stays in light gray.

Perl is not my major language and I am still in the process of learning. If someone notices things that could be done
 more elegantly, please make a pull-request.


# Installation
Just clone this repository to a place of your liking and call `urxvt -pe /path/to/qed` or put a symlink in ~/.urxvt.
and set or add `URxvt*perl-ext-common: qed` in ~/.Xressources

# Please note
As you might already see from the explanations above: There is no release, yet. This extension is with relevance to its current stage [bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often) and I only have tested it on my Linux machine which is running [DebianStretch](https://wiki.debian.org/DebianStretch)

# Contributing
Fork it, make a Pull Request, create an Issue with suggestions, bugs ore questions ... You are always welcome to 
contribute!

# Self-Promotion
Like QED? Follow me and/or the repository on GitHub.

# License
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
