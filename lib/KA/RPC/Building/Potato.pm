package KA::RPC::Building::Potato;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'KA::RPC::Building';

sub app_url {
    return '/potato';
}

sub model_class {
    return 'KA::DB::Result::Building::Food::Potato';
}

no Moose;
__PACKAGE__->meta->make_immutable;

