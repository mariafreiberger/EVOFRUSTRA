use strict;

open(lista,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta") or die "Can't open file SeqAlign.fasta $!";
open(salida,">@ARGV[0]/OutPutFiles@ARGV[1]/ListaPDBC.txt")  or die "Can't open ListaPDBC.txt $!";

while(my $lista=<lista>){
	chomp $lista;
	my @splitter= split "",$lista;
	my @spl= split "_",$lista;
	my $c=0;
	if(@splitter[0] eq ">"){
		my $filepath = "@ARGV[0]/OutPutFiles@ARGV[1]/Modeller/@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6].pdb.done/FrustrationData/@splitter[1]@splitter[2]@splitter[3]@splitter[4].B99990001.pdb_singleresidue";
		open(frustra, $filepath) or die "Can't open file $filepath $!";
		while(my $frustra=<frustra>){
			$c++;
			if($c>4){
				print salida "@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]_@spl[2]_@spl[3]\n";
				last;
			}
		}
	}
	close(frustra);
}

close(lista);
close(salida);
