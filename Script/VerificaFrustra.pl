use strict;

open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/AlignSE.fasta");
open(sal,">@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");
open (salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDBC.txt");

while(my $lista=<lista>){
	chomp $lista;
	my @splitter= split "",$lista;
	my @spl= split "_",$lista;
	my $c=0;
	if(@splitter[0] eq ">"){
		open(frustra,"@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6].pdb_singleresidue");
		while(my $frustra=<frustra>){
			$c++;
			if($c>4){
				print salida "@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]_@spl[2]_@spl[3]\n";
				print sal ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]_@spl[2]_@spl[3]\n";
				$lista=<lista>;
				print sal "$lista";
				last;
			}
		}
	}
	close(frustra);
}

close(lista);
close(salida);
