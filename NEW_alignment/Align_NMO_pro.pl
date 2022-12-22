
open(fasta, "npm_98.fas");
open(WRITE,">FT269_pro2.csv");

$, = ",";
$\ = "\n";
$A=-0.49;
$M=0;


while(<fasta>){
	chomp;

	if($_ =~ /^>/){
		$temp = substr($_,0,100);
	}
	elsif($_ =~ /^X/){
		$SEQUENCE=substr($_,0,10000);
		@sq=split(//,$SEQUENCE);
		@sqn=();
		@sqA=();

		for($i=0;$i<@sq;$i++){
			if($sq[$i] =~ /A/){
				$sqn[$i] = 1.8;
			}
			elsif($sq[$i] =~ /C/){
				$sqn[$i]=2.5;
			}
			elsif($sq[$i] =~ /D/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /E/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /F/){
				$sqn[$i]=2.8;
			}
			elsif($sq[$i] =~ /G/){
				$sqn[$i] = -0.4;
			}
			elsif($sq[$i] =~ /H/){
				$sqn[$i]=-3.2;
			}
			elsif($sq[$i] =~ /I/){
				$sqn[$i]=4.5;
			}
			elsif($sq[$i] =~ /K/){
				$sqn[$i]=-3.9;
			}
			elsif($sq[$i] =~ /L/){
				$sqn[$i]=3.8;
			}
			elsif($sq[$i] =~ /M/){
				$sqn[$i]=1.9;
			}
			elsif($sq[$i] =~ /N/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /P/){
				$sqn[$i]=-1.6;
			}
			elsif($sq[$i] =~ /Q/){
				$sqn[$i]=-3.5;
			}
			elsif($sq[$i] =~ /R/){
				$sqn[$i]=-4.5;
			}
			elsif($sq[$i] =~ /S/){
				$sqn[$i]=-0.8;
			}
			elsif($sq[$i] =~ /T/){
				$sqn[$i]=-0.7;
			}
			elsif($sq[$i] =~ /V/){
				$sqn[$i]=4.2;
			}
			elsif($sq[$i] =~ /W/){
				$sqn[$i]=-0.9;
			}
			elsif($sq[$i] =~ /Y/){
				$sqn[$i]=-1.3;
			}
			else{
				printf "error" . $temp . $i. "\n";
			}
		}

		for($i=0;$i<@sq;$i++){
			if($sq[$i] =~ /A/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /C/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /D/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /E/){
				$sqA[$i]=1.27;
			}
			elsif($sq[$i] =~ /F/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /G/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /H/){
				$sqA[$i]=1.45;
			}
			elsif($sq[$i] =~ /I/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /K/){
				$sqA[$i]=3.67;
			}
			elsif($sq[$i] =~ /L/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /M/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /N/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /P/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /Q/){
				$sqA[$i]=1.25;
			}
			elsif($sq[$i] =~ /R/){
				$sqA[$i]=2.45;
			}
			elsif($sq[$i] =~ /S/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /T/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /V/){
				$sqA[$i]=0;
			}
			elsif($sq[$i] =~ /W/){
				$sqA[$i]=6.93;
			}
			elsif($sq[$i] =~ /Y/){
				$sqA[$i]=5.06;
			}
			else{
				printf "error" . $temp . $i. "\n";
			}
		}

		printf WRITE $temp."\n";

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

		if($max-20>0){
			$start=$max-20; #start:-20 end:-5
		}
		else{
			$start=0;
		}

		@hy_info=((["hy_def","N","O","Nend","AmphiScore"]));

		for($N=2;$N<=5;$N++){
			for($O=2;$O<=5;$O++){

				my @hy_N=();
				my @hy_M=();
				my @hy_def=();
				my $defmax=0;
				$Nend=0;
				$Ostart=0;
				$defmax=$start;

				for($i=$start;$i<$max;$i++){

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

				for($i=$start;$i<=$start+25-$N-$M;$i++){
					$hy_def[$i] = -$hy_N[$i]+$hy_O[$i+$N+$M];	#startとendで符号変化 start:-N, end:+N
					if($hy_def[$i]>$hy_def[$defmax]){
						$defmax=$i;
					}
				}
				$Nend=$defmax+$N-1;

				$AmphiScore=0;
				for($i=0;$i<$N;$i++){
					$AmphiScore+=$sqA[$Nend-$i];
				}

				for($i=1;$i<$O+1;$i++){
					$AmphiScore+=$sqA[$Nend+$i];
				}
				$AmphiScore=$AmphiScore/($N+$O);

				$Nend=$defmax+$N-1;

				push (@hy_info,([$hy_def[$defmax],$N,$O,$Nend,$AmphiScore]));

			}
		}

		@delete=shift @hy_info;

		@hy_info = sort{$b->[0] <=> $a->[0]} @hy_info;

		for($k=0;$k<3;$k++){
			for($l=0;$l<5;$l++){
				printf WRITE $hy_info[$k][$l].",";
			}
			printf WRITE "\n";
		}

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

		if($certainly==0){#Amphi1位と2位が一致
			if($hy_info[1][4] != $hy_info[2][4]){	#Amphi2位と3位が不一致　1位か2位から選択
				if($hy_info[0][3] == $hy_info[1][3]){
					$certainly = 2;
					$Nend=$hy_info[0][3];
				}else{
					if($hy_info[0][0]>$hy_info[1][0]){
						$certainly = 3;
						$Nend=$hy_info[0][3];
					}elsif($hy_info[0][0]<$hy_info[1][0]){
						$certainly = 3;
						$Nend=$hy_info[0][3];
					}
				}
			}
		}


		$Nendmin=$hy_info[0][3];
		$Nendmax=$hy_info[0][3];

		for($k=1;$k<3;$k++){
			if($Nendmax < $hy_info[$k][3]){
				$Nendmax=$hy_info[$k][3];
			}
			if($Nendmin > $hy_info[$k][3]){
				$Nendmin=$hy_info[$k][3];
			}
		}
		if($certainly!=1){
			printf WRITE ",,,,,";

			for($i=$Nendmin-15;$i<=$Nendmax+35;$i++){
				if($i<=0 || $i>=@sq){
					printf WRITE "X,";
				}
				else{
					printf WRITE $sq[$i].",";
				}
			}
			printf WRITE "\n";

		}


	}
}
print chr(7);	#終了時に音が鳴ります
