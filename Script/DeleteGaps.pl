use Bio::SeqIO;
use strict;

open(nuevo,">@ARGV[0]/OutPutFiles@ARGV[1]/AlignClean.fasta"); #salida


my @vector;
my $c=0;
my $alignment="@ARGV[0]/OutPutFiles@ARGV[1]/SeqAlign.fasta";

my $secuencia = Bio::SeqIO -> new(
	-format => "fasta",
	-file => "$alignment");
while (my $SEQ = $secuencia->next_seq()){
	@vector[$c]=$SEQ->seq();
	$c++;
}

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

$tam=@vect_gaps;
my $c=0;

my $secuencia2 = Bio::SeqIO -> new(
	-format => "fasta",
	-file => "$alignment");

while (my $SEQ2 = $secuencia2->next_seq()){
	$i=0;
	my $SEC2=$SEQ2->seq();
	my $pr=0;
	print nuevo ">",$SEQ2->display_id,"\n";
	my @splitter= split "",$SEC2;
	while($i<$tam+1){
		if(@vect_gaps[$i]==0){
			if($pr==60)
				{print nuevo "\n";
					$pr=0;				
						}			
			else {print nuevo "@splitter[$i]";
					$pr++;			
					}
			}
			$i++;
		}
	print nuevo "\n"
}

close(nuevo);
