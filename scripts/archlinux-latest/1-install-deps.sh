#!/bin/bash

set -ex

pacman -Syu --noconfirm

pacman -S --noconfirm lua curl base-devel zip libzip tar unzip
