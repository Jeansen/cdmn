![](https://rawgit.com/Jeansen/assets/master/project-status.svg)
![](https://rawgit.com/Jeansen/assets/master/version.svg)
[![](https://rawgit.com/Jeansen/assets/master/license.svg)](LICENSE)

<!--[![Build Status](https://travis-ci.org/Jeansen/trc.svg?branch=master)](https://travis-ci.org/Jeansen/trc)-->

# cdmn

_cdmn_ (**c**pu, **d**isk, **m**emory, **n**etwork) is a Perl extension for [urxvt](https://en.wikipedia.org/wiki/Rxvt-unicode) which 
extends urxvt to show the utilization of different system resources.

Originally I planned to have some LED-like indicators but soon decided to make this extension more verbose and 
changed the simple LED look to animated bars. With time, increasing knowledge and a lot of trial and error, I 
continued to optimize the UX and added additional features.

Here's a screenshot of what it looks like:

![](https://rawgit.com/Jeansen/assets/master/examples/cdmn_1.png)

And here is another example of the additional panel with very simple filesystem information:

![](https://rawgit.com/Jeansen/assets/master/examples/cdmn_2.png)

# Curious? Run the demo!

I have created a dedicated docker container for easy demonstrations. 
Given you have [installed docker](https://docs.docker.com/engine/installation/linux/docker-ce/debian/) just run the 
following commands:

    cd /tmp
    git clone https://github.com/Jeansen/cdmn.git
    /tmp/cdmn/resources/test/run.sh -e /tmp/cdmn/cdmn -x /tmp/cdmn/resources/test/Xresources_demo

If you do not see anything after the docker image finished downloading or the created window is very small you might 
need to comment out a font setting. Simply prepend a `!` to the line starting with `URxvt*font:` in 
`tmp/cdmn/resources/test/Xresources_demo` and try again.

To simulate some cpud,disk and memory load play around with the following command:

    stress-ng --cpu 4 --io 3 --vm 2 --vm-bytes 1G --timeout 5s

# Installation

Before using the package provided by your distribution, I strongly recommend that you 
[compile rxvt-unicode yourself](#how-to-compile-rxvt-unicode). While developing this extension I came across a bug that 
results in constant memory consumption over time.

Anyway, if you first want to check what this extension can do for you, there is still the option of installing rxvt 
with `sudo apt-get install rxvt-unicode-256color`. 

**Make sure the version is 9.22. Anything else may not work!**

Install needed Perl libraries: `sudo apt-get install libfilesys-df-perl libparams-validate-perl`

Then clone this repository to a place of your liking, e.g. `git clone https://github.com/Jeansen/cdmn.git ~/cdmn` and 
set the resource `URxvt*perl-lib`. In this example this would be  `URxvt*perl-lib: /path/to/cdmn/`.

Then load the changes with `xrdb -load ~/.Xresources`.

Now, run `urxvt -pe cdmn`. 

Make sure you pull updates on a regular basis to enjoy new features and improved stability.

Of course you can have the extension loaded automatically by adding the resource `URxvt*perl-ext-common: cdmn` 
to your .Xresources file. But I would not recommend it at the moment.

Also have a look in the `resources/test` folder. There are some demo files that you can use a a starting point.

## Using cdmn with wireless NICs

Wireless is a bit of a speciality because there is no constant maximal rx/tx speed. The value is constantly evaluated 
and not available via _sysfs_ or _procfs_. Therefore cdmn uses `iwconfig` as part of its calculation. 
Unfortunately this requires root privileges. To make thinks work, put the following in `/et/sudoers`:

    <your username here> ALL = NOPASSWD: /sbin/iwconfig

# Default keysyms

| Keysym | Function                                                                     |
| ------ | ---------------------------------------------------------------------------- |
| Meta-l | Show/Hide left labels                                                        |
| Meta-o | Show/Hide captions in overlay mode                                           |
| Meta-h | Show/Hide captions in normal mode <br> Toggle between overlay to normal mode |
| Meta-p | Show/Hide sidebar                                                            |
| Meta-k | Show next pane                                                               |
| Meta-j | Show previous pane                                                           |
| Ctrl-k | Scroll up in current pane                                                    |
| Ctrl-j | Scroll down in current pane                                                  |

Normally the Meta key maps to the ALT key. If the bindings do not work, please check your system mappings.

If you do not like the default settings, you can [change them](#custom-keysyms).

# How to use cdmn

_cdmn_ offers two visual modes: overlay and normal.

The _overlay_ mode simply does what the name already implies. It creates an overlay on top of the current terminal. 
If some text is not visible, just hide _cdmn_ for a moment. This is what the `Meta-o` binding is for. 

On the other hand, if you don't want _cdmn_ to blank out some of the terminals output or interfere with your current 
typing, then simply use _normal_ mode. In this mode a complete line or column (depending on your settings) will be 
reserved for _cdmn_. You can switch to this mode with `Meta-h`.

Each binding can be used to switch modes or to hide and show _cdmn_ in a given mode. For instance, if you are in 
overlay mode you can use `Meta-h` to go to normal mode and then use `Meta-h` repeatedly to toggle the visibility of 
_cdmn_. Just try it! It should be fairly intuitive.

Additional information can be accessed with the `Meta-p` binding. This will show the sidebar containing multiple 
panes with more verbose information. Use `Meta-j` and `Meta-k` to navigate between these panes and `Ctrl-j` and `Ctrl-k`
to scroll up and down. Don't worry, you will be able to set these bindings, soon.

The sidebar is in heavy development at the moment. Stay tuned but do not expect too much ;-)

# How to customize cdmn

Following is a list of gauges you can customize to your liking:

| Gauge name | Description                                           |
| ---------- | ----------------------------------------------------- |
| disk       | Disk utilization                                      |
| cpu        | CPU utilization                                       |
| memory     | Available/Used memory                                 |
| network    | Network utilization                                   |
| cpu_temp   | CPU temperature                                       |
| battery    | Battery status                                        |
| mount      | Used/remaining space for mount points                 |
| hidpp      | Battery status of HID++ devices (Mice, Keyboard, ...) |

## Labels

Labels can be defined with the following resources. Each label defines the text you would like to see next to the 
corresponding gauges:

| Resource                    | Default |
| --------------------------- | ------- |
| `URxvt.cdmn.label.disk`     | DISK    |
| `URxvt.cdmn.label.cpu`      | CPU     |
| `URxvt.cdmn.label.memory`   | MEM     |
| `URxvt.cdmn.label.network`  | NET     |
| `URxvt.cdmn.label.cpu_temp` | TEMP    |
| `URxvt.cdmn.label.battery`  | BAT     |
| `URxvt.cdmn.label.mount`    | MOUNT   |
| `URxvt.cdmn.label.hidpp`    | HID     |
| `URxvt.cdmn.label.swap`     | SWAP    |

In addition you can set colors for different parts. All colors default to the terminal foreground (-2) or background 
(-1). Normally you will not need to use these values. After all, they are the defaults. But you might want to 
use any number between 0 and 255.

| Resource                | Function                         | Default (Other) |
| ----------------------- | -------------------------------- | --------------- |
| `URxvt.cdmn.label.fg`   | Foreground color for all labels. | -2 (0-155)      |
| `URxvt.cdmn.label.bg`   | Background color for all labels. | -1 (0-155)      |
| `URxvt.cdmn.caption.bg` | Global background, e.g. padding. | -2 (0-155)      |

Want to know what colors have which number? Try this one-liner in your terminal and see for yourself:

    for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"

And finally, you can define if you would like bold labels and where to position labels:

| Resource                    | Function        | Default (Other) |
| --------------------------- | --------------- | --------------- |
| `URxvt.cdmn.label.bold`     | Bold labels     | false (true)    |
| `URxvt.cdmn.label.position` | Labels position | left (right)    |

## Layout

Starting with the layout, you can define the position, order, initial visibility and more with the following resources.

| Resource                    | Function                                                                                                                        | Default              |
| --------------------------- | ------------------------------------------------------------------------------------------------------------------------------- | -------------------- |
| `URxvt.cdmn.padding`        | How much space (in characters) you would like to have between each caption (label + gauges).                                    | 2                    |
| `URxvt.label.padding`       | How much space (in characters) you would like to have between a label and its gauges.                                           | 1                    |
| `URxvt.cdmn.x`              | Horizontal position (by character) where values >= 0 will result in a left alignment and negative numbers in a right alignment. | -1                   |
| `URxvt.cdmn.y`              | Vertical position (by row) where 0 will be the first line and -1 the last.                                                      | 0                    |
| `URxvt.cdmn.gauges.order`   | List of gauges to show and their order. This list must contain existing labels.                                                 | CPU,DISK,MEM,NETWORK |
| `URxvt.cdmn.showing`        | Initially show gauges.                                                                                                          | 1                    |
| `URxvt.cdmn.showing.labels` | Initially show labels.                                                                                                          | 1                    |

More fine-grained settings are possible with the following resources:

    URxvt.cdmn.gauges.disks
    URxvt.cdmn.disk.read
    URxvt.cdmn.disk.write
    URxvt.cdmn.gauges.batteries
    URxvt.cdmn.gauges.cores
    URxvt.cdmn.network.rx
    URxvt.cdmn.network.tx
    URxvt.cdmn.gauges.mounts
    URxvt.cdmn.gauges.hidpps
    URxvt.cdmn.gauges.swaps

Each of the above resources expects a list of device names to show gauges for.

By default if you do not specify anything _cdmn_ will assume you would like to see everything. 

That is, if you do specify valid values for let's say `URxvt.cdmn.batteries` then you will only see what you specified.

There are some exceptions, though.

-   If you do not provide `URxvt.cdmn.network.rx` and/or `URxvt.cdmn.network.tx` then there will be only one gauge for each
    interface. On the other hand, if you do provide `URxvt.cdmn.network.rx` and/or `URxvt.cdmn.network.tx`, then you will
    only see those gauges. Ultimately you will have to provide for all interfaces you would like to see the moment you
    provide values for `URxvt.cdmn.network.rx` and/or `URxvt.cdmn.network.tx`. This also means you will have to provide
    values for 'rx' and 'tx' where the default was to only show one gauge combining 'rx' and 'tx' values.

-   The other exceptions to this rule are `URxvt.cdmn.disk.read` and `URxvt.cdmn.disk.write`. These act as an addition to 
    `URxvt.cdmn.gauges.disks` and allow you to define for which disks you would like to see additional read and/or write 
    utilization. Of course you could leave out `URxvt.cdmn.gauges.disks` and only provide values for disks you would like 
    to monitor in detail.

Note, that the additional gauges to `URxvt.cdmn.gauges.disks` are subsets of it. If you were to set all three settings to 
a value of `sda` and copied a large file from one folder to another on this disk, you would see three gauges:
One with about 100 percent for the combined read and write utilization and two others with about 50 percent each
because half of the time was spent reading in data and the other half of the time was spent writing data.

## Visual styles

Each [available gauge](#how-to-customize-cdmn) has the following settings that you can use 
to adapt its visual style.

| Resource                          | Function                                                                                     | Default (Other) |
| --------------------------------- | -------------------------------------------------------------------------------------------- | --------------- |
| `URxvt.cdmn.<guage>.style`        | The kind of gauges you prefer. Either a bar that can grow and shrink or simple flashing LED. | bar (led)       |
| `URxvt.cdmn.<guage>.graph.width`  | Width of graph in samplings, for example 5.                                                  | not set         |
| `URxvt.cdmn.<guage>.graph.expand` | If graph width should take up as much space as possible.                                     | not set         |
| `URxvt.cdmn.<guage>.detail`       | How much detail, e.g. a gauge for every logical core or just one gauge.                      | true (false)    |
| `URxvt.cdmn.<guage>.invert`       | Invert colors.                                                                               | true (false)    |
| `URxvt.cdmn.<guage>.colors`       | The colors to be used apart from any global setting.                                         | true (false)    |
| `URxvt.cdmn.<guage>.inverse`      | Inverse gauges value interpretation, e.g. a full bar for 0 instead for 100%.                 | true (false)    |

If you specify `URxvt.cdmn.<guage>.graph.width` and `URxvt.cdmn.<guage>.graph.expand`, the latter one takes precedence.

You can further define the visual representation and orientation with the following settings.

| Resource                       | Function                                           | Default (Other)   |
| ------------------------------ | -------------------------------------------------- | ----------------- |
| `URxvt.cdmn.visual.alignment`  | Vertical or horizontal alignment.                  | row (col)         |
| `URxvt.cdmn.style.bar.symbols` | Symbols to use for `URxvt.cdmn.<guage>.style: bar` | ⎯,▁,▂,▃,▄,▅,▆,▇,█ |
| `URxvt.cdmn.style.led.symbol`  | Symbol to use for `URxvt.cdmn.<guage>.style: led`  | ■                 |

## Visual styles - gauges colors

In addition you can define a list of colors that will serve as a visual cue for different values. This will be most 
useful when using the LED style. Suppose you would like to simulate a red LED that increases in brightness for every 
20%. Setting `URxvt.cdmn.gauges.colors` to '0,0,52,88,124,160,196' would just do that, where the first color defines 
the background color and all other are the foreground colors. The second color will be the color of inactivity - in 
this case 0 which is black.

You can also set (and overwrite) colors individually for each gauge with the following resources:

    URxvt.cdmn.network.colors
    URxvt.cdmn.disk.colors
    URxvt.cdmn.cpu.colors
    URxvt.cdmn.cpu_temp.colors
    URxvt.cdmn.memory.colors 
    URxvt.cdmn.battery.colors
    URxvt.cdmn.mount.colors

If you only define one color it will be interpreted as a foreground color. `URxvt.cdmn.gauges.bg` (either your value or 
the implicit default -2) will be used for the background color.

## Visual styles - refresh rate and sensitivity

Even further tweaking is possible with options such as the refresh rate and sensitivity. 

| Resource                 | Function                                                                                                        | Default (Other) |
| ------------------------ | --------------------------------------------------------------------------------------------------------------- | --------------- |
| `URxvt.cdmn.refresh`     | How often to take samples in seconds. Decimal numbers are possible, for example 0.1 for every 100 milliseconds. | 1               |
| `URxvt.cdmn.sensitivity` | Threshold at which to show changes                                                                              | 1               |

The refresh rate is simply the time in seconds when all gauges should be updated. The sensitivity on the other hand 
defines the threshold when to first indicate any change. 

Note that the sensitivity shrinks the delta for intermediate values. You maybe have set `URxvt.cdmn.gauges.colors` to 5 
color values (the first being the initial color) to show a visual cue for every 20 percent increase. If you set the 
sensitivity to 90 those values would be evaluated in the remaining delta of 10 instead of 100.

Here is an example. Say we have the following resources excerpt:

    URxvt.cdmn.gauges.order: CPU 
    URxvt.cdmn.gauges.colors: 0,52,88,124,160,196
    URxvt.cdmn.style: led
    URxvt.cdmn.refresh: 1
    URxvt.cdmn.sensitivity: 1

This results in a flashing LED-like gauge for CPU activity that has 5 red tones (a brighter tone for every 20% 
increase), which flashes (updates) every second but only if there is at least 1% of activity. Setting the sensitivity
 to 50 would result in the LED-like gauge to flash first at 50% load with the color of 124. It is also possible 
 to use fractions of seconds, e.g. 0.1, 1.1 and so on.

## Miscellaneous settings

Finally there are even more settings ...

| Resource                     | Function                                                       | Default (Other) |
| ---------------------------- | -------------------------------------------------------------- | --------------- |
| `URxvt.cdmn.disk.mountsonly` | Only show disk gauges for disks with at least one mount point. | true (false)    |

There is an initial .Xresouces file in the resources folder with some minimal necessary settings, including some 
color overwrites to make it look like the example screenshots. Make sure you adapt the line `URxvt*perl-lib: 
/home/<USERNAME>/.urxvt/` accordingly.

## Custom keysyms

If you do not like the default [keysyms](#default-keysyms), you can change them:

| Resource                                | Default     | Function                                                                     |
| --------------------------------------- | ----------- | ---------------------------------------------------------------------------- |
| `URxvt.cdmn.Keysym.labels.show`         | Meta-l      | Show/Hide labels                                                             |
| `URxvt.cdmn.Keysym.overlay.toggle`      | Meta-o      | Show/Hide cpations in overlay mode                                           |
| `URxvt.cdmn.Keysym.toggle`              | Meta-h      | Show/Hide cpations in normal mode <br> Toggle between overlay to normal mode |
| `URxvt.cdmn.Keysym.sidebar.toggle`      | Meta-p      | Show/Hide sidebar                                                            |
| `URxvt.cdmn.Keysym.sidebar.pane.next`   | Meta-k      | Show next pane                                                               |
| `URxvt.cdmn.Keysym.sidebar.pane.prev`   | Meta-j      | Show previous pane                                                           |
| `URxvt.cdmn.Keysym.sidebar.scroll.up`   | Ctrl-k      | Scroll up in current pane                                                    |
| `URxvt.cdmn.Keysym.sidebar.scroll.down` | Ctrl-j      | Scroll down in current pane                                                  |
| `URxvt.cdmn.Keysym.sidebar.shrink`      | Ctrl-period | Shrink the sidebar by one column                                             |
| `URxvt.cdmn.Keysym.sidebar.expand`      | Ctrl-comma  | Expand the sidebar by one column                                             |

# How to customize the sidebar (so far)

Now, while still in development, there are already some things that work and that you can customize:

| Resource                             | Function                                             | Default (Other)                   | Notes                                                                                  |
| ------------------------------------ | ---------------------------------------------------- | --------------------------------- | -------------------------------------------------------------------------------------- |
| `URxvt.cdmn.sidebar.bg`              | Background color                                     | Terminal background (0-255)       |                                                                                        |
| `URxvt.cdmn.sidebar.fg`              | Foreground color                                     | Terminal foreground (0-255)       |                                                                                        |
| `URxvt.cdmn.sidebar.border.fg`       | Border color                                         | Terminal foreground (0-255)       |                                                                                        |
| `URxvt.cdmn.sidebar.width`           | How much space to use for the sidebar in percentages | 50 (30-100)                       | If `URxvt.cdmn.sidebar.position` set to `left` or `right`                              |
| `URxvt.cdmn.sidebar.height`          | How much space to use for the sidebar in percentages | 40 (30-100)                       | If `URxvt.cdmn.sidebar.position` set to `bottom` or `top`                              |
| `URxvt.cdmn.sidebar.position`        | Sidebar position                                     | right (top, bottom, left, center) |                                                                                        |
| `URxvt.cdmn.sidebar.header.position` | Header position                                      | top (bottom)                      |                                                                                        |
| `URxvt.cdmn.sidebar.label.position`  | Label position for graphs                            | top (bottom)                      |                                                                                        |
| `URxvt.cdmn.sidebar.graph.symbols`   | Use given symbols for depicting graphs               | '■, □' (ANY)                      | Any character or list of two characters, e.g.: <br><br> █ ░ <br> ▪ ▫ <br> ▬ ▭ <br> ○ ● |
| `URxvt.cdmn.sidebar.border.visible`  | Show border                                          | 1 (0)                             | If `URxvt.cdmn.sidebar.position` set to `bottom` or `top`                              |

Most of these settings should be self-explanatory. Some values are only taken into account with specific sidebar positions. 
For instance, if you set `URxvt.cdmn.sidebar.position` to `left` or `right`, only your setting for `URxvt.cdmn.sidebar.width` 
will be honored whereas `URxvt.cdmn.sidebar.height` will be fixed at 100%. Similarly, if you set `URxvt.cdmn.sidebar.position` 
to `top` or `bottom` only your setting for `URxvt.cdmn.sidebar.height` will be honored whereas `URxvt.cdmn.sidebar.width` 
will be fixed at 100%. Finally, `center` will set both, width and height, to 100% and ignore any of your settings for
width and height. In addition you can decide if you would like to have a border when you position the sidebar left or right.

For the graphs shown on each pane you can set the symbols to use. Generally, there are two symbols. One symbols serves as
the background and the other serves as the indicator. But you can also leave out the second symbols if you want to have a
transparent effect. Depending on the order you can decide how the graphs will fill - either from left to right or vice-versa.
Just play with the settings and see what fits best for you!

# Context awareness

_cdmn_ tries hard to watch for any changes. For instance, if you remove your laptop from any power supply, _cdmn_ 
will be aware of this change and render the label next to your battery gauge(s) differently by removing the 
flash symbol.

If you do not overwrite the default settings, _cdmn_ will show you everything available and all changes it becomes 
aware of. On the other hand, if you do define some overwrites _cdmn_ will show you only those. If a specified device 
is not available, it will be simply ignored until it is available. 

# Some words about robustness

With reference to the [robustness principle](https://en.wikipedia.org/wiki/Robustness_principle) cdmn will silently 
ignore incompatible or invalid values or configurations and apply defaults where applicable.

In addition, if you do not tell cdmn anything it will assume everything. This is also true if only invalid 
values have been supplied for any resource. Say you want to view gauges for eth0 and eth1 but actually the interface 
names are enp3s0 und enp3s1. After validation this would result in an empty list which to _cdmn_ is the same as if this
resource had not been configured. Therefore _cdmn_ would fall back to its default setting: and show everything there is.

On the other hand, _cdmn_ will not show anything where nothing is to be shown. For example, if you tell _cdmn_ to show 
network gauges but your network cable is not plugged in, gauges for this interface will not be shown. If all 
interfaces are down the network caption will not show up, at all.

# How to compile rxvt-unicode

It might happen that your distribution does not offer version 9.22 of rxvt, even not via backports or other repositories. 
In this case you can still compile rxvt yourself. I recommend to first install the available version of your 
distribution anyway to pull in all its dependencies. Then uninstall it directly afterwards (but keep the dependencies). 
Now you can build rxvt yourself. This should take less than 5 minutes. Here is what you need to do on Debian:

-   First you will need to install some development packages to compile rxvt with all the necessary features.

          sudo apt-get install libxft-dev libperl-dev checkinstall

-   Get the source from <http://dist.schmorp.de/rxvt-unicode/> and extract it to a 
    place of your liking. Navigate into the just extracted folder and run the following commands:

            patch src/rxvtperl.xs /path/to/cdmn/resources/rxvtperl.xs.patch 
            ./configure --enable-everything --enable-256-color
            make
            sudo checkinstall

After that a package with the name `rxvt-unicode` will be installed and you should be able to call `urxvt`.

# Example Colors

Here are som example colors you can use for `URxvt.cdmn.gauges.colors` or any of the 
[overwrites](#visual-styles---gauges-colors).

| Colors   | Example                                                                   |
| -------- | ------------------------------------------------------------------------- |
| `22,46`  | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_green.png)   |
| `58,226` | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_yellow.png)  |
| `18,27`  | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_blue.png)    |
| `54,200` | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_magenta.png) |
| `23,87`  | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_cyan.png)    |
| `52,196` | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_red.png)     |

If you prefer the led style you might want to have more indicators.

| Colors                | Example                                                                     |
| --------------------- | --------------------------------------------------------------------------- |
| `52,88,124,160,196`   | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_red_led.png)   |
| `22,28,34,40,46`      | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_green_led.png) |
| `17,18,19,20,21`      | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_blue_led.png)  |
| `236,241,246,251,231` | ![](https://rawgit.com/Jeansen/assets/master/examples/colors_white_led.png) |

As described in the section on [visual styles](#visual-styles---gauges-colors) the first color always defines the 
background color.

# Please note

This extension is with relevance to its current stage 
[bleeding edge alpha](https://de.wikipedia.org/wiki/Release_early,_release_often). 
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
