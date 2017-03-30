
[![](https://rawgit.com/Jeansen/assets/master/license.svg)](LICENSE)
![](https://rawgit.com/Jeansen/assets/master/project-status.svg)
![](https://rawgit.com/Jeansen/assets/master/rxvt.svg)
![](https://rawgit.com/Jeansen/assets/master/version.svg)
<!--[![Build Status](https://travis-ci.org/Jeansen/trc.svg?branch=master)](https://travis-ci.org/Jeansen/trc)-->

# cdmn
*cdmn* (**c**pu, **d**isk, **m**emory, **n**etwork) is a Perl extension for [urxvt](https://en.wikipedia.org/wiki/Rxvt-unicode) which extends urxvt to show the utilization of different system resources.

Originally I just wanted to have some LED-like indicators but soon decided to make this extension more verbose and 
changed the simple LED look to animated bars. With time, increasing knowledge and a lot of trial and error, I 
continued to optimize the UX and added additional features.

I tried to make the tool as indempotent as possible. But for querying the filesystem I had to resort to an external 
library. I plan to remove this dependency in the future.

Here's a screenshot of what it looks like:

![](https://rawgit.com/Jeansen/assets/master/examples/cdmn_1.png)

And here is another example of the additional panel with very simple filesystem information:

![](https://rawgit.com/Jeansen/assets/master/examples/cdmn_2.png)

# Known Issues (To be fixed soon!)
If the window has focus but the mouse pointer is not over it input does not work :-(

# Installation
Install urxvt with `sudo apt-get install rxvt-unicode-256color`. **Make sure the version is 9.22. Anything else may 
not work!**<br>
Install Perl library Filesys::Df with `sudo apt-get install libfilesys-df-perl`

Then clone this repository to a place of your liking and set the resource `URxvt*perl-lib`.
For instance, put  this in your .Xresources file: `URxvt*perl-lib: /home/<USERNAME>/.urxvt/` and 
load the changes with `xrdb -load ~/.Xresources`. Then create the folder `mkdir ~/.urxvt` and put a symlink in it `ln
 -s /path/to/git-project/cdmn ~/.urxvt/cdmn`. 
 
Now, when you call rxvt with `urxvt -pe cdmn`. Make sure you update the git clone on a regular basis to enjoy new 
features and improved stability.
 
Of course you can have the extension loaded automatically by adding the resource `URxvt*perl-ext-common: cdmn` 
to your .Xresources file. But I would not recommend it at the moment.

## Using cdmn with wireless NICs
Wireless is a bit of a speciality because there is no constant maximal rx/tx speed. The value is constantly evaluated 
and unfortunately not available via *sysfs* or *procfs*. Therefore cdmn uses `iwconfig` as part of its calculation. 
Unfortunately this requires root privileges. To make thinks work, put the following in `/et/sudoers`:

    <username> ALL = NOPASSWD: /sbin/iwconfig
    

# Default keysyms

| Keysym    | Function  |
| --------- | --------- |
| Meta-l    | Show left panel |
| Meta-o    | Toggle visibility in overlay style |
| Meta-h    | Toggle visibility in bar style <br> Switch from overlay to bar style |

# How to use cdmn
*cdmn* offers two visual styles. The *overlay* style simply does what the name already implies. It creates an 
overlay on top of the current terminal. This style will not interfere with your terminal output. If some text is not 
visible, just hide *cdmn* for a moment. This is what the `Meta-o` binding is for. 

On the other hand, if you don't want *cdmn* to blank out some of the terminals output or interfere with your current 
typing, then simply use the *bar* style. With this style a complete line will be reserved for *cdmn*. You can switch to 
this style with `Meta-h`. This binding will also toggle the visibility of *cdmn* while using the bar style.

If you want to return to the overlay style just make *cdmn* invisible and use the `Meta-o` binding again.

Additional information can be accessed with the `Meta-l` binding. At the moment this will only show some simple 
filesystem information. But there are already plans for more ...

Normally the Meta key maps to the the ALT key. If the bindings do not work, please check your system mappings.

# My distibution does not have rxvt-unicode-256color 9.22

It might happen that your distribution does not offer version 9.22 of rxvt, even not via backports 
or other repositories. In this case you can still compile rxvt yourself. I recommend to first install the available 
version of your distribution anyway to pull in all its dependencies. Then uninstall it directly afterwards (but 
keep the dependencies). Now you can build rxvt yourself. This should take less than 5 minutes. Here is what you need to do on Debian:

- First you will need to install some development packages to compile rxsvt with all the necessary features.
 
        sudo apt-get install libxft-dev libperl-dev checkinstall

- Get the source from [http://dist.schmorp.de/rxvt-unicode/](http://dist.schmorp.de/rxvt-unicode/) and extract it to a 
place of your liking. Navigate into the just extracted folder and run the following commands:

        ./configure
        make
        checkinstall
    
After that a package with the name `rxvt-unicode` will be installed and you should able to call `urxvt`.
    

# How to customize cdmn (so far)

Here are some settings, that already work with more to come:

| Resource | Function | Default |
| --- | --- | --- |
| `URxvt.cdmn.caption-order` | List of captions to show and their order. This list must contain existing labels, otherwise the caption will be ignored. | DISK,CPU,RAM,NETWORK |
| `URxvt.cdmn.label.disk` | Label you would like to see next to the disk gauges. | DISK |
| `URxvt.cdmn.label.cpu` | Label you would like to see next to the cpu gauges. | CPU  |
| `URxvt.cdmn.label.ram` | Label you would like to see next to the memory gauges. | RAM |
| `URxvt.cdmn.label.network` | Label you would like to see next to the network gauges. | NETWORK |
| `URxvt.cdmn.padding` | How much space (in characters) you would like to have between each caption. | 2 |
| `URxvt.cdmn.x` | Horizontal position (by character) where values >= 0 will result in a left alignment and negative numbers in a right alignment. | -1 |
| `URxvt.cdmn.y` | Vertical position (by row) where 0 will be the first line and -1 the last. | 0 |

Here is an excerpt of the default settings. You can use this as a starting point for your custom overwrites in your 
**.Xresources** file.

    URxvt.cdmn.caption-order: CPU,DISK,RAM,NETWORK
    URxvt.cdmn.label.disk: DISK
    URxvt.cdmn.label.cpu: CPU
    URxvt.cdmn.label.ram: RAM
    URxvt.cdmn.label.network: NETWORK
    URxvt.cdmn.padding: 2
    URxvt.cdmn.x: -1
    URxvt.cdmn.y: 0

In addition you should set scrollbars to be invisible, activate 32bit colors and make the background black. Here is 
an suggestion of the minimal settings necessary. 

    URxvt*scrollBar:        false
    URxvt*background:       rgba:0000/0000/0000/f000
    URxvt*depth:            32
    URxvt*perl-lib:         /home/<USERNAME>/.urxvt/
    
I have put an example .Xresouces file with the minimal necessary settings, including some color overwrites to make it
 look like in the example screenshots. Make sure you adapt the line `URxvt*perl-lib: /home/<USERNAME>/.urxvt/` 
 accordingly.

# Please note
This extension is with relevance to its current stage [bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often). If you followed the installation instructions above it should run on any Debian based distribution, though.

# What am I working on currently?
- Most of the configurations in use are in code. Currently I am in the process to make things work via .Xresources 
and document the settings here.
- Make handling of deactivated/disconnected NICs configurable, that is: Do not show such interfaces or use visual 
cues for their state.

# What's next (without priority)
- Cleanup the code, remove magic numbers, add comments, improve robustness, level-up the code quality, resolve TODOs, 
improve documentation - these are constant tasks ...
- Make *cdmn* more aware of hardware changes. For instance, the current implementation will show you any harddisk, even if
 no mount points exist for it. In addition, if a harddisk is hot-plugged, *cdmn* will not be aware of it.
- *cdmn* only gives you some short information on what is going on. I plan to add more details to the panel.
- Create a .deb package (and hopefully others, too).
- Add battery status
- Add entry points for other extensions, introduce a plug-in API
- Add diffrent visual styles
- Add time graphs
- WAN gauge - for (home) workstations it might be of interest to see the current speed used.

# Contributing
Fork it, make a Pull Request, create Issues with suggestions, bugs ore questions ... You are always welcome to 
contribute!

# Self-Promotion
Like cdmn? Follow me and/or the repository on GitHub.

# License
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
