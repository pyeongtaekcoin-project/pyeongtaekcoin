#!/usr/bin/env bash

export LC_ALL=C
TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
BUILDDIR=${BUILDDIR:-$TOPDIR}

BINDIR=${BINDIR:-$BUILDDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

PYEONGTAEKCOIND=${PYEONGTAEKCOIND:-$BINDIR/pyeongtaekcoind}
PYEONGTAEKCOINCLI=${PYEONGTAEKCOINCLI:-$BINDIR/pyeongtaekcoin-cli}
PYEONGTAEKCOINTX=${PYEONGTAEKCOINTX:-$BINDIR/pyeongtaekcoin-tx}
PYEONGTAEKCOINQT=${PYEONGTAEKCOINQT:-$BINDIR/qt/pyeongtaekcoin-qt}

[ ! -x $PYEONGTAEKCOIND ] && echo "$PYEONGTAEKCOIND not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
PTCVER=($($PYEONGTAEKCOINCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for pyeongtaekcoind if --version-string is not set,
# but has different outcomes for pyeongtaekcoin-qt and pyeongtaekcoin-cli.
echo "[COPYRIGHT]" > footer.h2m
$PYEONGTAEKCOIND --version | sed -n '1!p' >> footer.h2m

for cmd in $PYEONGTAEKCOIND $PYEONGTAEKCOINCLI $PYEONGTAEKCOINTX $PYEONGTAEKCOINQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${PTCVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${PTCVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
