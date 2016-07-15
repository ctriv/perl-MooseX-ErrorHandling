package MooseX::ErrorHandling;

use strict;
use warnings;
use Module::Runtime qw(use_package_optimistically);
use Moose::Util qw(add_method_modifier);
use base 'Exporter';

our @EXPORT = qw(whenMooseThrows insteadDo);


=head1 NAME

MooseX::ErrorHandling - Insert Abstract Here

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut



=example

    whenMooseThrows CanOnlyConsumeRole => insteadDo {
        My::Exception->new(
            error => $_->message
        );
    };

=cut

sub whenMooseThrows ($$) {
    my ($type, $cb) = @_;

    # first make sure the exception class is loaded, as we're about to monkey
    # around in it.
    my $exception_class = "Moose::Exception::$type";
    use_package_optimistically($exception_class);

    add_method_modifier($exception_class, 'around', [new => sub {
        my ($orig, $class, @args) = @_;
        local $_ = $class->$orig(@args);
        return $cb->();
    }]);
}

sub insteadDo (&) {
    return shift;
}


1;
__END__
