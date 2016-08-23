# !/bin/sh

currentDate=`date "+%Y-%m-%d %H:%M"`  
echo "--------------------Start Time : $currentDate--------------------"

start="$(date +%s)"

path=.
if [[ $1 ]]; then
	path=$1
fi

let unusedImageCount=0;
let totalSize=0;

PROJ=`find $path -name '*.xib' -o -name '*.[mh]' -o -name '*.storyboard' -o -name '*.mm'`
for png in `find $path -name '*.imageset'`
do
	name=`basename -s .imageset $png`
	usedInFile=false
	for file in $PROJ
	do
	   	if grep -qhs "\"$name\(@2x\|@3x\)\?\(\.png\)\?\"" $file; then
	        usedInFile=true
	    	break	    	
	   	fi
	done

	if ! $usedInFile; then
		
		filesize=`du -k $png | cut -f1`
		totalSize=`echo $totalSize + $filesize | bc`
		let unusedImageCount+=1
		
		echo "Unused images : $png"
		rm -r $png
	fi
done

end="$(date +%s)"
timeInterval=$((end - start))
echo "--------------------Found $unusedImageCount unused images! TotalSize : $totalSize KB! Cost time : $timeInterval s--------------------"
currentDate=`date "+%Y-%m-%d %H:%M"`  
echo "--------------------End Time : $currentDate--------------------"

# asset=`find . -name '*.xcassets'`
# #-print required
# for png in `find . -path $asset -prune -o -name '*.png' -print`
# do
# 	name=`basename -s .png $png`
#   	name=`basename -s @2x $name`
#    	name=`basename -s @3x $name`

# if ! grep "\"$name\(@2x\|@3x\)\?\(\.png\)\?\"" $PROJ; then
#         echo "Unused images : $png"
#         # rm -r $png
#    fi
# done



