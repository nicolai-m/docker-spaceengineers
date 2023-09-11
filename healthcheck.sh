#!/bin/bash

if curl https://api.steampowered.com/ISteamApps/GetServersAtAddress/v1?addr=$IP -qq | grep Space -q
then
        exit 0
else
        exit 1
fi