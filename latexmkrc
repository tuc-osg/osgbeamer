#!perl
#################################################
# OLLM - OSG LaTeX Lecture Maker
# 
# An extension for latexmk to support 
# osgbeamer.cls
#################################################
my $ollm_version='0.9.1';
#################################################
# REMARK:
# This is my first piece of Perl code I've
# ever written. 
# Thus, it probably is in a bad style and it is 
# quite unelegant.
# However, it seems to work.
#################################################
use strict;
use 5.30.3;
use warnings;
use feature 'signatures','lexical_subs','switch';
no warnings 'experimental::signatures','experimental::smartmatch';

use Cwd qw(cwd getcwd);
use File::Basename;
use List::MoreUtils qw(firstidx);
use Data::Dumper qw(Dumper);    # nur zum Debuggen
# The following variables belong to latexmk. We reimport
# them to avoid warnings.
our (@default_files, $pdf_mode, $pdflatex, $lualatex,
$biber, $jobname, $pre_tex_code, $clean_ext, 
$compiling_cmd, $silent, $recorder,  $aux);
sub is_ollmtree;
sub doc_dirs;
sub lect_descr;

#####################################
# Config-Variablen und Defaults     #
#####################################
our $doctype="slides";
our $lang='';
our $lectconfig='lectdates';
our $lectureprefix="lecture";
our $defaultlanguage='de';
our $osgbeamer_dir = '';
our $first_chapter_number = undef;
our @first_chapter_number = undef;
our $shared_source_dir ='../Include';
our $shared_data_dir='../Ref';

@default_files=("main.tex");
$pdf_mode=4;
$lualatex = 'lualatex --synctex=1 %O %P';
$pre_tex_code = '';
$silent = 1;
$recorder=1;
$cleanup_mode=3; # aux-Dateien werden nicht gelöscht
$clean_ext="bbl ext nav snm vrb lbr fls log fdb_latexmk";
$compiling_cmd="tput setaf 4; echo \"Start TeXing %B...\";  tput init";


sub is_ollmtree {
    # is_ollmtree()
    #
    # Returns true (1) if the current directory has the form
    # of a lecture-topic directury, else false (0)
    my $dir = basename(getcwd());
    if ($dir =~ /^[0-9][0-9][0-9][as]?-.*/) {1} else {0}
}

sub doc_dirs ($type) {
    # doc_dirs(type)
    #
    # type: string (slides|script|article|lang)
    #
    # Returns all topic directories of the given type, that
    # are neighbors of the currenct one, in order.
    if (!is_ollmtree()) {
	my @empty = ();
	return @empty;
    }
    my @dirs=glob ('../[0-9][0-9][0-9]-*');              # common directories
    if ($type eq 'slides'){                              # type-specific directories
	@dirs= (@dirs,glob ( '../[0-9][0-9][0-9]s-*'));
    }
    elsif (($type eq 'script') or ($type eq 'article')) {
	@dirs= (@dirs,glob ( '../[0-9][0-9][0-9]a-*'));
    }
    foreach my $d ( @dirs ) {                            # cut prefix path
	$d = basename($d);
    }
    @dirs = sort @dirs;
    @dirs;
}

sub ollm_print_help {
    print 
	"OLLM - OSG LaTeX Lecture Maker $ollm_version: an extension for latexmk to support osgbeamer.cls\n\n",
	"Usage: \n",
        " Generate documents:\n",
	"  latexmk [<ollm options>] [<doctype>] [<latexmk options>] [<file>]\n",
	"  <doctype>: 'slides'|'handout'|'article' (default: 'slides')\n\n",
	"  <ollm options> (without a dash!):\n",
	"   standalone: disable most features of OLLM\n",
	"   debug|verbose: additional information\n",
        "   lang=[de|en]: select language\n",
	"   ollmconfig=<file>: reads configuration from <file> (default: '../config.pl')\n\n",
	"  <latexmk options>: see 'latexmk -h'\n\n",
	"  <file> LaTeX file (default: 'main.tex'), *must* use osgbeamer class.\n\n",
	" Deploy documents:\n",
        " latexmk [lang=de|en|all] publish-slides | publish-script | publish-handout \n";
    exit;
}

sub lect_descr($type) {
    # lect_descr(type)
    #
    # type: string (slides|script|article)
    #
    # Returns for current topic directory the 
    # sequence number (index) and the topic. The first index is 0.
    if (!is_ollmtree()) {
	my $empty = undef;
	return $empty;
    } 
    my $topic_dir = basename(getcwd());
    my @all_dirs = doc_dirs($type);
    my $index = firstidx { /$topic_dir/ } @all_dirs;
    my ( $topic ) = $topic_dir=~ /[0-9][0-9][0-9][as]?\-(.*)\s*$/;
    return ( $index,  $topic);
}

sub tex_path($path){
    ensure_path( 'TEXINPUTS',$path);
}

