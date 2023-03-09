
open(SWISS, "typeII_exclusion.dat");
open(WRITE,">amph_end_compare.csv");

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

my %amino_amph_values = (
	A => 0,
	C => 0,
	D => 0,
	E => 1.27,
	F => 0,
	G => 0,
	H => 1.45,
	I => 0,
	K => 3.67,
	L => 0,
	M => 0,
	N => 0,
	P => 0,
	Q => 1.25,
	R => 2.45,
	S => 0,
	T => 0,
	V => 0,
	W => 6.93,
	Y => 5.06
);

$, = ",";
$\ = "\n";
$U=0;
$A=-0.49;

while(<SWISS>){
	chomp;

	if($_ =~ /^ID   /){
		$swissid = substr($_,5,12);
		$swissid =~ s/\s//g;
	}
	 elsif($_ =~ /^DE/){
		if($_ =~ /^DE   RecName: Full=/){
			$swissde .= substr($_,19,100);
		}
		if($_ =~ /Fragment/){
			$frag = 1;
		}
	}
	elsif($_ =~ /^OC   /){
		$swissoc .= substr($_,5,100);
	}

	elsif($_ =~ /^CC   -!- SUBCELLULAR LOCATION/){
	$suswitch = 1;
	$swisssu .= substr($_,30,100);
	}

	elsif($_ =~ /SUBCELLULAR/){
		$suswitch = 1;
		$swisssu = substr($_,30,100);
	}

	elsif($_ =~ /^CC   -!-|CC   ---/){
		$suswitch = 0;
	}
	elsif($_ =~ /^CC       / && $suswitch == 1){
		$swisssu .= substr($_,9,100);
	}
	elsif($_ =~/^FT   TRANSMEM/){
		$ftnumber++;
		$TMR = substr($_,21,100);
#		$TMR = s/\s//g;

		@TMRregion = split(/\.\./, $TMR);
		$TMRstart = int($TMRregion[0]);
		$TMRend =  int($TMRregion[1]);
		$TMRregion = (0);
		$ftswitch = 1;
	}
	elsif($_ =~ /^FT       / && $ftswitch>=1 && $ftswitch < 3 ){
		$ftevi .= substr($_,21,100);
		$ftswitch ++;
	}
	elsif($_ =~ /^     /){
		$swisssq .= substr($_,5,100);
		$swisssq =~ s/\s//g;
		if($_ =~/U/ || $_ =~/X/){
			$U=1;
		}
	}

	elsif($_ =~ /^\/\//){
		$SEQUENCE=$swisssq;
		@sq=split(//,$SEQUENCE);
		@sqn=();
		@sqA=();

		for (my $i=0;$i<@sq;$i++) {
			if (exists $amino_acid_values{$sq[$i]}) {
				$sqn[$i] = $amino_acid_values{$sq[$i]};
			} else {
				die "Error: unknown amino acid $sq[$i] in sequence $swissid at position $i\n";
			}
		}

		for (my $i=0;$i<@sq;$i++) {
			if (exists $amino_amph_values{$sq[$i]}) {
				$sqA[$i] = $amino_amph_values{$sq[$i]};
			} else {
				die "Error: unknown amino acid $sq[$i] in sequence $swissid at position $i\n";
			}
		}


		@hydra=();
		$max=0;

		for($i=0;$i<@sqn;$i++){
			for($j=-7;$j<=7;$j++){
				if($i+$j < 0){$hydra[$i]+= $A;} #無いところを＄A=-0.49(全アミノ酸の平均値)で置き換え
				elsif($i+$j >= 0){$hydra[$i]+= $sqn[$i+$j];}
			}
			if($hydra[$max]<$hydra[$i]){
				$max=$i;
			}
		}

		@hy_info=((["hy_def","N","O","Nend","AmphiScore"]));

		for($N=2;$N<=5;$N++){
			for($O=2;$O<=5;$O++){

				my @hy_N=();
				my @hy_O=();
				my @hy_deff=();
				my $defmax=0;

				$start=$max+20;

				for($i=$start-25;$i<=$start;$i++){
					for($j=0;$j<$N;$j++){
						if($i+$j < 0){$hy_N[$i]+= $A;} #無いところを＄A=-0.49で置き換え
						elsif($i+$j >= 0){$hy_N[$i]+= $sqn[$i+$j];}
					}
					$hy_N[$i]=$hy_N[$i]/$N;

					for($j=0;$j<$O;$j++){
						if($i+$j < 0){$hy_O[$i]+= $A;} #無いところを＄A=-0.49で置き換え
						elsif($i+$j >= 0){$hy_O[$i]+= $sqn[$i+$j];}
					}
					$hy_O[$i]=$hy_O[$i]/$O;
				}
				$end=$max+15-$N+1;
				$start=$end-10;
				$defmax=$start;
				for($i=$start;$i<=$end;$i++){
					$hy_deff[$i] = +$hy_N[$i]-$hy_O[$i+$N];
					if($hy_deff[$i]>$hy_deff[$defmax]){
						$defmax=$i;
					}
				}

				$Nend=$defmax+$N-1;

				$AmphiScore=0;
				for($i=-2;$i<=3;$i++){
					$AmphiScore+=$sqA[$Nend+$i];
				}
				$AmphiScore=$AmphiScore/6;

				##AmphiScoreは移動平均範囲でもよいかも

				push (@hy_info,([$hy_def[$defmax],$N,$O,$Nend,$AmphiScore]));

			}
		}

		@delete=shift @hy_info;

		@hy_info = sort{$b->[0] <=> $a->[0]} @hy_info;

		# for($k=0;$k<3;$k++){
		# 	for($l=0;$l<5;$l++){
		# 		printf WRITE $hy_info[$k][$l].",";
		# 	}
		# 	printf WRITE "\n";
		# }

		$certainly=0;

		if($hy_info[0][3]==$hy_info[1][3]){					#TOP3が一致していたらcertainly=1
			if($hy_info[1][3]==$hy_info[2][3]){
				$certainly=1;
				$Nend=$hy_info[0][3];
			}
		}

##############################################################
		if($certainly==0){			#TOP3が不一致ならAmphiの高いものをcertainly=2で
			@delete = splice(@hy_info,-13);
			@hy_info = sort{$b->[4] <=> $a->[4]} @hy_info;
			if($hy_info[0][4] != $hy_info[1][4]){
				$certainly = 2;
				$Nend = $hy_info[0][3];
			}
		}

		if($certainly==0){#1Am==2Am
			if($hy_info[1][4] != $hy_info[2][4]){	#2Am!=3Am
				if($hy_info[0][3] == $hy_info[1][3]){
					$certainly = 2;
					$Nend=$hy_info[0][3];
				}else{
					if($hy_info[0][0]>$hy_info[1][0]){
						$certainly = 3;
						$Nend=$hy_info[0][3];
					}elsif($hy_info[0][0]<$hy_info[1][0]){
						$certainly = 3;
						$Nend=$hy_info[1][3];
					}else{
						if($hy_info[0][3]<=$hy_info[1][3]){
							$certainly=4;
							$Nend=$hy_info[0][3];
						}else{
							$certainly=4;
							$Nend=$hy_info[1][3];
						}
					}
				}
			}elsif($hy_info[1][4]==$hy_info[2][4]){	#2Am==3Am
				@hy_info = sort{$b->[0] <=> $a->[0]} @hy_info;
				if($hy_info[0][3]==$hy_info[1][3] && $hy_info[0][3]==$hy_info[2][3]){
					$certainly=2;
					$Nend=$hy_info[0][3];
				}elsif($hy_info[0][0]!=$hy_info[1][0]){
					$certainly=3;
					$Nend=$hy_info[0][3];
				}else{
					if($hy_info[1][0]!=$hy_info[2][0]){
						if($hy_info[0][3]==$hy_info[1][3]){
							$certainly=3;
							$Nend=$hy_info[0][3];
						}else{
							$certainly=4;
							if($hy_info[0][3]<=$hy_info[1][3]){
								$Nend=$hy_info[0][3];
							}else{
								$Nend=$hy_info[1][3];
							}
						}
					}else{
						@hy_info = sort{$a->[3] <=> $b->[3]} @hy_info;
						$certainly=4;
						$Nend=$hy_info[0][3];
					}
				}
			}
		}

		$Nend=$Nend+1;
		$def=0;

		printf WRITE $swissid.",".$TMRend.",".$Nend."\n";

		$swissid="";
		$swissde="";
		$frag=0;
		$swissoc="";
		$suswitch=0;
		$swisssu="";
		$ftnumber=0;
		$TMR="";
		@TMRregion=();
		$ftswitch=0;
		$swisssq="";
		$SEQUENCE="";
		@sq=();
		@sqn=();
		@sqA=();
		@hydra=();
		$max=0;
		@hy_info=();
		@hy_N=();
		@hy_O=();
		@hy_deff=();
		$defmax=0;
		$AmphiScore=0;
		$certainly=0;
		$Nend=0;
		$TMRstart=0;
		$TMRend=0;


	}
}
