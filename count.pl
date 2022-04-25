
open(fasta, "typeII.dat");

$, = ",";
$\ = "\n";
$count=0;

while(<fasta>){
	chomp;

	if($_ =~ /^ID/){
		$count++;
	}
}
print $count ;	#終了時に音が鳴ります
