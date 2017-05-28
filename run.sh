#!/bin/bash
for (( ; ; ))
do
 rm -rf Working/output_dir
 processing-java --run --sketch=`pwd`/Working --output=`pwd`/Working/output_dir
done
