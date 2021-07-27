#!/bin/bash

  sleep 5

  status=$(cloud-init status)

  while [ "$status" != "status: done" ]; do
    sleep 5
    status=$(cloud-init status)
  done
  