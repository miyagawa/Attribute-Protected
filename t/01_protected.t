use strict;
use Test;
BEGIN { plan tests => 7 }

package SomeClass;
use Attribute::Protected;

sub foo :Private   { }
sub bar :Protected { }
sub baz :Public    { }

sub call_foo {
    my $self = shift;
    $self->foo;
}

sub call_bar {
    my $self = shift;
    $self->bar;
}

package DerivedClass;
@DerivedClass::ISA = qw(SomeClass);

sub call_foo_direct {
    my $self = shift;
    $self->foo;
}

sub call_bar_direct {
    my $self = shift;
    $self->bar;
}

package main;

my $some = bless {}, 'SomeClass';

# NG: private
eval { $some->foo };
ok($@ =~ /private/);

# NG: protected
eval { $some->bar };
ok($@ =~ /protected/);

# OK: public
eval { $some->baz };
ok(! $@);

# OK: private
eval { $some->call_foo };
ok(! $@);

# OK: protected
eval { $some->call_bar };
ok(! $@);

my $derived = bless {}, 'DerivedClass';

# NG: private
eval { $derived->call_foo_direct };
ok($@ =~ /private/);

# OK: protected
eval { $derived->call_bar_direct };
ok(! $@);

