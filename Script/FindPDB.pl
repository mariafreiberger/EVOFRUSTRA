use strict;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");

while(my $lineB=<blista>){
	chomp $lineB;
	$lineB =~ tr/a-z/A-Z/;
	system("awk '\$2 ~ /$lineB/' @ARGV[0]/DBSeq.fasta >> @ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
}
close(blista);
close(seq);
