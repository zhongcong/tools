#!/bin/bash

i=0;
echo "start"
while [ -s out.yuv ]
do
  echo "frame"
  ((i++));
  dd if=out.yuv of=frame.yuv count=1 bs=3110400;
  md5sum frame.yuv >> md5.txt;
  mv out.yuv tmp.yuv;
  dd if=tmp.yuv of=out.yuv skip=1 bs=3110400;
done;
