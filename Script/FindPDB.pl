use strict;
use File::Copy;

open(blista,"@ARGV[0]/OutPutFiles@ARGV[1]/Sequences.fasta");
open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

my $pdb;

while(my $lineB=<blista>){
	chomp $lineB;
	$lineB =~ tr/a-z/A-Z/;
	system("awk 'match(\$2, /$lineB/)' @ARGV[0]/DBSeq.fasta > @ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	open (awk,"@ARGV[0]/OutPutFiles@ARGV[1]/Listaawk.txt");
	my $awk=<awk>;
	chomp $awk;
	my @spa= split " ",$awk; 
	my @sp= split "_",@spa[0];
	print salida "@spa[0]\n";
}
close(blista);
close(seq);
