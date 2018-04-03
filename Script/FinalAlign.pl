use strict;

open(align,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign3.fasta");
open(nuevo,">@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlign.fasta");
open(nuevo2,">@ARGV[0]/OutPutFiles@ARGV[1]/SalidaAlignSE.fasta");
open(posi,">@ARGV[0]/OutPutFiles@ARGV[1]/Posiciones");

my $c=0;
my @vector;
my $m=0;
my $j;
my $control=0;

while(my $align=<align>){
	if ($c==0){
		$c++;}
	else{	
		my @splitter= split "",$align;
		my $tam = @splitter;
		if($control==0){
			$tam = @splitter;
			$control++;
				}
		if($c==1)
		{	$c++;
			my $i=0;
			while($i<$tam){
				if(@splitter[$i]eq"-"){
					@vector[$i]=1;
					}
				else{
					@vector[$i]=0;
					}
				$i++;
				}
			}
		else{
			if(@splitter[0]eq">"){
				if($m==0){
					print nuevo ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print nuevo2 ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";	
					print posi ">@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					$m++;
					}
				else{
					print nuevo "\n>@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print nuevo2 "\n>@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					print posi "\n>@splitter[1]@splitter[2]@splitter[3]@splitter[4]_@splitter[6]\n";
					}
		
			}	
			else {
				my $j=0;
				my $n=0;
				my $co=0;
				while ($j<$tam-1){
					if(@vector[$j]==0){
						if(@splitter[$j]eq"-"){
							print posi "0 ";
							}
						else{
							if(@splitter[$j]eq"-"){}
							else {$co++;}
							print posi "$co ";
							}
						print nuevo "@splitter[$j]";
						$n++;
						print nuevo2 "@splitter[$j]";
						if($n==51){
							print nuevo "\n";
							$n=0;			
							}
						}
					else{
						if(@splitter[$j]eq"-"){
							}
						else{
								$co++;
								}
						}
					$j++;
					}
				}
			}
		}

	

}

system ("perl @ARGV[0]/Script/longalign.pl @ARGV[0] @ARGV[1]");
close(align);
close(nuevo);
close(nuevo2);
close(posi);
