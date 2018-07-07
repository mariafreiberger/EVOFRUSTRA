use strict;

open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignSE.fasta");
open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");
open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta");


while (my $SEQ = <align>){
	chomp $SEQ;
	my @splitter= split "",$SEQ;
	if((@splitter[0]eq">")or(@splitter[0]eq"")){}
	else{
		my $lista=<lista>;
		print sal ">$lista",$SEQ,"\n";
	}
}

close(alin);
close(sal);
