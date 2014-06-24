#=================================================================================
#
# vlc.pl 
# script that allows you to echo currently playing song in vlc to irssi
#
#=================================================================================
# INITIAL SECTION
#=================================================================================
use utf8;
use Irssi;
#use Irssi::Irc;
use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "1.0";

%IRSSI = (
	authors     =>  'Pietro',
	contact     =>  'pimster@cock.li',
	name        =>  'vlc',
	description =>  'vlc now playing script',
	license     =>  'watever',
);
#=================================================================================
# NOW PLAYING SECTION
#=================================================================================
sub now_playing {

	my ($data, $server, $witem) = @_;

	my $PID	    = `pgrep vlc`;
	$PID    =~ s/\012//g;
	my $path    = "/proc/".$PID."/fd/*";
#	my $test    = `echo "$path" | hd`;
#	$witem->command("me $test");
	    $path   =~ s/\012//g;
	    $path   = `/bin/readlink $path`;
	    $path   = $1 if $path =~ m/(\/home.*?(mp3|flac))/;
#	    $path   =~ s/\012//g;
		if ($path) {
		
		if ($witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {	
		my $trackinfo	=	`id3v2 -R "$path" | awk -f "getfields.awk"`;
		    #my $tags  =	`mp3info -p %a "$path"`;
		    #my $title   =	`mp3info -p %t "$path"`;
		    #my $album   =	`mp3info -p %l "$path"`;
		my $bitrate =	`mp3info -r m -p %r "$path"`;
		my $output = "np: $trackinfo\00315 | \00314$bitrate kbps"; # here set desired format of output

			$witem->command("me $output")
		} else {
			Irssi::print("This is not a channel/query window");
		}

	} else {
		Irssi::print("Vlc is not playing anything at the moment.");
	}
}

#=================================================================================
# COMMAND BINDINGS
#=================================================================================
Irssi::command_bind('np', 'now_playing');
#=================================================================================
# END OF FILE
#=================================================================================
