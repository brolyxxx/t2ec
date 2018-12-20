# t2ec

To simplify installation and usage of the scripts which are not a part of the [psuinfo](https://github.com/nwg-piotr/psuinfo) package, I thought to give them a PKGBUILD file, and a common command, too:

```bash
t2ec --script [argument]
```

## Example:

`t2ec --volume` - to draw the volume icon + current volume level

`t2ec --volume -N` - to print "Vol: " + current volume level

`t2ec --volume [up] | [down] | [toggle] | [level]` - to use as mouse event commands

Together with the [psuinfo](https://github.com/nwg-piotr/psuinfo) package, all the most useful scripts are now unified and given common syntax:

![scripts in action](http://nwg.pl/wiki-tint2-executors/my-panels-261118.jpg)

## Installation:

Please install the [t2ec package](https://aur.archlinux.org/packages/t2ec) (AUR).

For `psuinfo` commands install the [psuinfo package](https://aur.archlinux.org/packages/psuinfo) (AUR).

## Commands to display information
 
`[-N]` replaces icons with text:

`t2ec --desktop [-N]`

`t2ec --bbswitch [-N]`

`t2ec --volume [-N]`

`t2ec --brightness [-N]`

`t2ec --lbrightness [-N]` (for `light-git` optional package)

`t2ec --battery [-l] | [-N]` (`[-l]` for icon + level, `[-N]` for "Bri: " + level

`t2ec --wifi [-N] | [-M'custom name']`

`t2ec --update -C[pacaur | trizen | yay] [-N] | [-M<custom_name]` [read more](https://github.com/nwg-piotr/t2ec#t2ec---update-command)

`t2ec --weather [-I<items>] [-A<api_key>] [-C<city_id>] [-U<units>] [-L<lang>]`

## Commands to assign to mouse events:

`t2ec --desktop [next] | [prev] | [<number>]`

`t2ec --volume [up] | [down] | [<level>]`

`t2ec --brightness [up] | [down] | [<level>]`

`t2ec --lbrightness [up] | [down] | [<level>]` (for 'light-git' optional package)

`t2ec --update -U<terminal>[:aur_helper]`

`t2ec --update -O` displays n(O)tifiction with the last saved updates list

`t2ec --weather -D[<city_id>]`


*Remember to uncheck 'Show icon' in executor if textual display selected!*

## Menus:

`t2ec --command menu` - assigned to a mouse event (preferrably left/right click) allows to attach context menus to executors.

You need the [jgmenu](https://github.com/johanmalm/jgmenu) package (optional dependency) installed and initialized (`jgmenu init`).

Two of the commands have predefined menus: `t2ec --update menu` and `t2ec --desktop menu` will display:

![predefined menus](http://nwg.pl/wiki-tint2-executors/t2ec-menus-predefined.png)

Other commands launched with the `menu` argument will use a sample template. All templates are being
created in the `~/.t2ecol` hidden folder as soon, as you run the command for the first time.
You may customize templates to your taste. To restore defaults, just remove the modified template.

Check the [jgmenu reference document](https://github.com/johanmalm/jgmenu/blob/master/docs/manual/jgmenu.1.md) to learn more.

## Helper command:

`t2ec --zbox [bri] | [vol]` - displays Zenity box to set volume | brightness level. Depends on 'zenity' and 'rof-git' optional packages.

## Sample usage in Tint2:

![sample executor](http://nwg.pl/wiki-tint2-executors/tint2conf-commented.png)

## t2ec --update command

This command may need some further clarification. To benefit from all its features, you should install the `jgmenu` optional package, and assign `t2ec --update menu` to the left click event:

![t2ec --update](http://nwg.pl/wiki-tint2-executors/t2ec-update.png)

Also the "Continous output" field is necessary. For graphical output (e.g. `t2ec --update -Ctrizen`) please set `execp_continuous = 2`. For textual output (e.g. `t2ec --update -Ctrizen -N` set `execp_continuous = 1.`

### t2ec --update menu

You need to edit the `~/.t2ecol/menu-update.sh` template, as your AUR helper and terminal are defined here. Default **yay** and **termite** may, or may not work for you.

```bash
#!/bin/sh

config_file=$(mktemp)
menu_file=$(mktemp)
trap "rm -f ${config_file} ${menu_file}" EXIT

cat <<'EOF' >${config_file}
stay_alive          = 0
tint2_look          = 1
menu_width          = 40
menu_border         = 1
item_height         = 20
font                = Sans 10
icon_size           = 0
color_norm_fg       = #eeeeee 100
color_sel_fg        = #eeeeee 100
EOF

cat <<'EOF' >${menu_file}
Check updates,t2ec --Cyay
Show pending,t2ec --update -O
Update,t2ec --update -Utermite:yay
EOF

jgmenu --config-file=${config_file} --csv-file=${menu_file}
```

## t2ec --weather

This script retrieves ad displays weather data from [http://openweathermap.org](http://openweathermap.org) © 2012 — 2018 OpenWeatherMap, Inc.

![t2ec --weather](http://nwg.pl/wiki-tint2-executors/weather.png)

### Executor:

Icon display:

`t2ec --weather`

"Show icons" and "Cache icons" checked. Continous output = 2.

Textual display:

`t2ec --weather -N | -M"My own text here"` (or just `-M` for no name)

"Show icons" unchecked. Continous output = 1.

### Details notification:

`t2ec --weather -D[<city_id>]`

Assign the command above to a mouse click event. Optional `<city_id>` you only need if the executor displays data for another city tan specified in the config file (see below).

### Configuration:

At the first use, the script creates the `~/.t2ec/weatherrc` config file. You need to edit at least 2 values.

```
items = ct
api_key = your_api_key_kere
city_id = 2643743
units = metric
#lang = en
#img_path = /home/user/my_custom_icons/

# You may translate your output below:
#
_weather = Weather in
_wind = Wind
_cloudiness = Cloudiness
_pressure = Pressure
_humidity = Humidity
_sunrise = Sunrise
_sunset = Sunset
```

1. Obtain API key at [http://openweathermap.org](http://openweathermap.org), enter it in the `api_key` field;
2. find your city ID at [https://openweathermap.org/find](https://openweathermap.org/find), enter in the `city_id` field.
3. You may also replace default `metric` units with `imperial`, if you need to.

The script uses the system $LANG variable by default. In case it didn't work for you, or you just wanted another language, uncomment the `#lang = en` line, and replace English with your own lang (2 chars).

If default icons by @edskeye don't go well with your desktop layout, you may uncomment the `#img_path = /home/user/my_custom_icons/` line and enter a path to own icons. Originals you'll find in `/usr/share/t2ec/ow*-svg`.

This small script does not really provide internalization. However, you may translate the display into your language by editing fields which names start from `_`, e.g.:

`_weather = Pogoda w` for "Weather in" in Polish.

### Overriding weatherrc settings:
