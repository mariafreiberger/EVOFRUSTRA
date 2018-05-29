use strict;
use Bio::SeqIO;

open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignSE.fasta");
open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDB.txt");

my @vector;
my $c=0;
my $alignment="@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta";

my $secuencia = Bio::SeqIO -> new(
	-format => "fasta",
	-file => "$alignment");
while (my $SEQ = $secuencia->next_seq()){
	my $lista=<lista>;
	print sal ">$lista",$SEQ->seq(),"\n";
}

close(alin);
close(sal);
