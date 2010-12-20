# --
# 000-login.t - frontend tests for login
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: 000-login.t,v 1.5 2010-12-20 11:32:48 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Selenium;
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

my $sel = Kernel::System::UnitTest::Selenium->new(
    Verbose        => 1,
    UnitTestObject => $Self,
);

my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

$sel->open_ok("${ScriptAlias}index.pl?Action=Logout");

# prevent version information disclosure
$Self->False( $sel->is_text_present("Powered"), 'No version information disclosure' );

$sel->is_editable_ok("User");
$sel->type_ok( "User", "root\@localhost" );
$sel->is_editable_ok("Password");
$sel->type_ok( "Password", "root" );
$sel->is_visible_ok("//button[\@id='LoginButton']");
$sel->click_ok("//button[\@id='LoginButton']") || die "Could not submit login form";

$sel->wait_for_page_to_load_ok("30000");
$sel->click_ok("//a[\@id='LogoutButton']") || die "Could not submit logout form";

$sel->wait_for_page_to_load_ok("30000");
$sel->is_editable_ok("User");
$sel->is_editable_ok("Password");
$sel->is_visible_ok("//button[\@id='LoginButton']");

# $sel->_ok();

1;
