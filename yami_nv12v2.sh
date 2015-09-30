CURRENT_PATH=`pwd`
cd ${CURRENT_PATH}
echo "current path ${CURRENT_PATH}"

file_number=0
rm -rf ./result_vp8_fail
rm -rf ./result_vp8_pass
rm -rf ./result_vp8
rm -rf ./vp8vld_real.md5

cat ./vp8_nv12_bits.md5 | while read line
#rm ./libvpx_vp8_result

export LIBVA_TRACE="/home/webrtc/dev/yami/zhongcong/log/va_trace"
export LIBVA_TRACE_SURFACE="/home/webrtc/dev/yami/zhongcong/log/va_trace_dec_yuv"

do
    filename=`echo $line |awk '{print $2}'`
    echo "filename : $filename"

#    export LIBVA_TRACE="/work/log/libyami-log-"$filename
    /home/webrtc/dev/yami/blue_byt/libyami/tests/.libs/yamidecode -i ../vp8/$filename  -m 0 -f NV12
#    vp8vld -i ../vp8/$filename 
#    mv va_trace_dec_yuv* $filename
    cp *.NV12 $filename
    rm *.NV12
    real_md5=`md5sum $filename | awk '{print $1}'`
    echo "real_md5 : $real_md5"
    ref_md5=`echo $line | awk '{print $1}'`
    echo "ref_md5 : $ref_md5"
    if [ "$ref_md5" = "$real_md5" ]; then
        echo ---------------------------------------------------------- 
        echo " ${file_number}---$filename PASS " >> ./result_vp8_pass
        echo " ${file_number}---$filename PASS " >> ./result_vp8

    else
        echo ---------------------------------------------------------
        echo " ${file_number}---$filename FAIL " >> ./result_vp8_fail
        echo " ${file_number}---$filename FAIL " >> ./result_vp8
    fi
    echo "$real_md5 ${filename}" >> vp8vld_real.md5
    file_number=$(($file_number+1))

    #mv $filename $filename".NV12"
    rm -rf ./$filename
done

pass_number=`cat ./result_vp9 |grep PASS|wc -l`
total_number=`cat ./result_vp9 |wc -l`
echo "Pass: $pass_number | Total: $total_number" >> result_vp8

