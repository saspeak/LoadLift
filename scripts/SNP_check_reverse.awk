{
score=$6
first = 14; last = $(NF)

if ($4 == $13){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""ppALT_is_chREF""\t""0""\n"}
;}

 else if ($5 == $10 && $11 == "."){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf  "\t""=>""\t""ppREF_is_ALT""\t" score "\n"}
;}

 else if ($5 == $11 && $4 == $10){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""SNP_is_ALT_pp=ref""\t" score "\n"}
;}

else if ($5 == $11){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf  "\t""=>""\t""SNP_is_ALT""\t" score "\n"}
;}

else if ($4 == $10 && $11 =="."){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""ppREF_is_REF""\t""0""\n"}
;}

else {
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$10"\t"$11"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""SNP_not_match""\t"".""\n"}
}

}
