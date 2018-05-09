use strict;

open(salidase,"@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlignSE.fasta");
my $tam=0;

while (my $line=<salidase>){
	my @w=split "", $line;
	if(@w[0] eq ">"){}
	else {$tam=@w;
		}
}

open(num,">@ARGV[0]/OutPutFiles@ARGV[1]/long.txt");

print num "$tam\n";
close(num);
