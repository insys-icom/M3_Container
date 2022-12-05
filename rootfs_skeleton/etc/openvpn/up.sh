#!/bin/bash

brctl addif br0 tap0
ip link set up dev tap0
