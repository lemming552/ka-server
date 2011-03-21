package Lacuna::DB::Result::Propositions::DowngradeModule;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'Lacuna::DB::Result::Propositions';

before pass => sub {
    my ($self) = @_;
    my $station = $self->station;
    my $building = $station->buildings->find($self->scratch->{building_id});
    if (defined $building) {
        $building->downgrade;
    }
    else {
        $self->pass_extra_message('Unfortunately, by the time the proposition passed, the module had been demolished, effectively nullifying the vote.');
    }
};

no Moose;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);