sub process_options(@options) {
    # Process the options.
    # Here, the real work is done.
    my $number;
    my $topic;
    my $current_first_chapter;
    my $standalone;
    my $config_file = '../config.pl';
    $standalone = 0;
    foreach (@options) {
	given($_){
	    when($_ eq 'slides') { $doctype = 'slides'; }
	    when($_ ~~ ['article','script']) { $doctype = 'script'; }
	    when($_ eq 'handout') { $doctype = 'handout'; }
	    when($_ eq 'standalone') { $standalone = 1; }
	    when($_ eq 'lang=de') { $lang = 'de'; }
	    when($_ eq 'lang=en') { $lang = 'en'; }
	    when(index($_,'ollmconfig') == 0) {
	    	my $pos = index($_,'=')+1;
		$config_file = substr($_,$pos);
	    }
	    # 'verbose' and 'debug' is the same.
	    # $silence is a latexmk variable
	    when($_ eq 'verbose') { $silent = 0; }	
	    when($_ eq 'debug')   { $silent = 0; }
	    when($_ eq 'help')    {
		ollm_print_help(); 
	    }
	    # print_help() belongs to latexmk
	    when($_ ~~ ['-h','--h','-help','--help']) { print_help(); exit; } 
	    # ToDo: Befehle für Veröffentlichung
	}
    }
    if ((!is_ollmtree()) && ($standalone == 0)) {
	die' No proper directory structure. Try \'standalone\'';
    }
    if ($standalone == 0) { #&& ( -e $config_file)) {
      unless ( -e  $config_file) {
	die" Can't find config file '".$config_file."'";
      }
      print "\nRead '$config_file'\n";
      my $return;
      unless ($return = do $config_file) {
	warn "can't parse $config_file: $@" if $@;
	warn "can't do $config_file: $!"    unless defined $return;
	warn "can't run $config_file"       unless $return;
      }
      if ($osgbeamer_dir ne '') { tex_path($osgbeamer_dir); }
      tex_path($shared_source_dir);
    }
    if ($lang eq ''){
      $lang = $defaultlanguage;
    }
    if ($standalone == 0) {
	# In case of a lecture series, we have to provide suitable information to ensure 
	# continuation.
	# While doctype, language and (absolute) number is provided via jobname, the
	# \ollm macro holds:
	# - \OsgShareDataPath: path to common shared data
	# - \OsgCurrentDir:    own directory (ToDo: still needed?)
	# - \OsgFirstChapter:  number of the first chapter (to avoid errors/warnings due to missing lastpage
	#
	# 
	($number,$topic) = lect_descr($doctype);
	if (defined($first_chapter_number)) {
	    $current_first_chapter = $first_chapter_number;
	} elsif (defined($first_chapter_number[0])) {
	    if ($doctype eq 'script') {
		$current_first_chapter =  $first_chapter_number[1];
	    } else {
		$current_first_chapter =  $first_chapter_number[0];
	    }
	} else {
	    $current_first_chapter =  1;
	}
	$number = $number + $current_first_chapter;	    
	$number=sprintf("%02d", $number);
	# 
	$pre_tex_code='\gdef\ollm{\gdef\OsgShareDataPath{'.$shared_data_dir.'}\gdef\OsgLectConfig{'.$lectconfig.'}\gdef\OsgCurrentDir{../'.basename(getcwd()).'}\gdef\OsgFirstChapter{'.$current_first_chapter.'}}';
	# <lectureprefix>-<number>-<doctype>-<language>-<topic>
	$jobname = $lectureprefix.'-'.$number.'-'.$doctype.'-'.$lang.'-'.$topic;
    } else { # standalone, nothing is done
	# ToDo: should there be a doctype mechanism to allow handouts? Probably yes.
    }
}

# Script options that can be used by OLLM.
# All other will be passed to latexmk.
my $commandregex = qr/slides|script|handout|standalone|debug|verbose|lang|ollmconfig|help|-h|--h|-help|--help/;

my @ollmOptions = grep (/$commandregex/, @ARGV);
@ARGV =  grep (!/$commandregex/, @ARGV);

process_options(@ollmOptions);

#sub mylatex {
#my @args = @_;
# Possible preprocessing here
#return system 'pdflatex', @args;
#}


#$pdflatex="pdflatex -shell-escape -file-line-error -synctex=1 %O %P";


#####################################
# Dependencies                      #
#####################################

add_cus_dep('eps','pdf',0,'eps2pdf');
sub eps2pdf{
    system("epspdf \"$_[0].eps\"" );
}
add_cus_dep('jpg','pdf',0,'jpg2pdf');
sub jpg2pdf{
    system("convert \"$_[0].jpg\" \"$_[0].pdf\"" );
}

add_cus_dep('jpeg','pdf',0,'jpeg2pdf');
sub jpeg2pdf{
    system("convert \"$_[0].jpeg\" \"$_[0].pdf\"" );
}

add_cus_dep('gif','pdf',0,'gif2pdf');
sub gif2pdf{
    system("convert \"$_[0].gif\" \"$_[0].pdf\"" );
}
sub rail{
    system("rail \"$_[0]\"" );
}
# Einkommentieren, um den Index zu bauen (Rekursion nicht vergessen)
#$makeindex='texindy -M lang/german/duden-utf8 -M base/ff-ranges -M base/latin-lettergroups -M ../Include/localidx';

# add_input_ext('rao');
# add_input_ext('rai');
add_cus_dep('rai','rao',0,'rail');

