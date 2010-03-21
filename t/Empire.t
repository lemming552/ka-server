use lib '../lib';
use Test::More tests => 19;
use Test::Deep;
use Data::Dumper;
use 5.010;

my $result;

use TestHelper;
my $tester = TestHelper->new;
$tester->cleanup;


$result = $tester->post('empire', 'is_name_available', [$tester->empire_name]);
is($result->{result}, 1, 'empire name is available');

my $empire = {
    name        => $tester->empire_name,
    password    => $tester->empire_password,
    password1   => $tester->empire_password,
};

$empire->{name} = 'XX>';
$result = $tester->post('empire', 'create', $empire);
is($result->{error}{code}, 1000, 'empire name has funky chars');

$empire->{name} = '';
$result = $tester->post('empire', 'create', $empire);
is($result->{error}{code}, 1000, 'empire name too short');

$empire->{name} = 'abc def ghi jkl mno pqr stu vwx yz 0123456789';
$result = $tester->post('empire', 'create', $empire);
is($result->{error}{code}, 1000, 'empire name too long');

$empire->{name} = $tester->empire_name;
$empire->{password} = 'abc';
$result = $tester->post('empire', 'create', $empire);
is($result->{error}{code}, 1001, 'empire password too short');

$empire->{password} = 'abc123';
$result = $tester->post('empire', 'create', $empire);
is($result->{error}{code}, 1001, 'empire passwords do not match');

$empire->{password} = $tester->empire_password;
$result = $tester->post('empire', 'create', $empire);
my $empire_id = $result->{result};
ok(defined $empire_id, 'empire created');

$result = $tester->post('empire', 'is_name_available', [$tester->empire_name]);
is($result->{error}{code}, 1000, 'empire name not available');

$result = $tester->post('empire', 'found', [$empire_id]);
my $session_id = $result->{result}{session_id};
ok(defined $session_id, 'empire logged in after foundation');

$result = $tester->post('empire', 'logout', [$session_id]);
is($result->{result}, 1, 'logout');

$result = $tester->post('empire', 'login', [$tester->empire_name,$tester->empire_password]);
ok(exists $result->{result}{session_id}, 'login');
$session_id = $result->{result}{session_id};

$result = $tester->post('empire', 'set_status_message', [$session_id,'woot!']);

$result = $tester->post('empire', 'view_profile', [$session_id]);
ok(exists $result->{result}{profile}, 'view profile');
ok(exists $result->{result}{profile}{status_message}, 'can set status message');
my @medal_ids = keys %{$result->{result}{profile}{medals}};
my $private_medal_id = pop @medal_ids;

my %profile = (
    status_message  => 'Whoopie!',
    description     => 'test',
    public_medals   => \@medal_ids,
);
$result = $tester->post('empire', 'edit_profile', [$session_id, \%profile]);
is($result->{result}{profile}{description}, 'test', 'description set in profile');
is($result->{result}{profile}{status_message}, 'Whoopie!', 'status message set in profile');
is($result->{result}{profile}{medals}{$private_medal_id}{public}, 0, 'medal set private');

$result = $tester->post('empire', 'view_public_profile', [$session_id, $empire_id]);
is($result->{result}{profile}{status_message}, 'Whoopie!', 'public profile works');

$result = $tester->post('empire', 'find', [$session_id, 'Test']);
is($result->{result}{empires}[0]{id}, $empire_id, 'empire search works');
cmp_ok($result->{result}{status}{server}{version}, '>=', 1, 'version number');


END {
    $tester->cleanup;
}
