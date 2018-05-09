use strict;

open(corregido,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign2.fasta");
open(salida, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
open(sali, ">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign4.fasta");

my $pdbid;
my @sp;

while(my $line=<corregido>){
	chomp $line;
	my $Sres;
	my @splitter= split "",$line;	
	if(@splitter[0] eq ">"){
		print salida "$line";
		print sali "$line";
		open(Sres,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]@splitter[5]@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4].pdb_singleresidue");
		$Sres=<Sres>;
		}
	else{
		$Sres=<Sres>;
		my @splitres;
		my $tam=@splitter;
		print "$tam ";
		my $c=0;
		while($c<$tam){
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
		}
	print salida "\n";
	print sali "\n";
}

close(corregido);
close(salida);
