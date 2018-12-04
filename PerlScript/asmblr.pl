#!/usr/bin/perl
use strict;
use warnings;
use bignum ;

#open file
my %instructions;
my %nodes;
my $node_exec_time_sw;
my $node_exec_time_hw;
my $node_flash_hit;
my $node_has_mac_opt;
my $node_nmbr_of_vreg;   #number of virtual registers ie __r0
my @grabnodenumber;
my @grabopcode;
my $savekval;

%instructions = (
	'09'	=>	{	
	 		'instruction'	=>	'adc',
			'cycles'	=>	'4'   
		},

	'0A'	=>  {	
	 		'instruction'	=>	'adc',
			'cycles'	=>	'6'
		},
			
	'0B'	=>  {	
	 		'instruction'	=>	'adc',
			'cycles'	=>	'7'
		},
			
	'0C'	=>  {	
	 		'instruction'	=>	'adc',
			'cycles'	=>	'7'
		},
			
	'0D'	=>  {	
			'instruction'	=>	'adc',
			'cycles'	=>	'8',
		},
		
	'0E'	=>  {	
			'instruction'	=>	'adc',
			'cycles'	=>	'9',
		},
		
	'0F'	=>  {	
			'instruction'	=>	'adc',
			'cycles'	=>	'10',
		},
		
	'01'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'4',
		},
		
	'02'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'6',
		},
		
	'03'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'7',
		},
		
	'04'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'7',
		},
		
	'05'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'8',
		},
		
	'06'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'9',
		},
		
	'07'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'10',
		},
		
	'38'	=>  {	
			'instruction'	=>	'add',
			'cycles'	=>	'5',
		},
		
	'21'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'4',
		},
		
	'22'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'6',
		},
		
	'23'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'7',
		},
		
	'24'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'7',
		},
		
	'25'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'8',
		},
		
	'26'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'9',
		},
		
	'27'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'10',
		},
		
	'70'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'4',
		},
		
	'41'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'9',
		},
		
	'42'	=>  {	
			'instruction'	=>	'and',
			'cycles'	=>	'10',
		},
		
	'64'	=>  {	
			'instruction'	=>	'asl',
			'cycles'	=>	'4',
		},
		
	'65'	=>  {	
			'instruction'	=>	'asl',
			'cycles'	=>	'7',
		},
		
	'66'	=>  {	
			'instruction'	=>	'asl',
			'cycles'	=>	'8',
		},
		
	'67'	=>  {	
			'instruction'	=>	'asr',
			'cycles'	=>	'4',
		},
		
	'68'	=>  {	
			'instruction'	=>	'asr',
			'cycles'	=>	'7',
		},
		
	'69'	=>  {	
			'instruction'	=>	'asr',
			'cycles'	=>	'8',
		},
		
	'9X'	=>  {	
			'instruction'	=>	'call',
			'cycles'	=>	'11',
		},
		
	'39'	=>  {	
			'instruction'	=>	'cmp',
			'cycles'	=>	'5',
		},
		
	'3A'	=>  {	
			'instruction'	=>	'cmp',
			'cycles'	=>	'7',
		},
		
	'3B'	=>  {	
			'instruction'	=>	'cmp',
			'cycles'	=>	'8',
		},
		
	'3C'	=>  {	
			'instruction'	=>	'cmp',
			'cycles'	=>	'8',
		},
		
	'3D'	=>  {	
			'instruction'	=>	'cmp',
			'cycles'	=>	'9',
		},
		
	'73'	=>  {	
			'instruction'	=>	'cpl',
			'cycles'	=>	'4',
		},
		
	'78'	=>  {	
			'instruction'	=>	'dec',
			'cycles'	=>	'4',
		},

	'79'	=>  {	
			'instruction'	=>	'dec',
			'cycles'	=>	'4',
		},
		
	'7A'	=>  {	
			'instruction'	=>	'dec',
			'cycles'	=>	'7',
		},
		
	'7B'	=>  {	
			'instruction'	=>	'dec',
			'cycles'	=>	'8',
		},
		
	'74'	=>  {	
			'instruction'	=>	'inc',
			'cycles'	=>	'4',
		},
		
	'75'	=>  {	
			'instruction'	=>	'inc',
			'cycles'	=>	'4',
		},
		
	'76'	=>  {	
			'instruction'	=>	'inc',
			'cycles'	=>	'7',
		},
		
	'77'	=>  {	
			'instruction'	=>	'inc',
			'cycles'	=>	'8',
		},
		
	'F' 	=>  {	
			'instruction'	=>	'index',
			'cycles'	=>	'13',
		},
		
	'E' 	=>  {	
			'instruction'	=>	'jacc',
			'cycles'	=>	'7',
		},
		
	'C'  	=>  {	
			'instruction'	=>	'jc',
			'cycles'	=>	'5',
		},
		
	'8'  	=>  {	
			'instruction'	=>	'jmp',
			'cycles'	=>	'5',
		},
		
	'D' 	=>  {	
			'instruction'	=>	'jnc',
			'cycles'	=>	'5',
		},
		
	'B' 	=>  {	
			'instruction'	=>	'jnz',
			'cycles'	=>	'5',
		},
		
	'A'  	=>  {	
			'instruction'	=>	'jz',
			'cycles'	=>	'5',
		},
		
	'7C'	=>  {	
			'instruction'	=>	'lcall',
			'cycles'	=>	'13'	,
		},
		
	'7D'	=>  {	
			'instruction'	=>	'ljmp',
			'cycles'	=>	'7',
		},
		
	'4F'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'4',
		},
		
	'50'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'4',
		},
		
	'51'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'5',
		},
		
	'52'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'6',
		},
		
	'53'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'5',
		},
		
	'54'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'6',
		},
		
	'55'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'8',
		},
		
	'56'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'9',
		},
		
	'57'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'4',
		},
		
	'58'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'6',
		},
		
	'59'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'7',
		},
		
	'5A'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'5',
		},
		
	'5B'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'4',
		},
		
	'5C'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'4',
		},
		
	'5D'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'6',
		},
		
	'5E'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'7',
		},
		
	'5F'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'10',
		},
		
	'60'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'5',
		},
		
	'61'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'6',
		},
		
	'62'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'8',
		},
		
	'63'	=>  {	
			'instruction'	=>	'mov',
			'cycles'	=>	'9',
		},
		
	'3E'	=>  {	
			'instruction'	=>	'mvi',
			'cycles'	=>	'10',
		},
		
	'3F'	=>  {	
			'instruction'	=>	'mvi',
			'cycles'	=>	'10',
		},
		
	'40' 	=>  {	
			'instruction'	=>	'nop',
			'cycles'	=>	'4',
		},
		
	'29'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'4',
		},
		
	'2A'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'6',
		},
		
	'2B'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'7',
		},
		
	'2C'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'7',
		},
		
	'2D'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'8',
		},
		
	'2E'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'9',
		},
		
	'2F'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'10',
		},
		
	'43'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'9',
		},
		
	'44'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'10',
		},

	'71'	=>  {	
			'instruction'	=>	'or',
			'cycles'	=>	'4',
		},
		
	'20'	=>  {	
			'instruction'	=>	'pop',	
			'cycles'	=>	'5',
		},
		
	'18'	=>  {	
			'instruction'	=>	'pop',	
			'cycles'	=>	'5',
		},
		
	'10'	=>  {	
			'instruction'	=>	'push',	
			'cycles'	=>	'4',
		},
		
	'08'	=>  {	
			'instruction'	=>	'push',	
			'cycles'	=>	'4',
		},
		
	'7E'  	=>  {	
			'instruction'	=>	'reti',	
			'cycles'	=>	'10',
		},
		
	'7F' 	=>  {	
			'instruction'	=>	'ret',	
			'cycles'	=>	'8',
		},
		
	'6A'  	=>  {	
			'instruction'	=>	'rlc',	
			'cycles'	=>	'4',
		},
		
	'6B'	=>  {	
			'instruction'	=>	'rlc',	
			'cycles'	=>	'7',
		},
		
	'6C'	=>  {	
			'instruction'	=>	'rlc',	
			'cycles'	=>	'8',
		},
		
	'28'   	=>  {	
			'instruction'	=>	'romx',	
			'cycles'	=>	'11',
		},
		
	'6D' 	=>  {	
			'instruction'	=>	'rrc',	
			'cycles'	=>	'4',
		},
		
	'6E'	=>  {	
			'instruction'	=>	'rrc',	
			'cycles'	=>	'7',
		},
		
	'6F'	=>  {	
			'instruction'	=>	'rrc',	
			'cycles'	=>	'8',
		},
		
	'19'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'4',
		},
		
	'1A'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'6',
		},
		
	'1B'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'7',
		},
		
	'1C'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'7',
		},
		
	'1D'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'8',
		},
		
	'1E'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'9',
		},
		
	'1F'	=>  {	
			'instruction'	=>	'sbb',	
			'cycles'	=>	'10',
		},
		
	'00'  	=>  {	
			'instruction'	=>	'ssc',	
			'cycles'	=>	'15',
		},
		
	'11'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'4',
		},
		
	'12'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'6',
		},
		
	'13'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'7',
		},
		
	'14'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'7',
		},
		
	'15'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'8',
		},

	'16'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'9',
		},
		
	'17'	=>  {	
			'instruction'	=>	'sub',	
			'cycles'	=>	'10',
		},
		
	'4B'	=>  {	
			'instruction'	=>	'swap',	
			'cycles'	=>	'5',
		},
		
	'4C'	=>  {	
			'instruction'	=>	'swap',	
			'cycles'	=>	'7',
		},
		
	'5D'	=>  {	
			'instruction'	=>	'swap',	
			'cycles'	=>	'7',
		},
		
	'5E'	=>  {	
			'instruction'	=>	'swap',	
			'cycles'	=>	'5',
		},
		
	'47'	=>  {	
			'instruction'	=>	'tst',	
			'cycles'	=>	'8',
		},
		
	'48'	=>  {	
			'instruction'	=>	'tst',	
			'cycles'	=>	'9',
		},
		
	'49'	=>  {	
			'instruction'	=>	'tst',	
			'cycles'	=>	'9',
		},
		
	'4A'	=>  {	
			'instruction'	=>	'tst',	
			'cycles'	=>	'10',
		},
		
	'72'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'4',
		},

	'31'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'4',
		},

	'32'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'6',
		},

	'33'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'7',
		},

	'34'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'7',
		},

	'35'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'8',
		},

	'36'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'9',
		},

	'37'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'10',
		},

	'45'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'9',
		},

	'46'	=>  {	
			'instruction'	=>	'xor',	
			'cycles'	=>	'10',
		}
);

