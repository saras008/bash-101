#!/bin/bash
#sample nested loop
a=0
while [ "$a" -lt 10 ] #lt means lower than
do
        b="$a"
        while [ "$b" -ge 0 ] #ge means greater or equal
        do
                echo -n "$b" #print b value with new line
                b=`expr $b - 1` #print the next value of $b
        done
        echo
        a=`expr $a + 1` #keep sum variable a till bellow 10
done
