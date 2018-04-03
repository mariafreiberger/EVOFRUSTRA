
use strict;

open(fasta,"@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta"); #archivo alineado
open(nuevo,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignClean.fasta"); #salida

my @vector;
my $c=0;

while(my $line=<fasta>){
	my @splitter= split "",$line;
	if(@splitter[0]eq">"){}
	else {
		@vector[$c]=$line;
		$c++;		
		}
}

close(fasta);

my $i=0;
my $j=0;
my $aux=@vector[0];
my @caracter= split "", $aux;
my $tam=@caracter;
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
	if($cgaps<$porc){
		@vect_gaps[$i]=0;#columna que conservo
		}
	else{@vect_gaps[$i]=1; #columna que elimino
		}
	$i++;
}

open(fasta,"@ARGV[0]/OutPutFiles@ARGV[1]/Alignment.fasta"); #archivo alineado
$tam=@vect_gaps;
my $c=0;
while(my $line=<fasta>){
	$i=0;
	my $pr=0;
	my @splitter= split "",$line;
	if(@splitter[0]eq">"){
		if($c==0){
			print nuevo "$line";	
			$c++;
			}
		else{
			print nuevo "\n$line"
			}
		}		
	else{	
		while($i<$tam+1){
			if(@vect_gaps[$i]==0){
				if($pr==60){print nuevo "\n";
					$pr=0;				
						}			
				else {print nuevo "@splitter[$i]";
					$pr++;			
					}
			}
			$i++;
		}
	}
}
close(fasta);
close(nuevo);
