package KA::RPC::Building::WaterPurification;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'KA::RPC::Building';

sub app_url {
    return '/waterpurification';
}

sub model_class {
    return 'KA::DB::Result::Building::Water::Purification';
}

no Moose;
__PACKAGE__->meta->make_immutable;

