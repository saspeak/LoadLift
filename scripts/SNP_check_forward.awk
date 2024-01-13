{
score=$6
first = 15; last = $(NF)

if ($4 == $13){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""ppALT_is_chREF""\t""0""\n"}
;}

 else if ($5 == $12 && $13 == "."){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""ppREF_is_ALT""\t" score "\n"}
;}

 else if ($5 == $13 && $4 == $12){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""SNP_is_ALT_pp=ref""\t" score "\n"}
;}

else if ($5 == $13){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf  "\t""=>""\t""SNP_is_ALT""\t" score "\n"}
;}

else if ($4 == $12 && $13 =="."){
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""ppREF_is_REF""\t""0""\n"}
;}

else {
 {printf $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$12"\t"$13"\t"}
 for (p = b; p <= NF; p++){printf "%s ", $p"\t"}
 {printf "\t""=>""\t""SNP_not_match""\t"".""\n"}
}
}



