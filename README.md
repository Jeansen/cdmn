
[![](https://rawgit.com/Jeansen/assets/master/license.svg)](LICENSE)
![](https://rawgit.com/Jeansen/assets/master/project-status.svg)
![](https://rawgit.com/Jeansen/assets/master/rxvt.svg)
![](https://rawgit.com/Jeansen/assets/master/version.svg)
<!--[![Build Status](https://travis-ci.org/Jeansen/trc.svg?branch=master)](https://travis-ci.org/Jeansen/trc)-->

# cdmn
*cdmn* is a Perl extension for [urxvt](https://en.wikipedia.org/wiki/Rxvt-unicode) which extends urxvt to show the utilization of different system resources, namely:

- **C**PU
- **D**ISK
- **M**EMORY
- **N**ETWORK

Hence the name **cdmn**.

Originally I just wanted to have some LED-like indicators but soon decided to make this extension more verbose and 
changed the simple LED look to animated bars. With time, increasing knowledge and a lot of trial and error, I 
continued to optimize the UX and added additional features.

I tried to make the tool as indempotent as possible. But for querying the filesystem I had to resort to an external 
library. I plan to remove this dependency in the future.

Here's a screenshot of what it looks like:

![](https://rawgit.com/Jeansen/assets/master/examples/qed_1.png)

And here is another example of the additional panel with very simple filesystem information:

![](https://rawgit.com/Jeansen/assets/master/examples/qed_2.png)


# Installation
Install urxvt with `sudo apt-get install rxvt-unicode-256color`.<br>
Install Perl library Filesys::Df with `sudo apt-get install libfilesys-df-perl`

Then clone this repository to a place of your liking and call `urxvt -pe /path/to/cloned-project/qed`. 

If you do not want to always provide the full path to a perl extension you can set the resource `URxvt*perl-lib`. For
 instance, put  this in your .Xresources file: `URxvt*perl-lib: /home/<username>/.urxvt/` and load the changes with 
 `xrdb -load ~/.Xresources`. Then put a symlink in `~/.urxvt` with `ln -s /path/to/git-project/qed ~/.urxvt/qed`. 
 
From now on you can call rxvt with `urxvt -pe qed`. Make sure you update the git clone on a regular basis to enjoy new 
features and improved stability.
 
Of course you can have the extension loaded automatically by adding the resource `URxvt*perl-ext-common: qed` 
to your .Xresources file. But I would not recommend it at the moment.

#Default keysyms
| Keysym    | Function  |
| --------- | --------- |
| Meta-l    | Show left panel |
| Meta-o    | Toggle visibility in overlay style |
| Meta-h    | Toggle visibility in bar style <br> Switch from overlay to bar style <br> |

# How to use cdmn
*cdmn* offers two visual styles. The *overlay* style simply does what the name already implies. It creates an 
overlay on top of the current terminal. This style will not interfere with your terminal output. If some text is not 
visible, just hide *cdmn* for a moment. This is what the `Meta-o` binding is for. 

On the other hand, if you don't want *cdmn* to blank out some of the terminals output or interfere with your current 
typing, then simply use the *bar* style. In this mode a complete line will be reserved for *cdmn*. You can switch to this 
style with `Meta-h`. This binding will also toggle the visibility of *cdmn* while using the bar style.

If you want to return to the overlay style just make *cdmn* invisible and use the `Meta-o` binding again.

Additional information can be accessed with the `Meta-l` binding. At the moment this will only show some simple 
filesystem information. But there are already plans for more ...

Normally the Meta key maps to the the ALT key. If the bindings do not work, please check your system mappings.

# Hot to customize cdmn
TODO

# Please note
This extension is with relevance to its current stage [bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often). If you followed the installation instructions above it should run on any Debian based distribution, though. 

# What am I working on currently?
Most of the configurations in use are in code. Currently I am in the process to make things work via .Xresources 
and document the settings here.

# What's next (without priority)
- Clean the code, remove magic numbers, add comments, level-up the code quality, resolve TODOs, improve documentation - 
these are constant tasks ...
- Make *cdmn* more aware of hardware changes. For instance, the current implementation will show you any harddisk, even if
 no mount points exist for it. In addition, if a harddisk is hot-plugged, *cdmn* will not be aware of it.
- *cdmn* only gives you some short information on what is going on. I plan to add more details to the panel. 
- Create a .deb package (and hopefully others, too).
- Add battery status
- Add entry points for other extensions, introduce a plug-in API
- Add diffrent visual styles
- Add time graphs

# Contributing
Fork it, make a Pull Request, create an Issue with suggestions, bugs ore questions ... You are always welcome to 
contribute!

# Self-Promotion
Like QED? Follow me and/or the repository on GitHub.

# License
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
