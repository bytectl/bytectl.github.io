#!/bin/bash
# ls content/post/lang/sql/ -1  | xargs -n1 -I{} echo  "post/lang/sql/{}" |xargs -n1 ./genHead.sh

FILE_PATH=$1
TMP_NMAE=${FILE_PATH}_tmp
mv content/${FILE_PATH} content/${TMP_NMAE}
hugo new ${FILE_PATH}

cat content/${TMP_NMAE} >> content/${FILE_PATH} 
rm -rf content/${TMP_NMAE}