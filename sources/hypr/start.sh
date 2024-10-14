#!/usr/bin/env bash

# initializing the wallpaper daemon
swww init &

# setting wallpaper
swww img ./wallpaper.* &

nm-applet --indicator &

waybar &

mako
