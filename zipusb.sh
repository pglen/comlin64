#!/bin/bash

dd status=progress bs=1M if=/dev/sdb of=../32G_1.0.0.img
gzip -9 ../32G_1.0.0.img

