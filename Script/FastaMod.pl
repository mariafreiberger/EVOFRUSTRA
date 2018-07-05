use strict;

open(ali,"@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlignSE.fasta");
open(lista,">@ARGV[0]/OutPutFiles@ARGV[1]/Equivalences/Logo.fasta");

while(my $line=<ali>){
	my @splitter= split "",$line;
	if(@splitter[0] eq ">"){
		}
	else{
		print lista "$line";
		}
}
close(ali);
