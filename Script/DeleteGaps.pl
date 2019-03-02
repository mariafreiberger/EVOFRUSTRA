use strict;

open(nuevo,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignClean.fasta"); #salida

my $c=0;
my @vector;
open(seq,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");

while (my $SEQ=<seq>){
	my @sp=split "",$SEQ;
	if(@sp[0] eq ">"){
		}
	else{
		@vector[$c]=$SEQ;
		$c++;		
	}
}
my $i=0;
my $j=0;
my $aux=@vector[0];
my @caracter= split "", $aux;
my $tam=@caracter;
print $c;
my $cgaps=0;
my $porc=$c*0.6;
my @vect_gaps;

while($i<$tam){
	$j=0;
	$cgaps=0;
	while($j<$c+1){
		$aux=@vector[$j];
		@caracter= split "", $aux;
		if (@caracter[$i]eq"-"){$cgaps++;}
		$j++;
		}
	#print "$cgaps<$porc\n";
	if($cgaps<$porc){
		@vect_gaps[$i]=0;#columna que conservo
		}
	else{@vect_gaps[$i]=1; #columna que elimino
		}
	$i++;
}

$tam=@vect_gaps;
my $c=0;

open(seq,"@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta");

while (my $SEQ2 = <seq>){
	$i=0;
	my $pr=0;
	my @splitter= split "",$SEQ2;
	if(@splitter[0] eq ">"){
		print nuevo "$SEQ2";
	}
	else{
		while($i<$tam+1){
			if(@vect_gaps[$i]==0){
				if($pr==60){
					print nuevo "\n";
					$pr=0;				
							}			
				else {
					print nuevo "@splitter[$i]";
					$pr++;		
						}
				}
				$i++;
			}	
		}
}

close(nuevo);
