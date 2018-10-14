package App::VersioningSchemeUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our %SPEC;

our %arg_scheme = (
    scheme => {
        schema => ['str*', match=>qr/\A\w+\z/],
        req => 1,
        cmdline_aliases => {s=>{}},
        completion => sub {
            require Complete::Module;
            my %args = @_;
            Complete::Module::complete_module(
                word => $args{word},
                ns_prefix => 'Versioning::Scheme',
            );
        },
    },
);

our %arg0_v = (
    v => {
        schema => ['str*'],
        pos => 0,
        req => 1,
    },
);

our %arg0_v1 = (
    v1 => {
        schema => ['str*'],
        pos => 0,
        req => 1,
    },
);

our %arg1_v2 = (
    v2 => {
        schema => ['str*'],
        pos => 1,
        req => 1,
    },
);

sub _load_vs_mod {
    my $args = shift;

    my $mod = "Versioning::Scheme::$args->{scheme}";
    (my $modpm = "$mod.pm") =~ s!::!/!g;
    require $modpm;
    $mod;
}

$SPEC{list_versioning_schemes} = {
    v => 1.1,
    summary => 'List available versioning schemes',
};
sub list_versioning_schemes {
    require PERLANCAR::Module::List;
    my $mods = PERLANCAR::Module::List::list_modules(
        'Versioning::Scheme::', {list_modules=>1});
    my @rows;
    for (sort keys %$mods) { s/\AVersioning::Scheme:://; push @rows, $_ }
    [200, "OK", \@rows];
}

$SPEC{bump_version} = {
    v => 1.1,
    summary => 'Bump version number according to specified scheme',
    args => {
        %arg_scheme,
        %arg0_v,
        # XXX options
    },
};
sub bump_version {
    my %args = @_;

    my $mod = _load_vs_mod(\%args);
    [200, "OK", $mod->bump_version($args{v})];
}

$SPEC{cmp_version} = {
    v => 1.1,
    summary => 'Compare two version number according to specified scheme',
    args => {
        %arg_scheme,
        %arg0_v1,
        %arg1_v2,
    },
};
sub cmp_version {
    my %args = @_;

    my $mod = _load_vs_mod(\%args);
    [200, "OK", $mod->cmp_version($args{v1}, $args{v2})];
}

$SPEC{is_valid_version} = {
    v => 1.1,
    summary => 'Check whether version number is valid, '.
        'according to specified scheme',
    args => {
        %arg_scheme,
        %arg0_v,
        # XXX options
    },
};
sub is_valid_version {
    my %args = @_;

    my $mod = _load_vs_mod(\%args);
    my $res = $mod->is_valid_version($args{v}) ? 1:0;
    [200, "OK", $res, {'cmdline.result'=>'', 'cmdline.exit_code'=>$res ? 0:1}];
}

$SPEC{normalize_version} = {
    v => 1.1,
    summary => 'Normalize version number according to specified scheme',
    args => {
        %arg_scheme,
        %arg0_v,
        # XXX options
    },
};
sub normalize_version {
    my %args = @_;

    my $mod = _load_vs_mod(\%args);
    [200, "OK", $mod->normalize_version($args{v})];
}

$SPEC{parse_version} = {
    v => 1.1,
    summary => 'Parse version number according to specified scheme',
    args => {
        %arg_scheme,
        %arg0_v,
        # XXX options
    },
};
sub parse_version {
    my %args = @_;

    my $mod = _load_vs_mod(\%args);
    [200, "OK", $mod->parse_version($args{v})];
}

1;
#ABSTRACT: Utilities related to Versioning::Scheme

=head1 DESCRIPTION

This distributions provides the following command-line utilities:

# INSERT_EXECS_LIST


=head1 SEE ALSO

=cut
