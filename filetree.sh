#!/usr/bin/bash # optional — to run, bash rake_passages.sh
#Displays welcome message to the terminal
file=welcome.txt
cat $file

#Dialog to ask user what level tree they'd like to see
read -r -d '' applescriptCode <<'EOF'
   set dialogText to text returned of (display dialog "Welcome to CySpy Tool Kit! What level tree would you like to see? " default answer "")
   return dialogText
EOF
#saves input to level variable
level=$(osascript -e "$applescriptCode");

#Code below generates a level 2 directory tree
tree -C -L $level

#Code below prompts user to enter filepath for the directory they want to analyze
read -r -d '' applescriptCode <<'EOF'
   set dialogText to text returned of (display dialog "Enter the filepath for the directory you'd like to observe:" default answer "")
   return dialogText
EOF
#saves input to directory tree
directory=$(osascript -e "$applescriptCode");

#Code below cd's into the directory and generates a tree for that directory
echo 
#display tree of directory of user's choice
tree -C $directory 
cd $directory

#Code below asks user if they'd like to analyze a particular file
read -r -d '' applescriptCode <<'EOF'
    set question to display dialog "Would you like to analyze a particular file?" buttons {"Yes", "No"} default button 1
    set answer to button returned of question
    return answer
EOF
#saves input to answer variable
answer=$(osascript -e "$applescriptCode");
#echo $answer

#If the user decides they'd like to analyze a specific file, code below asks for a file name
if [ $answer == "Yes" ]
then 
    
#Dialog to ask user what file they'd like to analyze 
read -r -d '' applescriptCode <<'EOF'
   set dialogText to text returned of (display dialog "Enter the name of the file you'd like to analyze:" default answer "")
   return dialogText
EOF

#Code below concatenates the file analysis/metadata for file of user's choice
filename=$(osascript -e "$applescriptCode");
echo $filename
hexdump -C -n128 $filename
echo "----------------------"
echo "File Information: "
stat -x $filename
echo "----------------------"
echo "md5 Hash Values:"
md5 $filename
echo "----------------------"
echo "sha1 Hash Values:"
openssl sha1 $filename
    fi
 if [ $answer == "No" ]
    then
    exit 1
    fi

#Code below asks user if they'd like to view file and prompts a warning
read -r -d '' applescriptCode <<'EOF'
    set question to display dialog "Would you like to view this file? Note: viewing will modify timestampin future analyses:" buttons {"Yes", "No"} default button 1
    set answer to button returned of question
    return answer
EOF
viewanswer=$(osascript -e "$applescriptCode");
#echo $viewanswer
#if user answers yes, open file
if [ $viewanswer == "Yes" ] 
    then 
    open $filename
    fi

#Code below asks user if they'd like to save findings
read -r -d '' applescriptCode <<'EOF'
    set question to display dialog "Would you like to save your findings?" buttons {"Yes", "No"} default button 1
    set answer to button returned of question
    return answer
EOF
saveanswer=$(osascript -e "$applescriptCode");
#saves input to save answer variable
echo $saveanswer

#If the user decides to save findings, code below will prompt user for a case number
if [ $saveanswer == "Yes" ] 
    then 
        read -r -d '' applescriptCode <<'EOF'
        set dialogText to text returned of (display dialog "Enter case number:" default answer "")
        return dialogText
EOF

casenumber=$(osascript -e "$applescriptCode");

#Code below prompts user for a case name 
read -r -d '' applescriptCode <<'EOF'
        set dialogText to text returned of (display dialog "Enter case name:" default answer "")
        return dialogText
EOF


casename=$(osascript -e "$applescriptCode");

#Code below prompts user for a filename to save file analysis
read -r -d '' applescriptCode <<'EOF'
        set dialogText to text returned of (display dialog "Enter name to save file:" default answer "")
        return dialogText
EOF
#Code below prompts user for a filepath to save file analysis
nametosave=$(osascript -e "$applescriptCode").txt;

#dialog to ask user the filepath to save the report to
read -r -d '' applescriptCode <<'EOF'
        set dialogText to text returned of (display dialog "Enter filepath to save file:" default answer "")
        return dialogText
EOF
#saves input to filepath variable
filepath=$(osascript -e "$applescriptCode");

#dialog to ask user for what their name is
read -r -d '' applescriptCode <<'EOF'
        set dialogText to text returned of (display dialog "Enter examiner name: " default answer "")
        return dialogText
EOF

examiner=$(osascript -e "$applescriptCode");

cd 
#Code below writes file analysis as well as directory
#tree to filepath and output file
echo "Case Number: $casenumber">> $filepath/$nametosave
echo "Case Name: $casename">> $filepath/$nametosave
echo "Examiner: $examiner">> $filepath/$nametosave
echo "____________________________________________________________">> $filepath/$nametosave
tree  $directory >> $filepath/$nametosave
echo $directory/$filename>> $filepath/$nametosave
hexdump -C -n128 $directory/$filename >> $filepath/$nametosave
echo "------------------------------------------------------------" >> $filepath/$nametosave
echo "File Information: " >> $filepath/$nametosave
stat -x $directory/$filename >> $filepath/$nametosave
echo "------------------------------------------------------------" >> $filepath/$nametosave
echo "md5 Hash Values:" >> $filepath/$nametosave
md5 $directory/$filename >> $filepath/$nametosave
echo "------------------------------------------------------------" >> $filepath/$nametosave
echo "sha1 Hash Values:" >> $filepath/$nametosave
openssl sha1 $directory/$filename >> $filepath/$nametosave
open $filepath/$nametosave
    fi

