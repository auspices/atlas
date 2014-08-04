# Atlas

[![Build Status](https://travis-ci.org/dzucconi/atlas.svg?branch=master)](https://travis-ci.org/dzucconi/atlas)

Simple image archive. No direct uploads; only accepts existing URLs which are then copied into an S3 bucket. Resizing is handled on demand via an external resizing image proxy (in this case Embedly). Currently single user with basic auth.
