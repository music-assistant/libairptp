# libairptp and airptpd

Forked from [OwnTone/libairptp](https://github.com/owntone/libairptp). The intent is
for this repo to remain in sync with the upstream repo from which it is forked. The
only changes are for github actions to build the binaries used by Music Assistant.
It provides support for PTP timing for AirPlay2 streaming.

libairptp is a library that implements the Precision Time Protocol in the way an
AirPlay 2 sender like OwnTone needs. It is not an actual PTP clock.

libairptp is embedded in OwnTone, but needs to bind port PTP ports 319 and 320.
If the host is running more than one instance of OwnTone, or if OwnTone doesn't
have sufficient priviliges, this will not be possible. For that use case, this
repository also has **airptpd**, a small PTP daemon which multiple and/or
non-privilied instances of OwnTone can share.

airptpd is akin to [nqptp](https://github.com/mikebrady/nqptp/) and owes a lot
to that project. The main difference between the two is that airptpd is designed
to always become master clock, which a sender like OwnTone needs, while nqptp
wants to become slave i.e., follow the time set by the sender.

## Building

To build both libairptp and airptpd:

```
autoreconf -vi && ./configure --enable-daemon && make
```

To run airptpd (in background):

```
sudo ./daemon/airptpd
```

To run airptpd in foreground and verbose:

```
sudo ./daemon/airptpd -f -v
```

## Check if working

To check if the daemon is working, build with:

```
./configure --enable-daemon --enable-tests && make && make check
```

Then run airptpd in foreground as described above, and in another terminal run
`./tests/client`.

## Installing

Installing on systemd systems:

```
./configure --enable-daemon --enable-install-systemd && make
sudo make install
```

Start with `systemctl start airptpd` and check the status with
`systemctl status airptpd`.
