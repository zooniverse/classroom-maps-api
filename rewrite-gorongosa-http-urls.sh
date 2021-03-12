#!/bin/bash -e

# 1. Fix the http URLs for the zooniverse-export subjects in Gorongosa project
# Example of an old URL: http://zooniverse-export.s3-website-us-east-1.amazonaws.com/21484_1000_D60_Season%202_Set%201_EK002004.JPG
# Example of a new URL: https://zooniverse-export.s3.amazonaws.com/21484_1000_D60_Season%202_Set%201_EK002004.JPG

# use sed to subsitute the http urls inline (note OSX needs the -i '' vs -i ....YMMV!)
sed -i '' -r 's/http:\/\/(zooniverse-export)\.s3-website-us-east-1\.amazonaws\.com/https:\/\/\1\.s3.amazonaws.com/g' subjects.csv
