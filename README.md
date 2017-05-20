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


# Installation
Before using the package provided by your distribution, I strongly recommend that you [compile rxvt-unicode yourself](#how-to-compile-rxvt-unicode). While developing this extension I came across a bug that results in constant memory consumption over time.

Anyway, if you first want to check what this extension can do for you, there is still the option of installing rxvt with `sudo apt-get install rxvt-unicode-256color`. 

**Make sure the version is 9.22. Anything else may not work!**

Install Perl library Filesys::Df with `sudo apt-get install libfilesys-df-perl`

Then clone this repository to a place of your liking and set the resource `URxvt*perl-lib`.

For instance, put  this in your .Xresources file: `URxvt*perl-lib: /home/<USERNAME>/.urxvt/` and 
load the changes with `xrdb -load ~/.Xresources`.

Then create the folder `mkdir ~/.urxvt` and put a symlink in it `ln -s /path/to/git-project/cdmn ~/.urxvt/cdmn`. 
 
Now, you can call rxvt with `urxvt -pe cdmn`. Make sure you pull updates on a regular basis to enjoy new features and
 improved stability.
 
Of course you can have the extension loaded automatically by adding the resource `URxvt*perl-ext-common: cdmn` 
to your .Xresources file. But I would not recommend it at the moment.

## Using cdmn with wireless NICs
Wireless is a bit of a speciality because there is no constant maximal rx/tx speed. The value is constantly evaluated 
and not available via *sysfs* or *procfs*. Therefore cdmn uses `iwconfig` as part of its calculation. 
Unfortunately this requires root privileges. To make thinks work, put the following in `/et/sudoers`:

    <username> ALL = NOPASSWD: /sbin/iwconfig
    

# Default keysyms
| Keysym    | Function  |
| --------- | --------- |
| Meta-l    | Show left panel |
| Meta-o    | Toggle visibility in overlay style |
| Meta-h    | Toggle visibility in bar style <br> Switch from overlay to bar style |


# How to use cdmn
*cdmn* offers two visual modes: overlay and bar.

The *overlay* mode simply does what the name already implies. It creates an overlay on top of the current terminal. This style will not interfere with your terminal output. If some text is not visible, just hide *cdmn* for a moment. This is what the `Meta-o` binding is for. 

On the other hand, if you don't want *cdmn* to blank out some of the terminals output or interfere with your current typing, then simply use the *bar* mode. In this mode a complete line will be reserved for *cdmn*. You can switch to this mode with `Meta-h`.

Each binding can be used to switch modes or to hide and show cdmn in a given mode. For instance, if you were in 
overlay mode you could use `Meta-h` to go to bar mode and then use `Meta-h` repeatedly to toggle the visibility of 
cdmn. Justtry it! It should be fairly intuitive.

Additional information can be accessed with the `Meta-l` binding. At the moment this will only show some simple 
filesystem information. But there are already plans for more ...

Normally the Meta key maps to the ALT key. If the bindings do not work, please check your system mappings.


# How to compile rxvt-unicode
It might happen that your distribution does not offer version 9.22 of rxvt, even not via backports or other repositories. In this case you can still compile rxvt yourself. I recommend to first install the available version of your distribution anyway to pull in all its dependencies. Then uninstall it directly afterwards (but keep the dependencies). Now you can build rxvt yourself. This should take less than 5 minutes. Here is what you need to do on Debian:

- First you will need to install some development packages to compile rxvt with all the necessary features.
 
        sudo apt-get install libxft-dev libperl-dev checkinstall

- Get the source from [http://dist.schmorp.de/rxvt-unicode/](http://dist.schmorp.de/rxvt-unicode/) and extract it to a 
place of your liking. Navigate into the just extracted folder and run the following commands:

        patch /path/to/cdmn/resources/rxvtperl.xs.path src/rxvtperl.xs
        ./configure --enable-everything --enable-256-color
        make
        sudo checkinstall
    
After that a package with the name `rxvt-unicode` will be installed and you should be able to call `urxvt`.
    

# How to customize cdmn (so far)
Here are some settings, that already work with more to come:


## Labels
Labels can be defined with the following resource settings. Each label defines the text you would like to see next to 
the corresponding gauges:

| Resource | Default |
| --- | --- |
| `URxvt.cdmn.label.disk` | DISK |
| `URxvt.cdmn.label.cpu` | CPU |
| `URxvt.cdmn.label.memory` | MEM |
| `URxvt.cdmn.label.network` | NET |
| `URxvt.cdmn.label.cpu.temp` | TEMP |
| `URxvt.cdmn.label.battery` | BAT|

In addition you can set colors for different parts. All colors default to the terminal foreground (-2) or background 
(-1). Normally you will not need to use these values. After all, they are the defaults. But you might want to 
use any number between 0 and 255.

| Resource | Function | Default |
| --- | --- | --- |
| `URxvt.cdmn.label.fg` | Foreground color for all labels. | -2 |
| `URxvt.cdmn.label.bg` | Background color for all labels. | -2 |
| `URxvt.cdmn.caption.bg` | Global background, e.g. padding. | -2 |
| `URxvt.cdmn.gauges.bg` | Background, for each gauge. | -2 |

Want to know what colors have which number? Try this one-liner in your terminal and see for yourself:

    for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"

## Layout
Beginning with the layout, you can define the position, order, initial visibility and more with the following settings.

| Resource | Function | Default |
| --- | --- | --- |
| `URxvt.cdmn.padding` | How much space (in characters) you would like to have between each caption. | 2 |
| `URxvt.cdmn.x` | Horizontal position (by character) where values >= 0 will result in a left alignment and negative numbers in a right alignment. | -1 |
| `URxvt.cdmn.y` | Vertical position (by row) where 0 will be the first line and -1 the last. | 0 |
| `URxvt.cdmn.gauges.order` | List of gauges to show and their order. This list must contain existing labels. | DISK,CPU,MEM,NETWORK |
| `URxvt.cdmn.showing` | Initially show gauges. | 1 |
| `URxvt.cdmn.showing.labels` | Initially show labels. | 1 |


## Visual styles
You can further define the visual representation with the following settings.

| Resource | Function | Default (Other) |
| --- | --- | --- |
| `URxvt.cdmn.cpu.temp`, `URxvt.cdmn.temp`, `URxvt.cdmn.battery` | How much detail, e.g. a gauge for every logical core or just one gauge. | simple (detail ) |
| `URxvt.cdmn.style` | Visual representation. | bar (block, led) |


## Visual styles - gauges colors
In addition you can define a list of colors that will serve as a visual cue for different values. This will be most 
useful when using the LED style. Suppose you would like to simulate a red LED that increases in brightness for every 
20%. Setting `URxvt.cdmn.gauges.colors` to '0,52,88,124,160,196' would just do that, where the first color is the 
color of inactivity - in this case 0 which is black.

You can also set (and overwrite) colors individually for each gauge with the following resources:

    URxvt.cdmn.colors.network
    URxvt.cdmn.colors.disk
    URxvt.cdmn.colors.cpu
    URxvt.cdmn.colors.cpu.temp
    URxvt.cdmn.colors.memory 
    URxvt.cdmn.colors.battery


## Visual styles - refresh rate and sensitivity
Even further tweaking is possible with options such as the refresh rate and sensitivity. The refresh rate is simply 
the time in seconds when all gauges should be updated or how fast the LED should blink. The sensitivity on the
 other hand defines the threshold when to first indicate any change, at all.
 
Here is an example. Say we have the following settings excerpt:
    
    URxvt.cdmn.gauges.order: CPU 
    URxvt.cdmn.gauges.colors: 0,52,88,124,160,196
    URxvt.cdmn.style: led
    URxvt.cdmn.refresh: 1
    URxvt.cdmn.sensitivity: 1

This results in a flashing LED-like gauge for CPU activity that has 5 red tones (a brighter tone for every 20% 
increase), which flashes (updates) every second but only if there is at least 1% of activity. Setting the sensitivity
 to 50 would result in the LED-like gauge to flash first at 50% load with the color of 124. It is also possible 
 to use fractions of seconds, e.g. 0.1, 1.1 and so on.


## Visual styles - invert
It might be of interest to revert some colors, especially when you are interested in how much energy is left when on 
battery power. But of course this is open for debate ;-) Anyway, you cant set `URxvt.cdmn.gauges.invert` to a list 
of labels for which gauges should use inverted colors. BAT ist inverted be default.


## Miscellaneous settings
Finally there are some settings that allow you to further tweak cdmn.

| Resource | Function | Default (Other) |
| --- | --- | --- |
| `URxvt.cdmn.disk.mounts` | Only show disk gauges for disks with at least one mount point. | 0 (1) |


## Resource Settings

In addition you should set scrollbars to be invisible, activate 32bit colors and make the background black. Here is 
an suggestion of the minimal settings necessary. 

    URxvt*scrollBar:        false
    URxvt*background:       rgba:0000/0000/0000/f000
    URxvt*depth:            32
    URxvt*perl-lib:         /home/<USERNAME>/.urxvt/
    
There is an initial .Xresouces file in de resources folder with some minimal necessary settings, including some 
color overwrites to make it look like the example screenshots. Make sure you adapt the line `URxvt*perl-lib: 
/home/<USERNAME>/.urxvt/` accordingly.
 
 
# Some words about robustness
With reference to the [robustness principle](https://en.wikipedia.org/wiki/Robustness_principle) cdmn will silently 
ignore incompatible or invalid values or configurations and apply defaults where applicable.
 
In addition, if you do not tell cdmn anything it will assume everything. This is also true if only invalid 
values have been supplied for any resource. Say you want to view gauges for eth0 and eth1 but actually the interface 
names are enp3s0 und enp3s1. After validation this would result in an empty list which to cdmn is the same as if this
 resource had not been configured. Therefore cdmn would fall back to its default setting: to show all there is.

On the other hand, cdmn will not show anything where nothing is to be shown. For example, if you tell cdmn to show 
network gauges but your network cable is not plugged in, gauges for this interface will not be shown. If all 
interfaces are down the network caption will not show up, at all.


# Please note
This extension is with relevance to its current stage [bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often). 
If you followed the installation instructions above it should run on any Debian-based distribution, though.

# What's next (without priority)
[Check the projects backlog](https://github.com/Jeansen/cdmn/projects/1) to see what I am currently working on and 
what is planned for the future.

# Contributing
Fork it, make a Pull Request, create Issues with suggestions, bugs or questions ... You are always welcome to 
contribute!

# Self-Promotion
Like cdmn? Follow me and/or the repository on GitHub.

# License
GNU GENERAL PUBLIC LICENSE Version 3, 29 June 2007
