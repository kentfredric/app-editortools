package App::EditorTools::Command::IntroduceTemporaryVariable;

use strict;
use warnings;

use App::EditorTools -command;

sub opt_spec {
    return (
        [ "start_location|s=s", "The line,column of the start" ],
        [ "end_location|e=s",   "The line,column of the end" ],
        [ "varname|v=s",        "The new variable name" ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;

    $self->usage_error("start_location is required")
      unless $opt->{start_location};
    $self->usage_error("end_location is required") unless $opt->{end_location};

    $opt->{start} = [ grep {/\d+/} split /,/, $opt->{start_location} ];
    $opt->{end}   = [ grep {/\d+/} split /,/, $opt->{end_location} ];

    $self->usage_error("start_location must be <Int>,<Int>")
      unless scalar @{ $opt->{start} } == 2;
    $self->usage_error("end_location must be <Int>,<Int>")
      unless scalar @{ $opt->{end} } == 2;

    return 1;
}

sub execute {
    my ( $self, $opt, $arg ) = @_;

    my $doc_as_str = eval { local $/ = undef; <STDIN> };

    require PPIx::EditorTools::IntroduceTemporaryVariable;
    my $munged = PPIx::EditorTools::IntroduceTemporaryVariable->new->introduce(
        code           => $doc_as_str,
        start_location => $opt->{start},
        end_location   => $opt->{end},
        varname        => $opt->{varname},
    );

    print $munged->code;
    return;
}

1;

=head1 NAME

App::EditorTools::Command::IntroduceTemporaryVariable - Introduce a Temporary Variable 

=head1 DESCRIPTION

See L<App::EditorTools> for documentation.

=head1 AUTHOR

Mark Grimes, E<lt>mgrimes@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Mark Grimes

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.


