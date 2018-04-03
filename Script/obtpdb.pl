use strict;

open (align,"@ARGV[0]");
open (lista,">/home/maria/Desktop/AutoLogo/@ARGV[0].txt");

while(my $line=<align>){
	my @splitter= split "", $line;
	if(@splitter[0] eq ">"){
			print lista "@splitter[4]@splitter[5]@splitter[6]@splitter[7]_@splitter[8]\n";
			}

}

close(align);
