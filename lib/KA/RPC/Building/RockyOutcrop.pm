package KA::RPC::Building::RockyOutcrop;

use Moose;
use utf8;
no warnings qw(uninitialized);
extends 'KA::RPC::Building';

sub app_url {
    return '/rockyoutcrop';
}

sub model_class {
    return 'KA::DB::Result::Building::Permanent::RockyOutcrop';
}

no Moose;
__PACKAGE__->meta->make_immutable;

