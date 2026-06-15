#!/usr/bin/env bash
if hyprctl monitors all | grep -q "Monitor HDMI-A-1"; then
    hyprmon --profile HDMI_ONLY
else
    hyprmon --profile LAPTOP_ONLY # switch to both/hdmi only with win+f1/2/3/4
fi