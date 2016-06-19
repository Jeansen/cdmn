
[![](https://img.shields.io/badge/license-GPLv3%20-blue.svg)](LICENSE)
[![Build Status](https://travis-ci.org/Jeansen/trc.svg?branch=master)](https://travis-ci.org/Jeansen/trc)


# TRC
TRC simply stands for *Top Right Corner*. It is a Perl extension for [urxvt](https://en.wikipedia.org/wiki/Rxvt-unicode) that gives you some indicators in the top right corner of your terminal window. You could think of it as some predefined LEDs with different colors depending on how much RAM is in use or what hard work your CPU is doing at the moment.

TRC ist written without any external Perl libraries. Everything is taken from within /proc.

TRC gives you four indicators for the utilization of:
- CPU
- DISK
- RAM
- NETWORK

The NETWORK indicator is a bit special. I developed this part to monitor my current Internet downstream utilization. Therefore I use the ability to query my AVM FritzBox router with a UPnP SOAP request and get the necessary data fields to calculate the current traffic in percentages. Ath the moment this is something that will only work, if you do own a FritzBox and even then you might have to activate UPnP first.

The indication is done in five stages. That is, if the utilization is less then 20%, the base color is used (light gray). The other stages are represented with different colors for utilizations greater than 20% (green), 40% (blue), 60% (organge) and 80% (red).

Here's a short animation of what it looks like.

![](https://cloud.githubusercontent.com/assets/9211499/16177977/63aa7bee-363c-11e6-9fcb-124d498f1922.gif)

In this animation I just create a file of 5GB in size and write some random data to it. The top-right indicator shows the CPU, following it the indicators for DISK, RAM and NETWORK. As expected the DISK indicator lights up. Since there is not much going on else, RAM is between 20 and 40%. The same is true for the CPU. NETWORK is not in use, so it stays in light gray.

For the moment most of the configuration is done within the code, but here is a plan of what I want to implement next:
- Introduce more configuration options via .Xressoureces. Especially for the NETWORK indicator, since this is something that is only available to users who have the necessary hardware setup.
- Make the NETWORK indicator more generic. Currently this is only something working with AVM routers.
- Define default keysyms
- Support indicators for multiple NICs, CPUs and DISKs, etc ...
- Optimize (Perl is not my major language and I am still in the process of learning)


# Installation
Just clone this repository to a place of your liking and call `urxvt -pe /path/to/trc` or put a symlink in ~/.urxvt.
and set or add `URxvt*perl-ext-common: trc` in ~/.Xressources

# Please note
As you might already see from the explanations above: There is no release, yet. This extension is with relevance to its current stage [bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often) and I only have tested it on my Linux machine which is running [DebianStretch](https://wiki.debian.org/DebianStretch)

# Contributing
Fork it, make a Pull Request, write me an eMail with suggestions ... You are always welcome to contribute!

# Self-Promotion
Like TRC? Follow me and/or the repository on GitHub.

# License
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
