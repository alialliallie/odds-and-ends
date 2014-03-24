#!/usr/bin/perl -w
# a2ps web interface

use strict;
use CGI;
my $query = CGI->new();

# #defines
my $MORE_INCREMENT = 5;
my $INIT_FILES = 5;
my $TEMP_BASE = '/home/httpd/html/local/a2pst';

# How are we called? Convert or not?
unless ($query->param('convert')) {
	# Output form & help
	print $query->header(), $query->start_html('a2ps conversion');
	generate_help();
	unless ($query->param('files')) {
	    generate_form($INIT_FILES);
	} else {
	    generate_form($query->param('files'));
	} 
	print $query->end_html;
} else {
	# a2ps and return
	#make temp dir
	my $date_week = `date +%H%M%S%U`;
	chop $date_week;
	my $temp_url = "a2ps$date_week";
	my $temp_dir = "$TEMP_BASE/a2ps$date_week";
	mkdir("$temp_dir",0777);
	#get file names
	my ($key, $Filename, $File_Handle);
	my @FilesUsed;
	foreach $key ($query->param()) {
		next if ($key =~ /^\s*$/);
		next if ($query->param($key) =~ /^\s*$/);
		next if ($key !~ /^file_(\d+)$/);

		if ($query->param($key) =~ /([^\/\\]+)$/) {
			$Filename = $1;
			$Filename =~ s/^\.+//;
			$File_Handle = $query->param($key);
		} else {
			my $FILENAME_IN_QUESTION = $query->param($key);
			
			print "Content-type: text/plain\n\n";
			print "$FILENAME_IN_QUESTION is a bad name.\n";
			print "Files may not have forward or backward slashes in\n";
			print "their names. Also, they may not be prefixed with one\n";
			print "(or more) periods.\n";
			`rm -rf $temp_dir`;
			exit;
		}

        if (!open(OUTFILE, ">$temp_dir/$Filename")) {
            print "Content-type: text/plain\n\n";
            print "Error:\n";
            print "-------------------------\n";
            print "File: $temp_dir/$Filename\n";
            print "-------------------------\n";
	        print "There was an error opening the Output File\n";
    	    print "for Writing.\n\n";
        	print "Make sure that the directory:\n";
	        print "$temp_dir/\n";
    	    print "has been chmodded with the permissions '777'.\n\n";
        	print "Also, make sure that if your attempting\n";
	        print "to overwrite an existing file, that the\n";
    	    print "existing file is chmodded '666' or better.\n\n";
	        print "The Error message below should help you diagnose\n";
    	    print "the problem.\n\n";
        	print "Error: $!\n";
			`rm -rf $temp_dir`;
            exit;
        }

		undef my $Buffer;
		
        while (read($File_Handle,$Buffer,1024)) {
            print OUTFILE $Buffer;
        }
		
		push(@FilesUsed, "$temp_dir/$Filename");

        close($File_Handle);
		close(OUTFILE);

        chmod (0666, "$temp_dir/$Filename");
	}

	#construct option string
    my %options = ('charline', '-l', 'linepage', '-L', 'pagesheet', '-',
		   'prettyprint', '-E', 'highlight', '--highlight-level=',
		   'Line Numbers', '--line-numbers=', 'Borders', '--borders=');
	my $a2ps_options;

	foreach ($query->param()) {
		my $arg = $query->param($_);
		if ($options{$_}) {
			if ($arg eq 'auto') {
				$a2ps_options .= " $options{$_}";
			} else {
				$a2ps_options .= " $options{$_}$arg";
			}
		}
	}
	my $outputfile;
	my $out = $query->param('output');
	if ($out eq 'file' || $out eq 'pdf') {
		$outputfile = "-o $temp_dir/outputfile.ps";
	} elsif ($out eq 'printer') {
		$outputfile = '--printer=Spot';
	} else {
		print "Content-type: text/plain\n\n";
		print "Something went wrong with output selection: $out was selected.";
		`rm -rf $temp_dir`;
		exit;
	}

	#a2ps & return
	my $a2ps_command =
		"a2ps $a2ps_options $outputfile @FilesUsed";
	`$a2ps_command`;

	if ($out eq 'file') {
		print $query->header(), $query->start_html("PS Result");
		print $query->a({-href=>"http://foxbox.dhs.org/local/a2pst/$temp_url/outputfile.ps"},"Result");
		print end_html;
#		if (open(PSFILE,"$temp_dir/outputfile.ps")) {
#			print "Content-type: application/ps\n\n";
#			while (<PSFILE>) {
#				print $_;
#			}
#			close(PSFILE);
#		} else {
#			print "Content-type: text/plain\n\n";
#			print "Error opening output file $temp_dir/outputfile.ps :\n";
#			print $!;
#		}
	} elsif ($out eq 'pdf') {
		`ps2pdf $temp_dir/outputfile.ps $temp_dir/outputfile.pdf`;
		print $query->header(), $query->start_html("PDF Result");
		print $query->a({-href=>"http://foxbox.dhs.org/local/a2pst/$temp_url/outputfile.pdf"},"Result");
		print end_html;

#		if (open(PDFFILE,"$temp_dir/outputfile.pdf")) {
#			print "Content-type: application/pdf\n\n";
#			while (<PDFFILE>) {
#				print $_;
#			}
#			close(PDFFILE);
#		} else {
#			print "Content-type: text/plain\n\n";
#			print "Error opening output file $temp_dir/outputfile.pdf :\n";
#			print $!;
#		}
	} elsif ($out eq 'printer') {
		print "Content-type: text/plain\n\n";
		print "Sent to the printer. Hope it's on.\n";
	}

	#clean up
#	`rm -rf $temp_dir`;
}

sub generate_help {
	print <<__END_HTML__
<ol>
	<li>Select the files you wish to convert with the 'Browse...' buttons.</li>
	<li>Use the option form to select any changes to default options you want.</li>
	<li>Press 'convert' and save the resulting file.</li>
</ol>
__END_HTML__
}

sub generate_form {
	my $numfiles = $_[0];
	print '<hr>';
	print $query->start_multipart_form();
	# show options
	print '<p>Characters per line', $query->textfield('charline',128,3,3);
	print ' Lines per page', $query->textfield('linepage',80,3,3);
	print ' Pages per sheet', $query->popup_menu('pagesheet',[1..9],2);

	print '<p>Pretty-print type', $query->popup_menu('prettyprint',
		['auto','plain','c','cpp','java','perl','html','udiff','wdiff'],'auto');
	print ' Highlight level', $query->popup_menu('highlight',
		['none','normal','heavy'],'normal');

	print '<p>', $query->checkbox('Line Numbers','checked','1');
	print $query->checkbox('Borders','checked','yes');
	print '<p>Output: ', $query->radio_group(-name=>'output',
		-values=>['file','pdf','printer'],
		-default=>'file');
	my $newfiles = $numfiles+$MORE_INCREMENT;
	print '<p>', $query->a({-href=>$query->url() . "?files=$newfiles"},'More files...');
	print '<hr>';
	# show upload boxes
	my $i;
	for ($i = 0; $i<=$numfiles; $i++) {
		print $query->filefield("file_$i",'',50,80), "<BR>\n";
	}
	print '<p>', $query->reset(), $query->submit('convert');
	print $query->endform();
}



