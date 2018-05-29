use strict;
use Bio::SeqIO;

open(salida, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
open(sali, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign4.fasta");

my $pdbid;
my @sp;

my $alignment="@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta";

my $secuencia = Bio::SeqIO -> new(
	-format => "fasta",
	-file => "$alignment");

while (my $SEQ = $secuencia->next_seq()){
	my $c=0;
	my $SEC=$SEQ->seq();
	my @splitter= split "",$SEC;
	my @spname=split "_",$SEQ->display_id;
	open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@spname[0]_@spname[1].pdb.done/FrustrationData/@spname[0].pdb_singleresidue");
	print salida ">",$SEQ->display_id,"\n";
	print sali ">",$SEQ->display_id,"\n";
	my $Sres=<Sres>;
	$Sres=<Sres>;
	my $long=$SEQ->length;
	my @splitres;
	while($c<$long){
		@splitres=split " ", $Sres;
		if((@splitter[$c] eq "-") or (@splitter[$c] eq "X")){
			print salida "-";
			print sali "-";
			}	
		else{	
			if(@splitres[1] eq "Missing"){
				print salida "-";
				print sali "Z";
				$Sres=<Sres>;
			}
			else {
				print sali "@splitres[3]";
				print salida "@splitres[3]";
				$Sres=<Sres>;
				}
			}
		$c++;
		}
print sali "\n";
print salida "\n";
}

close(corregido);
close(salida);
close(sali);
