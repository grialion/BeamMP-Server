#!/bin/bash

set -ex

pacman -Syu --noconfirm

pacman -S --noconfirm node git
