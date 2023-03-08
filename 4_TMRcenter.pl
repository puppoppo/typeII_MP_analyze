
open(fasta, "FT269_250.fas");
open(WRITE,">FT269_250_TMR.fas");

my %amino_acid_values = (
	A => 1.8,
	C => 2.5,
	D => -3.5,
	E => -3.5,
	F => 2.8,
	G => -0.4,
	H => -3.2,
	I => 4.5,
	K => -3.9,
	L => 3.8,
	M => 1.9,
	N => -3.5,
	P => -1.6,
	Q => -3.5,
	R => -4.5,
	S => -0.8,
	T => -0.7,
	V => 4.2,
	W => -0.9,
	Y => -1.3
);

$, = ",";
$\ = "\n";

while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
		printf WRITE $temp."\n";
	}
	elsif($_ =~ /^M/){
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);

		for (my $i=0;$i<@sq;$i++) {
			if (exists $amino_acid_values{$sq[$i]}) {
				$sq[$i] = $amino_acid_values{$sq[$i]};
			} else {
				die "Error: unknown amino acid $sq[$i] in sequence $swissid at position $i\n";
			}
		}

		$max = 0;
		@hydra = (0);

		for($i=0;$i<@sq;$i++){
			for($j=-7;$j<=7;$j++){
				if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=0で置き換え
				elsif($i+$j >= 0){$hydra[$i]+= $sq[$i+$j];}
			}
			if($hydra[$max]<$hydra[$i]){
				$max=$i;
			}
		}

		@sq=split(//,$SEQUENCE);

		for($i=$max-25;$i<$max+26;$i++){
			if($i<=0 || $i>=@sq){
				printf WRITE "X";
			}
			else{
				printf WRITE $sq[$i];
			}
		}
		printf WRITE "\n";

	}
}
print chr(7);	#終了時に音が鳴ります