#end of operations table 

#estimate multiplication function that gets called: 
#_mul8:
#	CMP	[X],0		#8
#	JZ	accu    	#5
#	AND	F, 251  	#4
#	RRC	[X]     	#7
#	JNC	shift   	#5
#	ADD	A,[X+16]	#7
#shift:                 
#	ASL	[X+16]  	#8
#	JMP	_mul8   	#5
#accu:                  
#	ADD	[37],A  	#7
#	MOV	A,0     	#4
#	INC	X       	#4
#	INC	[3]     	#7
#	CMP	[3],16  	#8
#	JNZ	_mul8   	#5
#.terminate             
#	RET			#8
#-->estimate execution time: 92
my $mult_sw_exec_time = 92;

my $filename = $ARGV[0];
my $multiply_jmp_addr = $ARGV[1];

	print "input file: $filename \n";

	#initialize
	$node_exec_time_sw = 0;
	$node_exec_time_hw = 0;
	$node_flash_hit	   = 0;
	$node_nmbr_of_vreg = 0;
	$node_has_mac_opt  = 0;

	open (my $logfh, '>', $filename.'-execution.log'); 
	#create output file
	open (my $node_val, '>', $filename.'-execution.temp'); 

	#read input file	
	open(IN, "<", $filename) ;
	# print IN;
	while(<IN>){
	
		#clear newline character	
		chomp;

		#create area holding string in each element	
		#print "from node file: $_ \n";
		
		$_ =~ s/^\s+//;			#remove space from beginning of line
		printf $logfh "Line Contents: $_ \n\n";

		#check if a new node is found, if yes - close out the previous node with its values
		if($_ =~ /^\*NODE/) {
			#this updated to next node
			@grabnodenumber = split (/:/, $_);
		
			#if its the first node- there was no previous node with values so skip this	
			if ($grabnodenumber[1] != '1') {
				#save values from previous node

				#update value for hw estimate
				if ($node_has_mac_opt eq 1) 
				{
					$node_exec_time_hw = .1 * $node_exec_time_sw;
				} else {
					$node_exec_time_hw = .7 * $node_exec_time_sw - .6 * $node_nmbr_of_vreg;
				}

				$savekval = $grabnodenumber[1] -1;
				$nodes{$savekval}{'node_exec_time_sw'} 	= $node_exec_time_sw;
				$nodes{$savekval}{'node_exec_time_hw'} 	= $node_exec_time_hw;
				$nodes{$savekval}{'node_flash_hits'} 	= $node_flash_hit;
				$nodes{$savekval}{'node_has_mac_opt'} 	= $node_has_mac_opt;

				#print to encoded file
				printf $node_val $nodes{$savekval}{'node_exec_time_sw'}."\t";
				printf $node_val $nodes{$savekval}{'node_exec_time_hw'}."\t";
				printf $node_val $nodes{$savekval}{'node_flash_hits'}."\t";
				printf $node_val $nodes{$savekval}{'node_has_mac_opt'}."\t";
				printf $node_val "\n";

				
				#summary of node
				printf $logfh "New node found\n";
				printf $logfh "**********************************************************\n";
				printf $logfh "		exec_time[sw] [ $node_exec_time_sw ] 		 \n";
				printf $logfh "		exec_time[hw] [ $node_exec_time_hw ] 		 \n";
				printf $logfh "		flash_hits    [ $node_flash_hit    ] 		 \n";
				printf $logfh "		has_mac_opt   [ $node_has_mac_opt  ] 		 \n";
				printf $logfh "**********************************************************\n";
				printf $logfh "\n\n";
			   }

			printf $logfh "---------------------Enter New Node: $_-------------------\n";
			printf $logfh  "\n";

			#save new NODE line values
			$nodes{key} = $grabnodenumber[1]; 
			$nodes{$grabnodenumber[1]}{'partition'} = $grabnodenumber[2]; 

			#print node number to file
			printf $node_val "$grabnodenumber[1]\t";			#hash key prints a different value
		
			#reset node execution and memory time
			$node_exec_time_sw = 0;
			$node_exec_time_hw = 0;
			$node_flash_hit	   = 0;
			$node_has_mac_opt  = 0;
			$node_nmbr_of_vreg = 0;
	  	}	

		#instruction 	
		if($_ =~ /^[0-9|A-Z]{4}/) { 
		 	printf $logfh "Line in Node $grabnodenumber[1] : $_\n";

		 	#check if line also has a flash/e2prom read/write
			if ($_ =~ /(flash|e2prom).*(write|read)/i) {
				$node_flash_hit = $node_flash_hit + 1;
				printf $logfh "opcode is flash read/write with total: $node_flash_hit hits for this node\n";
			}
				
			if ($_ =~ /$multiply_jmp_addr/) {
				$node_has_mac_opt  = 1;
				$node_exec_time_sw = $node_exec_time_sw + $mult_sw_exec_time;
				printf $logfh "opcode is calling a multiply task \n";
			}

			if ($_ =~ /__r[0-9]/) {
				$node_nmbr_of_vreg = $node_nmbr_of_vreg + 1;
				printf $logfh "opcode uses compilers virtual registers \n";
			}

			@grabopcode = split (/[\s+]/, $_);

			#problem with jumps/unique commands
			if (@grabopcode[1] =~ /8[0-9|A-Z]|A[0-9|A-Z]|B[0-9|A-Z]|C[0-9|A-Z]|D[0-9|A-Z]|E[0-9|A-Z]/) {
				print $logfh "!!!Error!!! $grabopcode[1] \n";
				$grabopcode[1] = substr $grabopcode[1], 0 , 1;
				print $logfh "!!!Error!!! $grabopcode[1] \n";
			}

			printf $logfh "Opcode is: $grabopcode[1] \n";
			printf $logfh "Instruction: $instructions{$grabopcode[1]}{instruction}\n";	
			printf $logfh "Number of cycles: $instructions{$grabopcode[1]}{cycles}\n\n";

			# add clock cucles for execution time
			$node_exec_time_sw = $node_exec_time_sw +  $instructions{$grabopcode[1]}{cycles};
		

			#print info to log file
			printf $logfh  "-------\n";
	   	}
	}	


	#update value for hw estimate
	if ($node_has_mac_opt eq 1) {
		$node_exec_time_hw = .1 * $node_exec_time_sw;
	} else {
		$node_exec_time_hw = .7 * $node_exec_time_sw - .6 * $node_nmbr_of_vreg;
	}

	#save values from previous node -- this applies to last node
	$nodes{$grabnodenumber[1]}{'node_exec_time_sw'} = $node_exec_time_sw;
	$nodes{$grabnodenumber[1]}{'node_exec_time_hw'} = $node_exec_time_hw;
	$nodes{$grabnodenumber[1]}{'node_flash_hits'} 	= $node_flash_hit;
	$nodes{$grabnodenumber[1]}{'node_has_mac_opt'} 	= $node_has_mac_opt;

	printf $node_val $nodes{$grabnodenumber[1]}{'node_exec_time_sw'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_exec_time_hw'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_flash_hits'}."\t";
	printf $node_val $nodes{$grabnodenumber[1]}{'node_has_mac_opt'}."\t";


	close $node_val;

	#open file and put number of nodes as the first line
	open my $in,  '<', $filename.'-execution.temp'   or die "Can't read old file: $!";
	open my $out, '>', $filename.'-process-graph.txt' or die "Can't write new file: $!";

   	#$grabnodenumber holds last node
	print $out $grabnodenumber[1]."\n"; # Add this line to the top\n"; # <--- HERE'S THE MAGIC

	while( <$in> ) {
	    print $out $_;
	}

	close $out;

	print "finished\n";

	close $logfh;


