
open(SWISS, "uniprot_sprot.dat");

$, = ",";
$\ = "\n";
$count=0;

while(<SWISS>){
	chomp;
	if($_ =~ /^\/\//){
		$count++;
	}
}
print $count."\n";
print chr(7);	#終了時に音が鳴ります
