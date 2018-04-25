use strict;

open(corregido,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");
open(salida, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");

my $pdbid;
my @sp;

while(my $line=<corregido>){
	chomp $line;
	my @splitter= split "",$line;	
	if(@splitter[0] eq ">"){
		print salida "$line";
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]@splitter[5]@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4].pdb_singleresidue");
		}
	else{
		my $Sres=<Sres>;
		$Sres=<Sres>;
		my @splitres;
		my $tam=@splitter;
		my $c=0;
		while($c<$tam){
			@splitres=split " ", $Sres;
			if(@splitter[$c] eq "-"){
				print salida "-";
				}	
			else{	
				if(@splitres[0] eq "Missing"){
					print salida "-";
					$Sres=<Sres>;
				}
				else {
					print salida "@splitres[3]";
					$Sres=<Sres>;
					}
				}
			$c++;
			}
		}
	print salida "\n";
}

close(corregido);
close(salida);
