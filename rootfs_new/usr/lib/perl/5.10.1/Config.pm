# This file was created by configpm when Perl was built. Any changes
# made to this file will be lost the next time perl is built.

# for a description of the variables, please have a look at the
# Glossary file, as written in the Porting folder, or use the url:
# http://perl5.git.perl.org/perl.git/blob/HEAD:/Porting/Glossary

package Config;
use strict;
# use warnings; Pulls in Carp
# use vars pulls in Carp
@Config::EXPORT = qw(%Config);
@Config::EXPORT_OK = qw(myconfig config_sh config_vars config_re);

# Need to stub all the functions to make code such as print Config::config_sh
# keep working

sub myconfig;
sub config_sh;
sub config_vars;
sub config_re;

my %Export_Cache = map {($_ => 1)} (@Config::EXPORT, @Config::EXPORT_OK);

our %Config;

# Define our own import method to avoid pulling in the full Exporter:
sub import {
    my $pkg = shift;
    @_ = @Config::EXPORT unless @_;

    my @funcs = grep $_ ne '%Config', @_;
    my $export_Config = @funcs < @_ ? 1 : 0;

    no strict 'refs';
    my $callpkg = caller(0);
    foreach my $func (@funcs) {
	die sprintf qq{"%s" is not exported by the %s module\n},
	    $func, __PACKAGE__ unless $Export_Cache{$func};
	*{$callpkg.'::'.$func} = \&{$func};
    }

    *{"$callpkg\::Config"} = \%Config if $export_Config;
    return;
}

die "Perl lib version (5.10.1) doesn't match executable version ($])"
    unless $^V;

$^V eq 5.10.1
    or die "Perl lib version (5.10.1) doesn't match executable version (" .
	sprintf("v%vd",$^V) . ")";


sub FETCH {
    my($self, $key) = @_;

    # check for cached value (which may be undef so we use exists not defined)
    return $self->{$key} if exists $self->{$key};

    return $self->fetch_string($key);
}
sub TIEHASH {
    bless $_[1], $_[0];
}

sub DESTROY { }

sub AUTOLOAD {
    require 'Config_heavy.pl';
    goto \&launcher unless $Config::AUTOLOAD =~ /launcher$/;
    die "&Config::AUTOLOAD failed on $Config::AUTOLOAD";
}

# tie returns the object, so the value returned to require will be true.
tie %Config, 'Config', {
    ar => 'arm-angstrom-linux-gnueabi-ar',
    archlibexp => '/usr/lib/perl/5.10',
    archname => 'arm-linux-gnueabi',
    cc => 'ccache arm-angstrom-linux-gnueabi-gcc -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -mthumb-interwork -mno-thumb',
    cccdlflags => '-fPIC',
    ccdlflags => '-Wl,-E',
    d_flexfnam => 'define',
    d_link => 'define',
    d_readlink => 'define',
    d_symlink => 'define',
    dlext => 'so',
    dlsrc => 'dl_dlopen.xs',
    dont_use_nlink => undef,
    eunicefix => ':',
    exe_ext => '',
    full_ar => 'arm-angstrom-linux-gnueabi-ar',
    inc_version_list => ' ',
    installman1dir => '/usr/share/man/man1',
    installman3dir => '/usr/share/man/man3',
    installprivlib => '/usr/share/perl/5.10',
    installscript => '/usr/bin',
    installsitearch => '/usr/local/lib/perl/5.10.1',
    installsitebin => '/usr/local/bin',
    installsiteman1dir => '/usr/local/man/man1',
    installsiteman3dir => '/usr/local/man/man3',
    installvendorman1dir => '/usr/share/man/man1',
    installvendorman3dir => '/usr/share/man/man3',
    intsize => '4',
    ld => 'ccache arm-angstrom-linux-gnueabi-gcc -march=armv7-a -mtune=cortex-a8 -mfpu=neon -mfloat-abi=softfp -mthumb-interwork -mno-thumb',
    lddlflags => '-L/usr/lib -Wl,-rpath-link,/usr/lib -Wl,-O1 -Wl,--hash-style=gnu -shared',
    ldflags => '-L/usr/lib -Wl,-rpath-link,/usr/lib -Wl,-O1 -Wl,--hash-style=gnu',
    ldlibpthname => 'LD_LIBRARY_PATH',
    lib_ext => '.a',
    libc => '/lib/libc-2.9.so',
    libpth => '/usr/local/lib /lib /usr/lib',
    obj_ext => '.o',
    osname => 'linux',
    osvers => '2.6.21-rc5',
    path_sep => ':',
    privlibexp => '/usr/share/perl/5.10',
    ranlib => ':',
    scriptdir => '/usr/bin',
    sitearchexp => '/usr/local/lib/perl/5.10.1',
    sitelibexp => '/usr/local/share/perl/5.10.1',
    so => 'so',
    useithreads => 'define',
    usevendorprefix => 'define',
    vendorarchexp => '/usr/lib/perl5',
    vendorlibexp => '/usr/share/perl5',
    version => '5.10.1',
};
