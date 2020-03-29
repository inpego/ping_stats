#!/bin/bash

bundle exec sequel -m migrations postgres://ping_stats:123456@postgres/ping_stats
bundle exec puma -p 3000
