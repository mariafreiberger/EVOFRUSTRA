use strict;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");
open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

while(my $lineB=<blista>){
	chomp $lineB;
	$lineB =~ tr/a-z/A-Z/;
	system("awk '\$2 ~ /$lineB/' @ARGV[0]/DBSeq.fasta > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	my $linepdb=<awk>;
	my @spl=split " ",$linepdb;
	print salida "@spl[0]\n";
}
close(blista);
close(seq);
